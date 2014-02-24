class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :style
  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> {uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style_id, presence: true

  def to_s
    "#{name} (#{brewery.name})"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by { |b| -(b.average_rating||0) }
    topn = Array.new
    for i in 1..n
      topn.append sorted_by_rating_in_desc_order[i]
    end
    topn
  end

end
