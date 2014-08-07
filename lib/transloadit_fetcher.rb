require 'net/http'
require "rubygems"
require "transloadit"
require "time"

class TransloaditFetcher
  
  def initialize(auth_key, auth_secret, post_url = nil)
    @auth_key = auth_key
    @auth_secret = auth_secret
    @post_url = post_url
  end
  
  def fetch_and_post_assemblies(since = nil)
    if since
      page_size = 50
    else
      page_size = 2
    end
    assemblies = request_assembly_list( {since: since, page_size: page_size} )
    
    latest_time = nil
    
    assemblies.each do |assembly|
      created_time = Time.parse(assembly["created"])
      if latest_time.nil? || created_time > latest_time
        latest_time = created_time + 1
      end
      
      assembly_response = request_assembly assembly
      if @post_url
        post_assembly_response assembly_response
      end
    end
    return latest_time 
  end
  
  def request_assembly_list(options={})

    request_url = "http://api2.transloadit.com/assemblies"

    params = {
      page: 1, 
      pagesize: options[:page_size] || 50,
      type: "completed",
      auth: {
        key:     @auth_key,
        expires: (Time.now.utc + 60).strftime('%Y/%m/%d %H:%M:%S+00:00')
      }
    }

    if options[:since]
      params[:fromdate] = options[:since].utc.strftime('%Y-%m-%d %H:%M:%S')
    end

    transloadit_request = Transloadit::Request.new request_url, @auth_secret

    response = transloadit_request.get(params)
    if response["error"]
      puts "Error fetching assembly list:"
      puts response["error"]
      puts response["message"]
      raise TransloaditFetcherError
    else
      puts "Successfully fetched #{response["items"].count} assemblies"
      return response["items"]
    end
  end
  
  def request_assembly(assembly)
    request_url = "http://api2.transloadit.com/assemblies/#{assembly["id"]}"

    params = {
      :auth => {
        :key     => @auth_key,
        :expires => (Time.now.utc + 60).strftime('%Y/%m/%d %H:%M:%S+00:00')
      }
    }
    
    transloadit_request = Transloadit::Request.new request_url, @auth_secret
    response = transloadit_request.get(params)
    if response["error"]
      puts "Error fetching assembly #{assembly["id"]}:"
      puts response["error"]
      puts response["message"]
      raise TransloaditFetcherError
    else
      puts "successfully fetched #{assembly["id"]}"
      return response
    end
  end
  
  def post_assembly_response(assembly_response)
    uri = URI(@post_url)
    res = Net::HTTP.post_form(uri, 'transloadit' => assembly_response.to_s)
    puts "Posted assembly to #{@post_url}"
  end
end
class TransloaditFetcherError < StandardError; end