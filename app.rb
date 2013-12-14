# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'open-uri'
require 'bundler'
Bundler.require
include Icalendar

# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be
# set, when working locally this line will fall back to using SQLite in the
# current directory.
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

# Define a simple DataMapper model.
class Gallery
  include DataMapper::Resource

  property :gallery_id, Serial, :key => true
  property :created_at, DateTime

  property :title, String, :length => 255
  property :description, Text
  property :address, Text
  property :phone, String
  property :owner, Text
  property :accessibility, Text
  property :url, String
  property :email, String
  property :api_url, String

  has n, :shows
end

class Show
  include DataMapper::Resource

  property :show_id, Serial, :key => true
  property :created_at, DateTime

  property :title, String, :length => 255
  property :startdate, String
  property :enddate, String
  property :description, Text
  property :url, String
  property :curator, String
  property :artist, Text

  property :addedby, String
  property :source, String

  belongs_to :gallery
end

# Finalize the DataMapper models.
DataMapper.finalize

# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!

# root
get '/' do
  @title = "nebula.im"
  haml :home
end


get '/api/html' do
  @title = "Api Docs"
  haml :api_docs
end

get '/api/json' do
  content_type :json
  File.read('./views/api.json')
end




# Route to show all Galleries, ordered like a blog
["/galleries", "/galleries/json"].each do |path|
  get path do
    content_type :json
    @galleries = Gallery.all
    @galleries.to_json
  end
end

# Route to show all Galleries, ordered like a blog
get '/galleries/html' do
  @galleries = Gallery.all(:order => :title)
  @title = "Galleries"
  haml :galleries
end

# CREATE: Route to create a new Gallery
post '/galleries' do
  content_type :json

  # These next commented lines are for if you are using Backbone.js
  # JSON is sent in the body of the http request. We need to parse the body
  # from a string into JSON
  # params_json = JSON.parse(request.body.read)

  # If you are using jQuery's ajax functions, the data goes through in the
  # params.
  @gallery = Gallery.new(params)

  if @gallery.save
    @gallery.to_json
  else
    halt 500
  end
end

# READ: Route to show shows from a specific Gallery based on its `id`
["/:gallery_id/shows", "/:gallery_id/shows/json"].each do |path|
  get path do
    content_type :json
    @gallery = Gallery.get(params[:gallery_id].to_i)
    if @gallery
      @shows = Show.all(:gallery_gallery_id => @gallery.gallery_id)
      @shows.to_json
    else
      halt 404
    end
  end
end

# READ: Route to show shows from a specific Gallery based on its `id`
get '/galleries/:gallery_id/shows/html' do
  @gallery = Gallery.get(params[:gallery_id].to_i)
  if @gallery
    @shows = Show.all(:gallery_gallery_id => @gallery.gallery_id)
    @title = @gallery.title + " shows"
    haml :shows
  else
    halt 404
  end
end

# READ: Route to show shows from a specific Gallery based on its `id`
get '/galleries/:gallery_id/ics' do
  content_type :json
  @gallery = Gallery.get(params[:gallery_id].to_i)
  if @gallery
    @shows = Show.all(:gallery_gallery_id => @gallery.gallery_id)
    icalGen(@shows)
  else
    halt 404
  end
end

# READ: Route to show a specific Gallery based on its `id`
["/galleries/:gallery_id", "/galleries/:gallery_id/json"].each do |path|
  get path do
    content_type :json
    @gallery = Gallery.get(params[:gallery_id].to_i)
    if @gallery
      @gallery.to_json
    else
      halt 404
    end
  end
end

# READ: Route to show a specific Gallery based on its `id`
get '/galleries/:gallery_id/html' do
  @gallery = Gallery.get(params[:gallery_id].to_i)
  if @gallery
    @title = @gallery.title
    haml :gallery
  else
    halt 404
  end
end

# UPDATE: Route to update a Gallery
post '/galleries/:gallery_id' do
  content_type :json

  # These next commented lines are for if you are using Backbone.js
  # JSON is sent in the body of the http request. We need to parse the body
  # from a string into JSON
  # params_json = JSON.parse(request.body.read)

  # If you are using jQuery's ajax functions, the data goes through in the
  # params.

  @gallery = Gallery.get(params[:gallery_id].to_i)
  @gallery.update(params)

  if @gallery.save
    @gallery.to_json
  else
    halt 500
  end
end

# DELETE: Route to delete a Gallery
delete '/galleries/:gallery_id/delete' do
  content_type :json
  @gallery = Gallery.get(params[:gallery_id].to_i)

  if @gallery.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end


# Route to show all Shows, ordered like a blog
["/shows", "/shows/json"].each do |path|
  get path do
    content_type :json
    @shows = Show.all(:order => :show_id)

    @shows.to_json
  end
end


# Route to show all Shows, ordered like a blog
get '/shows/html' do
  @shows = Show.all(:order => :show_id)
  @title = "all shows"
  haml :shows
end

# Route to show all Shows, ordered like a blog
get '/shows/ics' do
  content_type :json
  @shows = Show.all(:order => :show_id)

  icalGen(@shows)
end

# CREATE: Route to create a new Show
post 'galleries/:gallery_id/shows' do
  content_type :json

  # These next commented lines are for if you are using Backbone.js
  # JSON is sent in the body of the http request. We need to parse the body
  # from a string into JSON
  # params_json = JSON.parse(request.body.read)

  # If you are using jQuery's ajax functions, the data goes through in the
  # params.
  @gallery = Gallery.get(params[:gallery_id].to_i)
  @show = Show.new(params)
  @show.gallery_gallery_id = @gallery.gallery_id

  if @show.save
    @show.to_json
  else
    halt 500
  end
end

# READ: Route to show a specific Show based on its `id`
["/shows/:show_id", "/shows/:show_id/json"].each do |path|
  get path do
    content_type :json
    @show = Show.get(params[:show_id].to_i)
    puts params[:show_id]
    if @show
      @show.to_json
    else
      halt 404
    end
  end
end

# READ: Route to show a specific Show based on its `id`
get '/shows/:show_id/html' do
  @show = Show.get(params[:show_id].to_i)
  puts params[:show_id]
  if @show
    @title = @show.title
    haml :show
  else
    halt 404
  end
end

# UPDATE: Route to update a Show
post '/shows/:show_id' do
  content_type :json

  # These next commented lines are for if you are using Backbone.js
  # JSON is sent in the body of the http request. We need to parse the body
  # from a string into JSON
  # params_json = JSON.parse(request.body.read)

  # If you are using jQuery's ajax functions, the data goes through in the
  # params.

  @show = Show.get(params[:show_id].to_i)
  @show.update(params)

  if @show.save
    @show.to_json
  else
    halt 500
  end
end

# DELETE: Route to delete a Show
delete '/shows/:show_id/delete' do
  content_type :json
  @show = Show.get(params[:show_id].to_i)

  if @show.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end

# If there are no Shows in the database, add a few.
if Show.count == 0
  json = File.read('events.json')
  json_object = JSON.parse(json)
  # puts json_object.to_json
  json_object.each do |show|
    puts "=== NEW EVENT ==="
    puts "--- source ---"
    puts show
    if ( show["gallery"] )
      @gallery = Gallery.first_or_create({ :title => show["gallery"][0].to_s, }, { :created_at => Time.now })
      @show = Show.first_or_create({:title => show["title"][0].to_s}, { :created_at => Time.now })
      @show.gallery = @gallery
      @show.save
      @show.addedby = "showbot"
      @show.source = show["pageUrl"]
      @show.save
      @show.created_at = Time.now
          @show.title = show["title"][0].to_s
      if ( show["startdate"] )
        if ( show["startdate"][0] )
          @show.startdate = show["startdate"][0].to_s
          @show.save
          # @show.update(:startdate => show["startdate"][0].to_s)
        end
      end
      if ( show["gallery_url"] )
        if ( show["gallery_url"][0] )
          @gallery.url = show["gallery_url"][0].to_s
          @gallery.save
          # @show.update(:startdate => show["startdate"][0].to_s)
        end
      end
      if ( show["address"] )
        if ( show["address"][0] )
          @gallery.address = show["address"][0].to_s
          @gallery.save
          # @show.update(:startdate => show["startdate"][0].to_s)
        end
      end
      if ( show["url"] )
        if ( show["url"][0] )
          @show.url = show["url"][0].to_s
          @show.save
          # @show.update(:url => show["url"][0].to_s)
        end
      end
      if ( show["enddate"] )
        if ( show["enddate"][0] )
          @show.enddate = show["enddate"][0].to_s
          @show.save
          # @show.update(:enddate => show["enddate"][0].to_s)
        end
      end
    end

    # if @show.save
    puts "--- output ---"
    puts @show.to_json
    # end

    # new_record.attribute_1 = a_hash['key_for_attribute_1']
    # ... etc ...
    # new_record.save
  end

end

def icalGen(shows)
  cal = Calendar.new
  shows.each do |show|
    unless Chronic.parse(show.startdate.to_s.gsub("Opening ","").gsub("On view through ","").split_by_last[0]) == nil
      event = Event.new
      puts show.startdate.to_s
      time = Chronic.parse(show.startdate.to_s.gsub("Opening ","").gsub("On view through ","").split_by_last[0] ).strftime("%Y%m%dT%H%M%S").to_s
      puts time.to_s
      event.start =  event.end = time.to_s
      unless Chronic.parse(show.enddate.to_s) == nil
        event.end = Chronic.parse(show.enddate.gsub("On view through ","").split_by_last[0] ).strftime("%Y%m%dT%H%M%S").to_s
      end
      event.description = "at" + Gallery.get(show.gallery_gallery_id).title + "\n"
      event.summary = show.title.to_s
      cal.add_event(event)
    end
  end
  return cal.to_ical
end

class String
  def split_by_last(char=",")
    pos = self.rindex(char)
    pos != nil ? [self[0...pos], self[pos+1..-1]] : [self]
  end
end