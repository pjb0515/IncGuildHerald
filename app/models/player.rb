class Player < ActiveRecord::Base
  belongs_to :guild
  has_many :player_rankings
  has_many :rp_snapshots

end
