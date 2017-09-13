require 'csv'

def create_csv(servers, values)
  # generate first row
  first_row = %w[Server]
  values.each { |value| first_row.concat([value, nil]) }
  first_row.concat(%w[Stuff])

  CSV.open(dir + '/file.csv', 'w') do |csv|
    # write out first row
    csv << first_row

    # generate and output successive rows
    servers.each do |server|
      # begin row with hostname
      row = [server]

      # initialize total numbers
      x_tot = 0
      y_tot = 0

      values.each do |value|
        # assign nested hash with key (y) and value (x) pair
        y, x = calc(server, value)

        # collect test passes and number
        row.concat([x, y])

        # add to totals
        x_tot += x
        y_tot += y
      end

      # pull in date
      date = File.mtime("#{dir}/output/#{server}.csv").to_s

      # append data to row
      row.concat([date, x_tot, y_tot, x_tot.to_f / y_tot.to_f])

      # write out row for server
      csv << row
    end
  end
end
