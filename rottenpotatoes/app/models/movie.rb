class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.similar_movies movie
    Movie.where(director: movie.director)
  end
end
