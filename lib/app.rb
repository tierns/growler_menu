require "sinatra"
require "nokogiri"
require "open-uri"

class GrowlerMenuApplication < Sinatra::Base
	get "/menu" do
		menu_url = "http://www.beergrowlernation.com/opening/?q=beermenu"
		doc = Nokogiri::HTML(open(menu_url))

		rows = []
		doc.css("div.view-content table tbody tr").each do |table_row|
			row = table_row.css('td').collect { |col| col.content.strip }
			row.shift # empty image row first...
			rows << row
		end
		rows.pop # last row is the footer at the bottom of the page

		beers = \
			rows.collect do |row|
				beer = {}
				beer[:brewer] = row[0]
				beer[:location] = row[1]
				beer[:description] = row[2]
				beer[:abv] = row[3]
				beer[:type] = row[4]
				beer
			end

		beers.to_json
	end
end
