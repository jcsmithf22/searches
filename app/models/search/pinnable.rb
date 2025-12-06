module Search::Pinnable
  extend ActiveSupport::Concern

  included do
    has_many :pins, dependent: :destroy
  end
end
