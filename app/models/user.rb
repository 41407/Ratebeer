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

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    # Alustetaan uusi hajautustaulu
    hash = Hash.new

    # Haetaan ensin kaikki käyttäjän arvostelemat tyylit hashiin
    ratings.each {|r| hash[(Beer.find_by id:r.beer_id).style] = 0}

    # Kasvatetaan kunkin tyylin saamaa kokonaispistemäärää
    ratings.each {|r| hash[(Beer.find_by id:r.beer_id).style] = hash[(Beer.find_by id:r.beer_id).style]+r.score}

    # Palautetaan hashin suurin avain
    hash.max_by{|k,v| v}[0]
  end
end
