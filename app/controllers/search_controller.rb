class SearchController < ApplicationController
require 'mechanize'

  def index
  end
  
  def find_form
    
    agent = Mechanize.new
    
    ticker_symbol = params[:ticker_symbol].upcase
    page = agent.get("http://sec.gov/cgi-bin/browse-edgar?company=&match=&CIK=#{ticker_symbol}&filenum=&State=&Country=&SIC=&owner=exclude&Find=Find+Companies&action=getcompany&count=100")
    
    target_href = ""
      
      page.parser.xpath("//tr").each_with_index do |tr, index| 
        if tr.children.first.children.first.text == "10-K"
          target_href = "http://www.sec.gov/#{tr.children[2].children.first.attributes["href"].value}"
          break
        end
      end
    
      unless target_href == ""
      page = agent.get(target_href)
      page = page.links[9].click
      @url = page.uri.to_s
      redirect_to @url
      return
      end
      
    render :text => "Sorry, I couldn't find a 10-K from that ticker name. Double check to make sure it was entered correctly"
    
  end
  
end