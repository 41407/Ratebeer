class BeermappingApi
  def self.places_in(city)

    city = city.downcase
    Rails.cache.fetch(city, expires_in: 7.days.from_now) { fetch_places_in(city) }
  end

  private
  def self.fetch_places_in(city)
    #    url = "http://beermapping.com/webservice/loccity/#{key}/"
    url = "http://stark-oasis-9187.herokuapp.com/api/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do |set, place|
      set << Place.new(place)
    end
  end

  def self.key
    ENV['APIKEY']
  end


  # Joudut luonnollisesti tallettamaan API-avaimen myös herokun konsolista
  # käsin siinä vaiheessa kun deployaat sovelluksesi uuden version.
  #
  # NVM Avain on nyt määritetty herokun ympäristömuuuttujaan.
end

