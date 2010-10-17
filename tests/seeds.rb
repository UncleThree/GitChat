require 'rubygems'
require 'yaml'
require 'active_record'
require 'mq'

config = YAML.load(File.open("db.yml"))

ActiveRecord::Base.establish_connection(
  :adapter  => config['adapter'],
  :host     => config['host'],
  :database => config['database'],
  :username => config['username'],
  :password => config['password']
)

require './models/chat'
require './models/commit'
require './models/issue'
require './models/message'
require './models/repository'
require './models/user'
require './models/user_session'
require './lib/gitchat/github'

EventMachine.run do
  sam = User.find_by_username('samdk') || User.create_from_github('samdk')
  eli = User.find_by_username('elitheeli') || User.create_from_github('elitheeli')
  pras = User.find_by_username('prasincs') || User.create_from_github('prasincs')

  clbt = sam.repositories.find_by_name('collabbit')
  share = sam.repositories.find_by_name('share')
  chat = clbt.chat || Chat.create(:repository => clbt)
  chat2 = share.chat || Chat.create(:repository => share)

  messages = [ [sam,"I'm pretty close"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
               [sam,"I'm doing it this way"],
               [eli,"ok"],
               [eli,"good"],
               [eli,"I have 5 minutes."],
               [eli,"Going to finalize deleting"],
               [sam,"k"],
               [eli,"OK deleting works FULLY except that it doesn't delete on the main canvas of the other one"],
               [eli,"works on teh thumbs fine"],
               [eli,"lemme dix"],
               [eli,"fix"],
               [sam,"Prasanna, it works fine in firefox if we get of all of the console.logs"],
               [pras,"ok"],
               [sam,"or if you ahve firebug open when you load the page"],
               [pras,"all right i'm going to remove allc onsole logs"],
               [pras,"from non-server things"],
               [sam,"just wait"],
               [sam,"please"],
               [sam,"don't want conflicts with me"],
               [pras,"oh ok"],
               [pras,"to make it safe you mean?"],
               [sam,"?"],
               [sam,"to make it safe you mean?"],
               [pras,"say you set debug = true somewhere and it turns on console.log"],
               [pras,"yeah"],
             ]
  if chat.messages.empty?
    messages.each do |author,msg|
      m = Message.create(:chat => chat, :author => author, :text => msg, :time => Time.now)
    end
  end
  exit
end