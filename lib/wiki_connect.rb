require 'net/http'
require 'uri'

class WikiConnect
  def initialize(config)
    @config = config.dup
    @config['host'] = URI.parse(@config['host'])
  end

  def source(params)
    params = params.dup.merge!(@config['source'].params)
  end

  def revisions(params)
    params = params.dup.merge!(@config['revisions'].params)
  end

  def path_from_params(params)
    @config['path'] + '?' + params.each_with_object([]) do |(k,v), rv|
      uri_key = URI.encode k
      if v.is_a? Array
        uri_val = URI.encode v
      else
        uri_val = v.map{|el| URI.encode(el)}.join('%7C')
      end
    end.join('&')
  end

  def uri_from_params(params)
    @config['host'].join path_from_params(params)
  end
end

