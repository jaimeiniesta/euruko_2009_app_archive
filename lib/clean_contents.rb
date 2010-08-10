# encoding: utf-8

module Nanoc3::Filters
  class CleanContents < Nanoc3::Filter
    identifier :clean_contents
    type :text

    # Some pre-cleaning on the original contents
    def run(content, params={})
      content.gsub("div id=\"logo\"", "div id='hiddenlogo' style='display:none;'").gsub("http://euruko2009.org/archives", "/archives")
    end

  end
end