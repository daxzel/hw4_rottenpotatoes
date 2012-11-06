Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    mov = Movie.new movie
    mov.save!
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /I should see movies of rating 'PG' or 'R'/ do
  page.body.should match(/<td>PG<\/td>/)
  page.body.should match(/<td>R<\/td>/)
end

Then /^I should see (.+) table$/ do |table_id, expected_table|

  def table_at(selector) # see https://gist.github.com/1149139
    Nokogiri::HTML(page.body).css(selector).map do |table|
      table.css('tr').map do |tr|
        tr.css('th, td').map { |td| td.text }
      end
    end[0].reject(&:empty?)
  end

  html_table = table_at("##{table_id.parameterize.tableize}").to_a
  html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '') } }
  expected_table.diff!(html_table)
end

Then /^the director of "(.*)" should be "(.*)"/ do |title, director|
  movie = Movie.find_by_title(title)
  assert director == movie.director
end
