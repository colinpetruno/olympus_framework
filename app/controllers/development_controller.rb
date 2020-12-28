class DevelopmentController < ApplicationController
  def styleguide
    # the file to scrap the icon names can be found here
    # /Users/colinpetruno/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/font-ionicons-rails-2.0.1.6/app/assets/stylesheets/ionicons.css.erb
    #
    # open the above file (update to your local and load the contents into
    # a varible called str, then run the below line
    #
    # File.open(Rails.root.join("spec/support/files/ionicons.json"), "wb") do |f|
    #   f.write(str.scan(/\.\S*:/).map(&:strip).map { |str| str[1..-2] }.uniq.to_json)
    # end

    @ion_icons = JSON.parse(File.read(
      Rails.root.join("spec/support/files/ionicons.json")
    ))

    render "styleguides/dashboard", format: :html, layout: false
  end
end
