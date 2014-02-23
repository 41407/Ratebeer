class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
            length: {minimum: 3,
                     maximum: 15}


  validates :password, length: {minimum: 4}
  validates :password, format: {with: /(?=.*[A-Z])(?=.*\d)/,
                                message: "Password must contain at least one uppercase character from A-Z, and at least one number"}

  has_many :ratings, :dependent => :destroy # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    return nil if ratings.empty?
    favorite :brewery
  end


  def favorite_style
    return nil if ratings.empty?
    favorite :style
  end

  def favorite(category)
    return nil if ratings.empty?
    rating_pairs = rated(category).inject([]) do |pairs, item|
      pairs << [item, rating_average(category, item)]
    end
    rating_pairs.sort_by { |s| s.last }.last.first
  end

  def self.top_reviewers(n)
    sorted_by_ratings_in_desc_order = User.all.sort_by { |u| -(u.ratings.count||0) }
    topn = Array.new
    for i in 1..n
      topn.append sorted_by_ratings_in_desc_order[i]
    end
    topn
  end

  private

  def rating_average(category, item)
    ratings_of_item = ratings.select { |r| r.beer.send(category)==item }
    return 0 if ratings_of_item.empty?
    ratings_of_item.inject(0.0) { |sum, r| sum+r.score } / ratings_of_item.count
  end

  def rated(category)
    ratings.map { |r| r.beer.send(category) }.uniq
  end
end