class Rating < ActiveRecord::Base

  validates :score, numericality: {greater_than_or_equal_to: 1,
                                   less_than_or_equal_to: 50,
                                   only_integer: true}

  scope :recent, order("updated_at desc").limit(5)

  belongs_to :beer
  belongs_to :user # rating kuuluu myös käyttäjään


  def to_s
    "#{(Beer.find_by id: beer_id).name} #{score.to_s}"
  end

end