class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length:    {minimum: 3,
                                   maximum: 15}

  has_many :ratings # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships

end