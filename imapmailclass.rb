#!/usr/bin/env ruby 

# Sample script to retrive gmail list from IMAP connection
# see Net::IMAP Library for more information

require 'net/imap'
require 'rubygems'
require 'highline/import'
require 'yaml'

class Mymail
    def initialize()
        @connect_info = YAML::load(File.open('mymailpref.yml'))
        system("clear")
        @getpasswd = ask("Enter your password:  ") { |q| q.echo = "*" }
    end
    
    def connect()
     
        print "Connecting to server...   "
        
        begin	
	        @imap = Net::IMAP.new(@connect_info[:server], @connect_info[:port], @connect_info[:ssl])
	        print "[CONNECTED]\n"
        rescue
	        print "Can't connect to server...  Check mymailprefs.yml file.\n\n"
	        exit
        end
    end
        
    def login()
        
        print "Attempting login...   "

        begin
	        @imap.login(@connect_info[:login], @getpasswd)
	        print "[OK]\n\n"
        rescue
	        print "Can't login... Check mymailprefs.yml file. \n\n"
	        exit
        end
    end
    
    def list_inbox()
        
        puts "=== INBOX LISTING ==================="
        puts "Name | Email Address | Subject | Date"
        puts "-------------------------------------\n"
        
        @imap.examine('INBOX')
        @imap.search(["SEEN"]).reverse_each do |m_id|
            @list = @imap.fetch(m_id, "ENVELOPE")[0]
            @list_contents = @list.attr["ENVELOPE"]
            puts "#{@list_contents.from[0].name} | #{@list_contents.sender[0].mailbox}@#{@list_contents.sender[0].host} | #{@list_contents.subject} | #{@list_contents.date}"
        end    
        
        puts "=== END LIST ========================\n\n"  
        
    end
    
    def clean_up()
        print "Loging out...   "
        @imap.logout()
        print "[OK]\n"

        print "Disconnecting from server...   "
        @imap.disconnect()
        print "[OK]\n\n"
    end
end

if (__FILE__ == $0) 
    chkmail = Mymail.new
    
    chkmail.connect
    chkmail.login
    chkmail.list_inbox

    while true
    
      @menu_prompt = ask("Command> ") { |q| q.limit = 2 }
     
      if @menu_prompt == "h" || @menu_prompt == "?"
      
        print "Help Text \n"
        print "---------------------\n\n"
        print "l = Fetch mailbox again\n"
        print "h = Help\n"
        print "x = Exit\n"
        print "---------------------\n\n"
      
      elsif @menu_prompt == "l"
        
        chkmail.list_inbox
      
      elsif @menu_prompt == "x" 
            exit
      else
            print "\n\nInvalid command... Type \"h\" for help...\n\n"  
      end
     
    end

# Must have exited...  Logout and Cleanup connection...
print "\n\n"
chkmail.clean_up   

end


