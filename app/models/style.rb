class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, :through => :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by { |s| -(s.average_rating||0) }
    topn = Array.new
    for i in 1..n
      topn.append sorted_by_rating_in_desc_order[i]
    end
    topn
  end
end
