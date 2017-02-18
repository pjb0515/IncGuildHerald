class Guild < ActiveRecord::Base
  has_many :players
  
  enum realm: [ :hibernia, :midgard, :albion, "7" ]
end
