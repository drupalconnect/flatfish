require 'rubygems'
require 'yaml'
require 'csv'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'fileutils'
require 'active_record'

require 'awesome_print'

require 'flatfish/pleuronectiformes'
require 'flatfish/page'
require 'flatfish/media'
require 'flatfish/create_tables'
require 'flatfish/url'

#API
module Flatfish 
  class << self
    #allow alias Flatfish.new etc
    def new(yml = nil)
      yml ||= './config.yml'
      if !File.exists?(yml) then
        puts "ERROR: No Config file"
        exit 1
      end
      Flatfish::Pleuronectiformes.new(yml)
    end

    def ingurgitate
      new.ingurgitate
    end
  end

  VERSION = "0.3.2"
end
