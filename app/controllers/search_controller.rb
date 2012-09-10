class SearchController < ApplicationController
  
  def index
  end
  
  def find_form
    require 'mechanize'
    agent = Mechanize.new

    ticker_symbol = "NFLX"
    page = agent.get("http://sec.gov/cgi-bin/browse-edgar?company=&match=&CIK=#{ticker_symbol}&filenum=&State=&Country=&SIC=&owner=exclude&Find=Find+Companies&action=getcompany")

    target_href = ""

    page.parser.xpath("//tr").each_with_index do |tr, index| 
       if tr.children.first.children.first.text == "10-K"
         target_href = "http://www.sec.gov/#{tr.children[2].children.first.attributes["href"].value}"
       end
    end

    page = agent.get(target_href)
    page = page.links[9].click
    url = page.uri
    `open #{url}`
  end
end