# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."

# 1. DELETE THE CHILDREN FIRST (The Bridge)
# This removes the foreign key references so the parents are "free"
Bookmark.destroy_all

# 2. NOW DELETE THE PARENTS
# Now that no bookmarks exist, the DB will let you delete these
Movie.destroy_all

List.destroy_all

puts "Database clean! Creating new seeds..."

require 'open-uri'
puts "Cleaning the DB...."
Movie.destroy_all
# List.destroy_all

# the Le Wagon copy of the API
puts "Creating movies.... \n"
(1..5).to_a.each do |num|
  url = "http://tmdb.lewagon.com/movie/top_rated?page=#{num}"
  response = JSON.parse(URI.open(url).read)
  
  response['results'].each do |movie_hash|
    puts "...creating the movie #{movie_hash['title']}..."
    puts
    # create an instance with the hash
    Movie.create!(
      poster_url: "https://image.tmdb.org/t/p/w500" + movie_hash['poster_path'],
      rating: movie_hash['vote_average'],
      title: movie_hash['title'],
      overview: movie_hash['overview']
    )
  end
end
puts "... created #{Movie.count} movies."

# 1. Create a List
drama = List.create!(name: "Drama")
action = List.create!(name: "Action")
comedy = List.create!(name: "Comedy")
suspense = List.create!(name: "Suspense")

# 2. Create a Bookmark to link a movie to that list
# Note: We find the movie by title since we know it exists in the seeds

puts "Created 'Drama' list with Titanic bookmarked!"

list = List.create(name: 'Comedy')
photo = URI.parse("https://dnm.nflximg.net/api/v6/2DuQlx0fM4wd1nzqm5BFBi6ILa8/AAAAQaUiPLJpaxXAL-CGwnV-UUKic7arMB-yY4SY7enUbFgSksNG0BClmStlVX4vJO7EIkOODAr7zgP5aO0sPt3iG3XKNVEfbyLY-xQ4bMpzVHHRkSziQ5MnueXkDn4VXT2RfN7C4QEgg-2OvnrRVTfNluW7.jpg?r=936").open
list.photo.attach(io: photo, filename: "photo.png", content_type: "image/png")
list.save

list = List.create(name: 'Action')
photo = URI.parse("https://deadline.com/wp-content/uploads/2025/05/Rambo-First-Blood.webp?w=681&h=383&crop=1").open
list.photo.attach(io: photo, filename: "photo.png", content_type: "image/png")
list.save
