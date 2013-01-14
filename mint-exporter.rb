require "uri"
require "rubygems"
require "bundler/setup"
require "logger"
Bundler.require

hostname = "https://wwws.mint.com/"

unless ARGV.length == 2
  puts "Usage: ruby #{$0} USERNAME PASSWORD"
  exit 1
end

username = ARGV[0]
password = ARGV[1]

# Setup
# http://mechanize.rubyforge.org/Mechanize.html
agent = Mechanize.new
agent.log = Logger.new STDOUT
agent.pluggable_parser.default = Mechanize::Download

# Login
page  = agent.get(URI.join hostname, "/login.event")
form = page.form_with(:id => "form-login")

form.username = username
form.password = password
form.submit

# Get Transcations
#transactions_csv = agent.get(URI.join hostname, "/transactionDownload.event").body


trend_page = agent.get(URI.join hostname, "/trend.event")

form = trend_page.form_with(:action => "https://wwws.mint.com/trend.event")
data = form['javascript-import-node'].chomp.sub('json = ', '').delete(';')
puts data
json = JSON.parse data
puts JSON.pretty_generate json

