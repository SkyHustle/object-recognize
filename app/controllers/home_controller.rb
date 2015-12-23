class HomeController < ApplicationController
  def index
  end

  def screenshot
    File.open("#{Rails.root}/public/snapshot.png", 'wb') do |f|
      f.write(params[:image].read)
    end
    redirect_to root_path
  end
end
