require 'net/http'
require 'uri'

class AlchemyAPI

  @@ENDPOINTS = {}
  @@ENDPOINTS['image_tag'] = {}
  @@ENDPOINTS['image_tag']['url'] = '/url/URLGetRankedImageKeywords'
  @@ENDPOINTS['image_tag']['image'] = '/image/ImageGetRankedImageKeywords'

  # Tag image from a URL or raw image data.
  # For an overview, please refer to: http://www.alchemyapi.com/products/features/image-tagging/
  # For the docs, please refer to: http://www.alchemyapi.com/api/image-tagging/
  #
  # INPUT:
  # flavor -> which version of the call, i.e.  url or image.
  # data -> the data to analyze, the url
  # options -> various parameters that can be used to adjust how the API works, see below for more info on the available options.
  #
  # Available Options:
  # extractMode -> trust-metadata: less CPU-intensive and less accurate, always-infer: more CPU-intensive and more accurate
  # (image flavor only)
  # imagePostMode -> how you will post the image
  #     raw: pass an unencoded image file using POST
  #
  # OUTPUT:
  # The response, already converted from JSON to a Ruby object.
  #
  def image_tag(flavor, data, options = {}, image = '')
    #Add the URL encoded data to the options and analyze
    unless data.empty?
      options[flavor] = data
    end
    return analyze_image(@@ENDPOINTS['image_tag'][flavor], options, image)
  end


  private

  # HTTP Request wrapper that is called by the endpoint functions. This function is not intended to be called through an external interface.
  # It makes the call, then converts the returned JSON string into a Ruby object.
  #
  # INPUT:
  # url -> the full URI encoded url
  # body -> the raw binary image data
  #
  # OUTPUT:
  # The response, already converted from JSON to a Ruby object.
  #
  def analyze_image(url, options, body)
    url = 'http://access.alchemyapi.com/calls' + url

    options['apikey'] = ENV["alchemy_api_key"]
    options['outputMode'] = 'json'

    url += '?'
    options.each { |h,v|
      url += h + '=' + v + '&'
    }

    #Parse URL
    uri = URI.parse(url)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = body.to_s

    # disable gzip encoding which blows up in Zlib due to Ruby 2.0 bug
    # otherwise you'll get Zlib::BufError: buffer error
    request['Accept-Encoding'] = 'identity'

    #Fire off the HTTP request
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    #parse and return the response
    return JSON.parse(res.body)
  end
end
