class SearchController < ApplicationController
require 'mechanize'

  def index
  end
  
  def find_form
    
    agent = Mechanize.new
    
     ticker_symbol = params[:ticker_symbol].upcase
     page = agent.get("http://sec.gov/cgi-bin/browse-edgar?company=&match=&CIK=#{ticker_symbol}&filenum=&State=&Country=&SIC=&owner=exclude&Find=Find+Companies&action=getcompany")
    
     target_href = ""
    
     page.parser.xpath("//tr").each_with_index do |tr, index| 
        if tr.children.first.children.first.text == "10-K"
          target_href = "http://www.sec.gov/#{tr.children[2].children.first.attributes["href"].value}"
        end
     end
    
     page = agent.get(target_href)
     page = page.links[9].click
     url = page.uri.to_s
          
     redirect_to url
     
     #render 'index'   
  end
  
end