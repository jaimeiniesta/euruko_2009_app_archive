# QUICK AND DIRTY SCRIPT TO FETCH THE ORIGINAL SITE AND PREPARE CONTENTS FOR nanoc

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class NanocMirror
  
  def initialize(sitemap_url, root_url, extract_id)
    @sitemap_url = sitemap_url
    @root_url = root_url
    @extract_id = extract_id
  end
  
  def sitemap
    @sitemap ||= Nokogiri::XML(open(@sitemap_url))
  end
  
  def urls
    @urls ||= sitemap.css('loc').collect {|item| item.text}
  end
  
  def create_nanoc_items
    urls.each do |url|
      puts "Fetching #{url}"
      if url == "http://app.euruko2009.org"
        item_name = "index"
      else
        item_name = url.gsub(@root_url, "")
      end
      
      doc = Nokogiri::HTML(open(url))
      title = doc.css('title').inner_html rescue "EuRuKo 2009"
      html = doc.css("##{@extract_id}").inner_html
      
      contents = "---\n"
      contents += "title: \"#{title}\"\n"
      contents += "---\n"
      contents += html
      
      `nanoc create_item #{item_name}` if !File.exists?("content/#{item_name}.html")
      File.open("content/#{item_name}.html", 'w') { |f| f.write(contents) }
    end
  end
  
end

nm = NanocMirror.new("http://app.euruko2009.org/sitemap", "http://app.euruko2009.org/", "content")
nm.create_nanoc_items