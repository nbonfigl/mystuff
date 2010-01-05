#!/usr/bin/env ruby 

# Sample script to retrive gmail list from IMAP connection
# see Net::IMAP Library for more information

require 'net/imap'

@gmail_login = "nbonfigl@gmail.com"
@gmail_passwd = "<YOUR PASSWORD>"

system("clear")

puts "====== START MYMAIL ======"
print "Connecting to server...   "
imap = Net::IMAP.new('imap.gmail.com',993,true)
puts "[CONNECTED]"

print "Loging in...   "
imap.login(@gmail_login, @gmail_passwd)
puts "[OK]"

puts "Fetching mail list...   \n\n"
puts "====== MAIL LIST ======"
imap.examine('INBOX')
imap.search(["SEEN"]).reverse_each do |m_id|
  @list = imap.fetch(m_id, "ENVELOPE")[0].attr["ENVELOPE"]
  puts "#{@list.from[0].name}: \t#{@list.subject}"
end

puts "====== END LIST ======\n\n"
print "Loging out...   "
imap.logout()
puts "[OK]"

print "Disconnecting from server...   "
imap.disconnect()
puts "[OK]\n\n"

puts "======= MYMAIL DONE ======="

