# encoding: utf-8

module Nanoc3::Filters
  
  class CleanContents < Nanoc3::Filter
    identifier :clean_contents
    type :text

    # Some pre-cleaning on the original contents
    def run(content, params={})
      content.gsub!("div id=\"logo\"", "div id='hiddenlogo' style='display:none;'")
      content.gsub!("http://euruko2009.org/archives", "/archives")
      content.gsub!("http://app.euruko2009.org", "http://euruko2009.org")
      content
    end

  end
end