module Flatfish 
  class Media < ActiveRecord::Base
    attr_reader :url, :data
  end
end
