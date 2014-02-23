class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: {less_than_or_equal_to: ->(_) { Time.now.year }}

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  has_many :beers, :dependent => :destroy
  has_many :ratings, :through => :beers


  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by { |b| -(b.average_rating||0) }
    topn = Array.new
    for i in 1..n
      topn.append sorted_by_rating_in_desc_order[i]
    end
    topn
  end
end
