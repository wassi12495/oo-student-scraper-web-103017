require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    index = Nokogiri::HTML(open(index_url))
    index.css("div.roster-cards-container").each do |student_card|

      student_card.css(".student-card a").each do |student|
        url = student.attr('href')
        name = student.css(".student-name").text
        location = student.css('.student-location').text
        students << {:name => name, :location => location, :profile_url => url}
      end # --> end student_card.each
    end #--> end index.css.each
    students
  end #end scrape_index_page

  def self.scrape_profile_page(profile_url)

    student = { }
    profile = Nokogiri::HTML(open(profile_url))
    # profile.css
    media = profile.css('.social-icon-container a').collect do |social|
      social.attr('href')
    end
    media.each do |ref|
      if ref.include?("github")
        student[:github] = ref
      elsif ref.include?("linkedin")
        student[:linkedin] = ref
      elsif ref.include?("twitter")
        student[:twitter] = ref
      else
        student[:blog] = ref
      end
    end
    vitals = profile.css('.vitals-text-container')
    details = profile.css('.details-container')
    student[:profile_quote] = vitals.css('.profile-quote').text
    student[:bio] = details.css('div.bio-content.content-holder').css('.description-holder p').text
    student


  end

end
