class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if session[:ratings] && !params[:ratings]
      if session[:redirected] == 0 || session[:redirected].nil?
        redirect_to movies_path session[:ratings]
        session[:redirected] = 1
        else
          session[:redirected] = 0
        end
    end

    #setting up the sort_by key in session
    if !params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
    end
    
    if params.has_key? :ratings
      session[:ratings] = params[:ratings]
    elsif params.has_key? :commit
      session[:ratings] = nil
    end

    #set up the proper variables for what movies you want
    @sort_by = session[:sort_by]
    @ratings = session[:ratings]
    
   ##pull in movies in sorted order
    if @ratings
      @movies = Movie.order(@sort_by).where("title != ''").select do |m|
          @ratings.include? m.rating
      end
    end

   ##set up the variables for the classes in the haml
    if session[:sort_by] == 'title'
      @title_class = 'hilite'
    elsif session[:sort_by] == 'release_date'
      @release_date_class = 'hilite'
    end
    
    ##make an array of possible movie ratings available to the view
    @all_ratings = Movie.possible_ratings
    
    @ratings = Hash.new
    @all_ratings.each do |rating|
      if session[:ratings].class == Hash
        if session[:ratings].has_key? rating
          @ratings[rating]= false
        else
          @ratings[rating] = true
        end
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
