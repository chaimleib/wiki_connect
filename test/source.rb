require 'yaml'
require 'awesome_print'
require_relative '../lib/wiki_connect'

this_dir = File.expand_path File.dirname __FILE__
opts = YAML.load_file File.join(this_dir, '../config/defaults.yml')

wc = WikiConnect.new opts
ap wc.source page: 'Trie'

