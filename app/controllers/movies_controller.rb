class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !params[:ratings] || !params[:sort_by]
      if (session[:ratings] && !params[:ratings])
        @ratings = session[:ratings]
        @sort_by = params[:sort_by]
        if session[:redirected] == 0 || session[:redirected].nil?
          flash[:notice] = "redirected"
          redirect_to movies_path(@ratings,@sort_by)
          session[:redirected] = 1
        else
          if session[:redirected]
            session.delete(:redirected)
          end
        end
      elsif (session[:sort_by] && !params[:sort_by])
        @ratings = params[:ratings]
        @sort_by = session[:sort_by]
        if session[:redirected1] == 0 || session[:redirected1].nil?
          flash[:notice] = "redirected"
          redirect_to movies_path(@ratings,@sort_by)
          session[:redirected1] = 1
        else
          if session[:redirected1]
            session.delete(:redirected1)
          end
        end
      end
    end

    if !params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
    end
    
    if params.has_key? :ratings
      session[:ratings] = params[:ratings]
    end

   ##pull in movies in sorted order
    @movies = Movie.order(session[:sort_by])

    if !session[:ratings].nil?
      @movies = @movies.select do |m|
        session[:ratings].include? m.rating
      end
    end

    
    ##set up the variables for the classes in the haml
    if session["sort_by"] == "title"
      @title_class = 'hilite'
    elsif session["sort_by"] == 'release_date'
      @release_date_class = 'hilite'
    end

    @all_ratings = Movie.create_possible_ratings_array


    
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
