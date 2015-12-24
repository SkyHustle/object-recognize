class HomeController < ApplicationController
  def index
    alchemyapi = AlchemyAPI.new()

    path_to_test_image = "#{Rails.root}/public/snapshot.png"
    test_image = File.binread(path_to_test_image)

    @response = alchemyapi.image_tag('image', '', { 'imagePostMode'=>'raw' }, test_image)
  end

  def screenshot
    File.open("#{Rails.root}/public/snapshot.png", 'wb') do |f|
      f.write(params[:image].read)
    end
    redirect_to root_path
  end
end
