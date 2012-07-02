require_relative 'page'

module Flatfish

  class Pleuronectiformes
    attr_reader :config, :schema

    # load in the config
    def initialize(ymal)
      @config = YAML.load_file(ymal)
      db_conn() # establish AR conn
    end

    # main loop for flatfish
    def ingurgitate
      create_media unless Flatfish::Media.table_exists?

      @config["types"].each do |k,v|
        next if v["csv"].nil?
        @csv_file = v["csv"]
        @host = v["host"]
        create_klass(k)
        parse
      end
    end

    # Create the Klass
    # create table if necessary: table must exist!
    # create dynamic model
    def create_klass(k)
        # commence hackery
        create_table(k) unless ActiveRecord::Base.connection.tables.include?(k.tableize)
        @klass = Class.new(Page)
        @klass.table_name = k.tableize
    end

    def create_table(klass)
      load_csv
      Flatfish::CreateKlass.setup(@schema, klass)
    end

    def create_media
      Flatfish::CreateMedia.setup
    end

    #load csv, set schema
    def load_csv
      csv = CSV.read(@csv_file)
      @schema = csv.shift[3..-1]
      return csv
    end

    # loop thru csv
    def parse
      csv = load_csv
      @cnt = 0
      csv.each do |row|
        begin
          break if @cnt == @config['max_rows']
          @cnt += 1
          page = @klass.find_or_create_by_url(row[0])
          puts "created or found page #{page.id} with URL #{row[0]}"
          page.setup(row, @config, @schema, @host)
          page.process
          page.save!
        rescue Exception => e
          if e.message =~ /(redirection forbidden|404 Not Found)/
            ap "URL: #{page.url} #{e}"
          else
            ap "URL: #{page.url} ERROR: #{e} BACKTRACE: #{e.backtrace}"
          end
        end
      end
    end


    #def output_schema 
    #  File.open('schema.yaml', 'w') do |out|
    #    page_attributes, media_attributes = Hash.new 
    #    Flatfish::Page.new.attributes.each { |a| page_attributes = {a[0] => Flatfish::Page.columns_hash[a[0]].sql_type}}
    #    Flatfish::Media.new.attributes.each { |a| media_attributes = {a[0] => Flatfish::Media.columns_hash[a[0]].sql_type}}
    #    output = {"schema" => [{"pages" => [page_attributes, {"primary key" => "id"}], {"media" => [media_attributes, {"primary key" => "id"}]} }]}
    #    out.write output
    #  end
    #end
    # db conn


    def db_conn
      ActiveRecord::Base.establish_connection(
                                        :adapter=> "mysql2",
                                        :host => "localhost",
                                        :username => @config['db_user'],
                                        :password => @config['db_pass'],
                                        :database=> @config['db']
                                       )
    end

  end

end
