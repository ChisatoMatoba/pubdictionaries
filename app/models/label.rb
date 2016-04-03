class Label < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: {
    analysis: {
      analyzer: {
        standard_normalization: {
          tokenizer: :standard,
          filter: [:standard, :lowercase, :asciifolding, :snowball]
        }
      }
    }
  } do
    mappings do
      indexes :value, type: :string, analyzer: :standard_normalization, index_options: :docs
      indexes :labels_dictionaries do
        indexes :id, type: :long
      end
    end
  end

  has_many :entries
  has_many :dictionaries, :through => :entries

  attr_accessible :value

  scope :diff, where(['created_at > ?', 2.hour.ago])
  scope :added_after, -> (time) {where('created_at > ?', time)}

  def self.get_by_value(value)
    label = self.find_by_value(value)
    if label.nil?
      label = self.new({value: value})
      label.save
    end
    label
  end

  def entries_count_up
    increment!(:entries_count)
  end

  def entries_count_down
    decrement!(:entries_count)
    destroy if entries_count == 0
  end

  def as_indexed_json(options={})
    as_json(
      only: [:id, :value],
      include: {dictionaries: {only: :id}}
    )
  end

  def self.search_as_text(keywords, dictionary = nil, page)
    self.__elasticsearch__.search(
      query: {
        filtered: {
          query: {
            match: {
              value: {
                query: keywords,
                operator: "and",
                fuzziness: "AUTO"
              }
            }
          },
          filter: {
            terms: {
              "dictionaries.id" => [dictionary.id]
            }
          }
        }
      }
    ).page(page)
  end

  def self.search_as_term(keywords, dictionaries = [])
    self.__elasticsearch__.search(
      min_score: 0.8,
      query: {
        filtered: {
          query: {
            match: {
              value: {
                query: keywords,
                operator: "and",
                fuzziness: "AUTO"
              }
            }
          },
          filter: {
            terms: {
              "dictionaries.id" => dictionaries
            }
          }
        }
      }
    )
  end

  def self.suggest(arguments = {})
    operator = 'or'
    if arguments[:operator] == 'exact'
      operator = 'and' 
    end
    size = arguments[:size].to_i if arguments[:size].present?

    self.__elasticsearch__.search(
      min_score: 1,
      size: 10,
      sort: [
        '_score'
      ],
      query: {
        match: {
          value: {
            query: arguments[:query],
            type: :phrase_prefix,
            operator: operator,
            fuzziness: 0
          }
        }
      }
    )
  end
end
