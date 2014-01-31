class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user   # rating kuuluu myös käyttäjään

  def to_s
    "#{(Beer.find_by id:beer_id).name} #{score.to_s}"
  end

end