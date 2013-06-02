module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, :as => :attachment, :dependent => :destroy
  end

  def vote(user, value)
    my_vote = self.votes.where(:user_id => user.id).first
    if my_vote
      my_vote.vote = value
      my_vote.save
      refresh_totals()
      self.save()
    elsif self.votes.create(:user_id => user.id, :vote => value)

      if(value.to_i > 0)
        up_votes = self.up_votes || 0
        self.up_votes = up_votes + 1
      else
        down_votes = self.down_votes || 0
        self.down_votes = down_votes + 1
      end
      self.save
      return {:success => true}
    else
      return {:success => false, :message => "Error creating vote entry."}
    end
  end

  def refresh_totals
    self.up_votes = self.votes.where(:vote => 1).count
    self.down_votes = self.votes.where(:vote => -1).count
  end

  def total_votes
    self.up_votes = self.up_votes || 0
    self.down_votes = self.down_votes || 0
    return self.up_votes - self.down_votes
  end

end
