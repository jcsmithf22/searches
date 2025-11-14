# frozen_string_literal: true

module Ebay
  def self.configure
    yield Config
  end

  def self.browse(**params)
    Browse.new(**params)
  end
end
