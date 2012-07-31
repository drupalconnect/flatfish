# -*- coding: utf-8 -*- #specify UTF-8 (unicode) characters
require_relative 'url'

module Flatfish 

  class Page < ActiveRecord::Base
    self.abstract_class = true
    @columns = []
    extend Flatfish::Url

    attr_reader :url, :data
    attr_accessor :cd

    # Setup - unpack the vars for the web page to be scraped
    #
    # csv - an array w/ all of the page specific
    # config - has some key deets, where to save images, etc that the page has to know
    # schema - dynamic column headers
    def setup(csv, config, schema, host)
      #parse the csv
      @url, @path, @title  = csv[0], csv[1], csv[2]
      @fields = []
      csv[3..-1].each do |field|
        unless field.nil?
          @fields << (field.strip! || field)
        else
          @fields << -1 #flag
        end
      end

      #current directory, we want http://example.com/about/ or http://example.com/home/
      @cd = (@url[-1,1] == '/')? @url: @url.slice(0..@url.rindex('/'))
      @schema = schema
      @host = host
      @local_source = config['local_source']

      # handle url == host, fix mangled @cd
      if @url == @host
        @cd = @url + '/'
      end
      Flatfish::Url.creds = {:http_basic_authentication => [config['basic_auth_user'], config['basic_auth_pass']]}
    end

    def process
      load_html
      self.attributes = prep
    end

    # load html from local or web
    def load_html
      file = @local_source + @url.sub(@host, '')
      if (@url != @host) && !@local_source.nil? && File.exists?(file)
        f = File.open(file)
        @doc = Nokogiri::XML(f)
        f.close
      else
        html = Flatfish::Url.open_url(@url)
        @doc = Nokogiri::HTML(html)
      end
    end

    def prep
      #default to csv, fallback to title element
      @title = @title.nil? ? @doc.title: @title

      #build a hash of field => data
      html = Hash.new
      @fields.each_with_index do |selectors, i|
        next if -1 == selectors
        html[@schema[i]] = ''
        selectors.split('|').each do |selector|
          update_hrefs(selector)
          update_imgs(selector)
          if @doc.css(selector).nil? then
            field = ''
          else
            # sub tokens and gnarly MS Quotes
            field = @doc.css(selector).to_s.gsub("%5BFLATFISH", '[').gsub("FLATFISH%5D", ']').gsub(/[”“]/, '"').gsub(/[‘’]/, "'")
          end
          html[@schema[i]] +=  field
        end
      end
      @data = {
        'url' => @url,
        'title' => @title,
        'path' => @path
      }
      @data.merge!(html)
    end

    # processes link tags
    # absolutifies and passes media links on for tokenization
    def update_hrefs(css_selector)
      @doc.css(css_selector + ' a').each do |a|

        #TODO finalize list of supported file types 
        href = Flatfish::Url.absolutify(a['href'], @cd)
        valid_exts = ['.doc', '.docx', '.pdf', '.pptx', '.ppt', '.xls', '.xlsx']
        if href =~ /#{@host}/  && valid_exts.include?(File.extname(href))
          media = get_media(href)
          href = "[FLATFISHmedia:#{media.id}FLATFISH]"
        end
        a['href'] = href
      end
    end

    # processes image tags
    # absolutifies images and passes internal ones on for tokenization
    def update_imgs(css_selector)
      @doc.css(css_selector + ' img').each do |img|
        next if img['src'].nil?

        # absolutify and tokenize our images
        src = Flatfish::Url.absolutify(img['src'], @cd)
        if src =~ /#{@host}/
          # check to see if it already exists
          media = get_media(src)
          img['src'] = "[FLATFISHmedia:#{media.id}FLATFISH]"
        end
      end
    end

    #TODO replace w/ find_or_create
    def get_media(url)
      media = Flatfish::Media.find_by_url(url)
      if media.nil?
        media = Flatfish::Media.create(:url => url) do |m|
          m.contents = read_in_blob(url)
        end
      end
      media
    end 

    # read in blob
    def read_in_blob(url)
      # assume local file
      file = url.sub(@host, @local_source)

      unless @local_source.nil? || !File.exists?(file)
        blob = file.read
      else
        blob = Flatfish::Url.open_url(URI.escape(url))
      end
      blob
    end

  end
end
