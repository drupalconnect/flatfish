module Flatfish 

  class CreateKlass < ActiveRecord::Migration
    # assume every klass has a URL, Path, Title
    # pass in additional columns from CSV
    def self.setup(schema, klass)
      k = klass.tableize.to_sym
      create_table(k) do |t|
        t.string :url
        t.string :path
        t.string :title
      end
      schema.each do |column|
        add_column(k, column.gsub(/\s+/, '_').downcase.to_sym, :text)
      end
    end
  end

  class CreateMedia < ActiveRecord::Migration
    #create media table
    def self.setup
      create_table :media do |t|
        t.string :url
        t.binary :contents, :limit => 4294967295
      end
    end
  end

end
