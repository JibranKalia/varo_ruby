require 'nokogiri'
require 'pry'
require 'csv'


class Transactions
  @@transactions = []

  def self.push(transaction)
    @@transactions << transaction
  end

  def self.print
    @@transactions.each { |t| t.print }
  end

  def self.previous_date
    @@transactions.last.date
  end

  def self.csv
    csv_string = CSV.generate do |csv|
      @@transactions.each do |t| 
        csv << t.row
      end
    end

    puts csv_string
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

  def print
    puts "#{date}, #{description}, #{amount}, #{balance}"
  end

  def row
    [date, description, amount, balance]
  end 
end

doc = File.open("accounts.html") { |f| Nokogiri::HTML5(f) }

doc.css('[data-qe-automation="transactionRow"]').map do |transaction|
  date = transaction.css('[data-qe-automation="date"]').text.strip
  date = Transactions.previous_date if date.empty?
  description = transaction.css('[data-qe-automation="description"]').text.strip
  amount = transaction.css('[data-qe-automation="amount"]').text.strip
  balance = transaction.css('[data-qe-automation="balance"]').text.strip
  tran = Transaction.new(description, date, amount, balance)
  Transactions.push(tran)
end

Transactions.csv
