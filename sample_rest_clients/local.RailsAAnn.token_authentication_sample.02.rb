#!/usr/bin/env ruby

require 'uri'
require 'json'
require 'rest_client'



# 2. Post the request
json_annotation = { 
	"text" => "Negative regulation of human immunodeficiency virus type 1 expression in monocytes: role of the 65-kDa plus 50-kDa NF-kappa B dimer.\nAlthough monocytic cells can provide a reservoir for viral production in vivo, their regulation of human immunodeficiency virus type 1 (HIV-1) transcription can be either latent, restricted, or productive. These differences in gene expression have not been molecularly defined. In THP-1 cells with restricted HIV expression, there is an absence of DNA-protein binding complex formation with the HIV-1 promoter-enhancer associated with markedly less viral RNA production. This absence of binding was localized to the NF-kappa B region of the HIV-1 enhancer; the 65-kDa plus 50-kDa NF-kappa B heterodimer was preferentially lost. Adding purified NF-kappa B protein to nuclear extracts from cells with restricted expression overcomes this lack of binding. In addition, treatment of these nuclear extracts with sodium deoxycholate restored their ability to form the heterodimer, suggesting the presence of an inhibitor of NF-kappa B activity. Furthermore, treatment of nuclear extracts from these cells that had restricted expression with lipopolysaccharide increased viral production and NF-kappa B activity. Antiserum specific for NF-kappa B binding proteins, but not c-rel-specific antiserum, disrupted heterodimer complex formation. Thus, both NF-kappa B-binding complexes are needed for optimal viral transcription. Binding of the 65-kDa plus 50-kDa heterodimer to the HIV-1 enhancer can be negatively regulated in monocytes, providing one mechanism restricting HIV-1 gene expression."
	}
json_options = {
	"task" => "annotation", 
	"matching_method" => "exact",
	"min_tokens" => 2,
	"threshold" => 0.7,
	}

dictionary_name = "EntrezGene - Homo Sapiens"
rest_api        = URI.escape("localhost:3000/dictionaries/#{dictionary_name}/text_annotations.json")
resource = RestClient::Resource.new( 
	rest_api.to_s,
	:timeout => 300, 
	:open_timeout => 300 )
res = resource.post( 
		:user         => {:email=>"priancho@gmail.com", :password=>"password"},
		:annotation   => json_annotation.to_json,
		:options      => json_options.to_json,
		:content_type => :json,
		:accept       => :json,
      )

$stderr.puts "Response code: #{res.code}"
$stderr.puts JSON.parse(res)["text"]
JSON.parse(res)["denotations"].each do |entry|
	$stderr.puts entry.inspect
end
$stderr.puts



