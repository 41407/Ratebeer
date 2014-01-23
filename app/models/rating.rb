class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    "#{(Beer.find_by id:beer_id).name} #{score.to_s}"
  end

end