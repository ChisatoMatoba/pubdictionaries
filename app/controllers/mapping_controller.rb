class MappingController < ApplicationController
  def find_ids
    params[:dictionaries] = params[:dictionary] if params.has_key?(:dictionary) && !params.has_key?(:dictionaries)
    params[:labels] = params[:label] if params.has_key?(:label) && !params.has_key?(:labels)

    @dictionaries = Dictionary.active.accessible(current_user)
    @selected = params[:dictionaries].present? ?
      params[:dictionaries].split(',').collect{|d| Dictionary.active.accessible(current_user).find_by_title(d.strip).id} : []

    @result = {}
    if params[:labels]
      rich = true if params[:rich] == 'true' || params[:rich] == '1'
      threshold = params[:threshold].to_f if params[:threshold].present?
      labels = params[:labels].strip.split(/[\n\t\r|]+/)
      @result = Dictionary.find_ids(labels, @selected, threshold, rich)
    end

    respond_to do |format|
      format.html
      format.json {render json:@result}
    end
  end

  def text_annotation
    params[:dictionaries] = params[:dictionary] if params.has_key?(:dictionary) && !params.has_key?(:dictionaries)
    @dictionaries = Dictionary.active.accessible(current_user)
    @selected = params[:dictionaries].present? ?
      params[:dictionaries].split(',').collect{|d| Dictionary.active.accessible(current_user).find_by_title(d.strip).id} : []

    @result = {}
    if params[:text]
      rich = true if params[:rich] == 'true' || params[:rich] == '1'
      tokens_len_min = params[:tokens_len_min].to_i if params[:tokens_len_min].present?
      tokens_len_max = params[:tokens_len_max].to_i if params[:tokens_len_max].present?
      threshold = params[:threshold].to_f if params[:threshold].present?
      text = params[:text].strip
      annotator = TextAnnotator.new(@selected, tokens_len_min, tokens_len_max, threshold)
      @result = annotator.annotate(text)
    end

    respond_to do |format|
      format.html
      format.json {render json:@result}
    end
  end

  def call_ws
    rest_url = params[:rest_url]
    delimiter = params[:delimiter]
    labels = params[:labels]
    method = 1

    response = begin
      if method == 0
        RestClient.get rest_url, {:params => call_params, :accept => :json}
      else
        RestClient.post rest_url, labels.split(delimiter).to_json, :content_type => :json, :accept => :json
      end
    rescue => e
      raise IOError, "Invalid connection"
    end

    raise IOError, "Bad gateway" unless response.code == 200

    begin
      result = JSON.parse response, :symbolize_names => true
    rescue => e
      raise IOError, "Received a non-JSON object: [#{response}]"
    end

    render :find_ids
  end

  def autocomplete_expression_name
    labels = Label.suggest({query: params[:term], operator: 'and'}).records.records.to_a.collect{|label| label.value}
    unique_labels = labels.compact.uniq if labels.present?
    render json: unique_labels.to_json if unique_labels.present?
  end
end
