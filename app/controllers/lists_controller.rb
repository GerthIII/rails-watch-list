class ListsController < ApplicationController
  def index
    @lists = List.all
    @list = List.new
    @popular_movies = Movie.limit(15)
  end

  def new
    @list = List.new
  end

  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @list = List.find(params[:id])# Save the list reference before deleting
    @list.destroy
    # Redirect back to the show page with the 'see_other' status for Turbo
    redirect_to lists_path, status: :see_other
  end

  private

  def list_params
    params.require(:list).permit(:name, :photo)
  end

end
