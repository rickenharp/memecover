require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'rmagick'

wikidoc=Hpricot(open("http://en.wikipedia.org/wiki/Special:Random"));
title_element = wikidoc.search("/html/body/div[@id='globalWrapper']/div[@id='column-content']/div[@id='content']/h1[@id='firstHeading']")
bandname = title_element.inner_text
puts "Band: #{bandname}"

quotedoc=Hpricot(open("http://www.quotationspage.com/random.php3"));
quote_element = quotedoc.search("//dt[@class='quote']").last
albumname = quote_element.inner_text.split(/ /)[-4,4].map{|x| x.capitalize}.join(" ").gsub(/[^a-zA-Z ]/,"")
puts "Album: #{albumname}"


flickrdoc = Hpricot(open("http://www.flickr.com/explore/interesting/7days/"))
image_element = flickrdoc.search("//img[@class='pc_img']")[2].attributes["src"]
puts "Image: #{image_element}"


image = Magick::ImageList.new(image_element)
text = Magick::Draw.new
text.annotate(image, 0, 0, 0, 0, bandname) {
    self.gravity = Magick::NorthWestGravity
    self.pointsize = 16
    self.stroke = 'transparent'
    self.fill = '#FF0000'
    self.font_weight = Magick::BoldWeight
    }
text.annotate(image, 0, 0, 0, 0, albumname) {
    self.gravity = Magick::SouthEastGravity
    self.pointsize = 14
    self.stroke = 'transparent'
    self.fill = '#FF0000'
    self.font_weight = Magick::BoldWeight
    }
filename = "#{bandname.downcase.gsub(/[^a-z]/,"_")}-#{albumname.downcase.gsub(/[^a-z]/,"_")}.jpg"
puts "#{filename}"
image.write(filename)