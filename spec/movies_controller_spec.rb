require 'rails_helper'
require 'movies_controller.rb'
require 'movie.rb'

RSpec.describe MoviesController, type: :controller do
    describe 'GET index' do
        shared_examples 'all cases' do |my_sort, my_filter, my_movies, my_size|
            it 'assigns @movies' do
                sor = my_sort
                fil = my_filter
                get :index, {:sort => sor, :ratings => fil}, {:sort => sor, :ratings => fil}
                movs = assigns(:movies)
                my_movs = my_movies
                for int in 0..movs.length
                    expect(movs[int]).to eq(my_movs[int])
                end
                expect(movs.length).to eq(my_size)
                expect(response).to render_template("index")
            end
        end
        describe 'should lead to a sorted list when a valid :sort is included' do
            my_sort = 'title'
            my_filter = Hash.new()
            #"G PG PG-13 NC-17 R".split.each do |key|
            #    my_filter[key]=true
            #end
            my_movies = Movie.order({:title => :asc})
            my_size = Movie.order({:title => :asc}).length
            include_examples 'all cases', my_sort, my_filter, my_movies, my_size
        end
        describe 'should lead to a filtered list when a valid :ratings is included' do
            my_sort = ''
            my_filter = Hash.new()
            my_filter["PG"]=true
            my_movies = Movie.where(rating: "PG")
            my_size = Movie.where(rating: "PG").length
            include_examples 'all cases', my_sort, my_filter, my_movies, my_size
        end
        describe 'should lead to a sorted and filtered list when :sort and :filtered is included' do
            my_sort = 'release_date'
            my_filter = Hash.new()
            my_filter["PG"]=true
            my_movies = Movie.where(rating: "PG").order({:release_date => :asc})
            my_size = Movie.where(rating: "PG").order({:release_date => :asc}).length
            include_examples 'all cases', my_sort, my_filter, my_movies, my_size
        end
        it 'should trigger a redirect to itself if the params do not match the session variables' do
            my_old_filter = Hash.new()
            "G PG PG-13 NC-17 R".split.each do |key|
                my_old_filter[key]=true
            end
            my_filter = Hash.new()
            my_filter["PG"]=true
            subject { get :index, {:sort => 'title', :ratings => my_filter}, {:sort => 'title', :ratings => my_old_filter} }
            expect(response.status).to eq(200) #200 is status code for self-redirect
            get :index, {:sort => 'title', :ratings => my_filter}, {:sort => 'title', :ratings => my_old_filter}
        end
    end
    describe 'new' do
        it 'renders the new template' do
            get :new
            expect(response).to render_template('new')
        end
    end
end