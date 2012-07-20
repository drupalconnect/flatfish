require_relative 'page'

module Flatfish

  class Pleuronectiformes
    attr_reader :config, :schema

    # load in the config
    def initialize(ymal)
      @config = YAML.load_file(ymal)
      db_conn() # establish AR conn
      @klasses = Hash.new
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
      output_schema
    end

    # Create the Klass
    # create table if necessary: table must exist!
    # create dynamic model
    def create_klass(k)
        # commence hackery
        create_table(k) unless ActiveRecord::Base.connection.tables.include?(k.tableize)
        @klass = Class.new(Page)
        @klasses[k] = @klass
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


    # generate a dynamic schema.yml for Migrate mapping
    def output_schema
      # TODO REFACTOR THIS ISH
      klasses = @klasses
      File.open('schema.yml', 'w') do |out|
        output = Hash.new
        output["schema"] = []
        klasses["Media"] = Flatfish::Media

        klasses.each_pair do |k,v|
          klass_attributes = Hash.new
          v.new.attributes.each { |a| klass_attributes[a[0]] = split_type(v.columns_hash[a[0]].sql_type) }
          output["schema"] << {k => [{"machine_name" => k.tableize}, {"fields" => klass_attributes}, {"primary key" => ["id"]}]}
        end
        out.write output.to_yaml
      end
    end

    # helper function to convert AR sql_type to
    # Drupal format;
    # eg :type => varchar(255) to :type => varchar, :length => 255
    def split_type type
      if type =~ /\(/ then
        x = type.split("(")
        return {"type" => x[0], "length" => x[1].sub(")","").to_i }
      else
        return {"type" => type}
      end
    end


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
