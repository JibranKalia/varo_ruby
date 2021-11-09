require 'nokogiri'
require 'pry'
require 'csv'


class AllTransactions
  @@transactions = []

  class << self
    def add(html)
      tran = Transaction.create_from_html(html)
      @@transactions.unshift(tran)
    end

    def print
      @@transactions.each { |t| t.print }
    end

    def previous_date
      @@transactions.first.date
    end

    def csv
      csv_string = CSV.generate do |csv|
        @@transactions.each do |t| 
          csv << t.row
        end
      end

      puts csv_string
    end

    def all_transactions
      @@transactions
    end
  end
end

class Transaction
  attr_reader :description, :date, :amount, :balance

  def initialize(description, date, amount, balance)
    @description = description
    @date = date
    @amount = amount
    @balance = balance
  end

  def self.create_from_html(html)
    description = html.css('[data-qe-automation="description"]').text.strip
    amount = html.css('[data-qe-automation="amount"]').text.strip
    balance = html.css('[data-qe-automation="balance"]').text.strip
    date = html.css('[data-qe-automation="date"]').text.strip
    date = AllTransactions.previous_date if date.empty?
    self.new(description, date, amount, balance)
  end

  def parsed_date
    Date.parse(date).strftime("%D")
  end

  def print
    puts "#{parsed_date}, #{description}, #{amount}, #{balance}"
  end

  def row
    [parsed_date, description, balance, amount]
  end 
end

doc = File.open("accounts.html") { |f| Nokogiri::HTML5(f) }

doc.css('[data-qe-automation="transactionRow"]').map do |transaction_html|
 AllTransactions.add(transaction_html)
end

AllTransactions.csv
