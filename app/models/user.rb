class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length:    {minimum: 3,
                                   maximum: 15}


  validates :password, length:  {minimum: 4}
  validates :password, format:  {with: /(?=.*[A-Z])(?=.*\d)/,
  message: "Password must contain at least one uppercase character from A-Z, and at least one number"}

  has_many :ratings, :dependent => :destroy # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships

end
