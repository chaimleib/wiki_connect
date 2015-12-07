require 'net/http'
require 'uri'

class WikiConnect
  def initialize(config)
    @config = config.dup
  end

  def source(params)
    params = params.merge(@config['source']['params'])
    uri = uri_from_params(params, 'source')
  end

  def revisions(params)
    params = params.merge(@config['revisions']['params'])
    uri = uri_from_params(params, 'revisions')
  end

  def defaults(key, cmd)
    if @config.has_key?(cmd) && @config[cmd].has_key?(key)
      return @config[cmd][key]
    elsif @config.has_key?('defaults') && @config['defaults'].has_key?(key)
      return @config['defaults'][key]
    else
      raise "ERROR: WikiConnect defaults: no such key `#{key}` in group `#{cmd}`"
    end
  end

  def path_from_params(params, group)
    rv = []
    rv << defaults('path', group)
    rv << '?'
    rv << params.map do |(k,v)|
      uri_key = URI.encode k.to_s
      if v.is_a? Array
        uri_val = v.map{|el| URI.encode(el.to_s)}.join('%7C')
      else
        uri_val = URI.encode v.to_s
      end
      uri_key + '=' + uri_val
    end.join('&')
    rv.join
  end

  def uri_from_params(params, group)
    defaults('host', group) + path_from_params(params, group)
  end
end

