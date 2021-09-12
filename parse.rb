

class Transactions
  def initialize(description, date, amount)
    @description = description
    @date = date
    @amount = amount
  end
end

doc = File.open("accounts.html") { |f| Nokogiri::HTML(f) }

#transactions > div > div > div > div > table > tbody > tr:nth-child(1)
