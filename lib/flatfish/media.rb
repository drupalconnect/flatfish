module Flatfish 
  class Media < ActiveRecord::Base
    attr_reader :url, :contents
  end
end
