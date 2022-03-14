
desc "To export users created today"

task exportusers: :environment do
	users = User.where(created_at: Date.today.all_day)
	if users.any?
		spreadsheet = Spreadsheet::Workbook.new
		current_sheet = spreadsheet.create_worksheet :name => 'Users'		
		current_sheet.row(0).push('Name', 'Date of Birth', 'Gender', 'Status', 'Addresses')

		users.each.with_index(1) do |user, ui|
			addresses = ""
			user.addresses.each.with_index(1) do |user_address, uai|
				( addresses += "\n\n" ) if addresses != ""
				addresses += "Address " + uai.to_s + ': ' + user_address.address
			end

			current_sheet.row(ui).push user.name, 
						user.dob.strftime('%d %b, %Y'), 
						user.gender.titleize, user.status.titleize, 
						addresses
		end

		filename = 'Users-' + Date.today.to_s + '.xls'
		spreadsheet.write Rails.root.join("storage/" + filename)
	else
		puts "No records found for the day!"
	end
end