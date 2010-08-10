# QUICK AND DIRTY SCRIPT TO FETCH THE ORIGINAL SITE AND PREPARE CONTENTS FOR nanoc
# BY Jaime Iniesta // http://jaimeiniesta.com // jaimeiniesta@gmail.com
# MIT Licensed: http://www.opensource.org/licenses/mit-license.php

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class NanocMirror
  
  def initialize(sitemap, root_url, extract_id)
    @sitemap = Nokogiri::XML(sitemap)
    @root_url = root_url
    @extract_id = extract_id
  end
  
  def urls
    @urls ||= @sitemap.css('loc').collect {|item| item.text}
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

app_mirror = NanocMirror.new(open('http://app.euruko2009.org/sitemap'), "http://app.euruko2009.org/", "content")
blog_mirror = NanocMirror.new(File.open('original_blog_sitemap.xml'), "http://euruko2009.org/", "realcontent")

app_mirror.create_nanoc_items
blog_mirror.create_nanoc_items