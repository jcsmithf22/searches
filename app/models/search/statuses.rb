module Search::Statuses
  extend ActiveSupport::Concern

  included do
    enum :status, %w[ drafted published ].index_by(&:itself)

    attr_reader :initial_status

    before_save :update_created_at_on_publication
    before_save :remember_initial_status

    scope :published_or_drafted_by, ->(user) { where(status: :published).or(where(status: :drafted, creator: user)) }
  end

  def publish
    published!
  end

  def was_just_published?
    initial_status&.drafted? && status_in_database.inquiry.published?
  end

  private
    def update_created_at_on_publication
      if will_save_change_to_status? && status_in_database.inquiry.drafted?
        self.created_at = Time.current
      end
    end

    # So that we can check it in callbacks when other operations in the transaction clean the changes.
    def remember_initial_status
      if will_save_change_to_status?
        @initial_status ||= status_in_database.to_s.inquiry
      end
    end
end
