class HomeController < ApplicationController
  def index
  end

  def screenshot
    File.open("#{Rails.root}/public/uploads/somefilename.png", 'wb') do |f|
      f.write(params[:image].read)
    end
  end
end
