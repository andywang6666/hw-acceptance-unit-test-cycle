require 'rails_helper'

require_relative '../app/models/movie.rb'

describe 'Similar Movies' do
    
    before(:each) do
        movies = [{:title => 'Star Wars', :rating => 'PG', :director => 'George Lucas', :release_date => '1-Jan-2000'},
                  {:title => 'Movie 1', :rating => 'R', :director => 'Sam', :release_date => '9-Sep-1990'},
                  {:title => 'Movie 2', :rating => 'R', :director => 'Sam', :release_date => '5-May-2020'},
                  {:title => 'Film', :rating => 'PG', :director => '', :release_date => '28-Oct-2006'},
                  {:title => 'Short', :rating => 'PG', :director => '', :release_date => '9-Aug-2008'}
        ]
        
        movies.each do |movie|
            Movie.create!(movie)
        end
    end
    
    describe 'happy path' do
        it 'movie has director' do
           expect(Movie.find_by(:title => 'Star Wars').director == 'George Lucas').to be true
           expect(Movie.find_by(:title => 'Movie 2').director == 'Sam').to be true
        end
        
        it 'should list similar movies' do
            movie = Movie.find_by(:title => 'Star Wars')
            similar_movies = Movie.similar_movies(movie)
            expect(similar_movies.count == 1).to be true
            expect(similar_movies.pluck(:title) == ['Star Wars']).to be true
            
            movie = Movie.find_by(:title => 'Movie 1')
            similar_movies = Movie.similar_movies(movie)
            expect(similar_movies.count == 2).to be true
            expect(similar_movies.pluck(:title) == ['Movie 1', 'Movie 2']).to be true
        end
        
        it 'should not list non-similar movies' do
            movie = Movie.find_by(:title => 'Star Wars')
            similar_movies = Movie.similar_movies(movie)
            expect('Movie 1'.in? similar_movies.pluck(:title)).to be false
            expect('Movie 2'.in? similar_movies.pluck(:title)).to be false
            expect('Film'.in? similar_movies.pluck(:title)).to be false
            expect('Short'.in? similar_movies.pluck(:title)).to be false
            
            movie = Movie.find_by(:title => 'Movie 1')
            similar_movies = Movie.similar_movies(movie)
            expect('Star Wars'.in? similar_movies.pluck(:title)).to be false
            expect('Film'.in? similar_movies.pluck(:title)).to be false
            expect('Short'.in? similar_movies.pluck(:title)).to be false
        end
    end
    
    describe 'sad path' do
        it 'movie has no director' do
            expect(Movie.find_by(:title => 'Film').director).to be_empty
            expect(Movie.find_by(:title => 'Short').director).to be_empty
        end
    end
end