require 'discordrb'
require 'yaml'

CONFIG = YAML.load_file('config.yaml')
bot = Discordrb::Commands::CommandBot.new token: CONFIG['emitoken'], client_id: 352488228739088385, prefix: ['e!']
owner = 275353479701069825
@bot = bot
@version = '2.7.3'
@verifier = 314277049688653825
@owner = 201092063519834112
@nopm = "You cannot use this command in DMs."
@usernoperm = "You do not have permission to use this command."
@botnoperm = "The bot does not have permission to do that!"
@badsyntax = "Incorrect command usage. Please make sure you are using "

#Starts on boot
bot.ready do |event|
	puts "Emibot v#{@version} succesfully launched!"
	bot.game = @version
	bot.send_message(320887626796236800, "✅ Emibot v#{@version} is starting...")
	Dir.mkdir "user"
	Dir.mkdir "server"
	Dir.mkdir "bot"
end

bot.command :update do |event|
	event.respond("Deleting existing Emibot...")
	File.delete("emibot.rb")
	event.respond("Downloading latest Emibot...")
	system 'wget http://cfw.guide/botz/emibot.rb'
	event.respond("Emibot updated! Restart the bot to run the update.")
end

def permission_checker(member, permissions, channel)
	if not member.is_a?(Discordrb::Member)
		raise TypeError, "member argument has to be Member Class"
	end
	@channel = channel
	if not channel.is_a?(Discordrb::Channel) and not channel.nil?
		puts "Unknown Channel, assuming nil."
		@channel = nil
	end
	@member = member
	return false if permissions.nil?
	@required_sym_checks = Array.new()
	if permissions.is_a?(Array)
		permissions.each { |x|
			if x.is_a?(String)
				@required_sym_checks += [x.downcase.gsub(" ","_").to_sym]
			elsif x.is_a?(Symbol)
				@required_sym_checks += [x]
			else
				raise TypeError, "Unexpected permission type found in permission array.\nFound a #{x.class}\n\nSince permissions are a sensitive subject, not letting it pass."
			end
		}
	elsif permissions.is_a?(String)
		@required_sym_checks += [permissions.downcase.gsub(" ","_").to_sym]
	elsif permissions.is_a?(Symbol)
		@required_sym_checks += [permissions]
	else
		raise TypeError, "Invalid permissions variable type.\nReceive a #{permissions.class}\nExpected types: \n -Array (with permissions strings and or symbols)\n -String\n -Symbol"
	end
	@meets_requirements = true
	@required_sym_checks.each {|x|
		if not @member.defined_permission?(x, @channel)
			@meets_requirements = false
		end
	}
	return @meets_requirements
end

def datetime_format(datetime_string,type)
  	month_list = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  	datetime_string = datetime_string.to_s
  	tmp = datetime_string.split()
	date = tmp[0].split("-")
	date = date[2] + " " + month_list[date[1].to_i - 1] + ", " + date[0]
	time = tmp[1].split(":")
	time = time[0] + ":" + time[1]
	timezone = "GMT" + tmp[2].insert(3, '.')
	if type == 0
		return [date, time, timezone].join(" ")
	elsif type == 1
		return time
	elsif type == 2
		return [date].join(" ")
	else
		return "unknown type"
	end
end

def msg_channel(string,type)
  if string =~ /<#/i ? true : false
    string = string.rpartition('<#').last
    if string =~ />/i ? true : false
	  string = string.rpartition('>').first
	  if !@bot.channel(string).nil?
	  	if type == 0
			return @bot.channel(string)
		elsif type == 1
			return true
		end
	  end
	end
  end
end

def read_s(path)
  return "#{open(path, "rb").close(); open(path, "rb").read().to_s}"
end

def write(path, text)
  open(path, "wb").write(text)
  open(path, "wb").close()
end

def region(region)
  return region.gsub('london','London').gsub('eu-west','Western Europe').gsub('amsterdam','Amsterdam').gsub('brazil','Brazil').gsub('eu-central','Central Europe').gsub('hongkong','Hong Kong').gsub('russia','Russia').gsub('us-east','US East').gsub('us-east','US East').gsub('us-central','US Central').gsub('us-east','US East').gsub('us-south','US South').gsub('us-west','US West').gsub('sydney','Sidney').gsub('singapore','Singapore')
end

    #======#
    # Help #
    #======#

bot.command(:help) do |event,*args|
  if args.join('').empty?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "❓ Emibot Command List"
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://cdn.discordapp.com/attachments/273573839995142146/301434291496157195/unknown.png')
    e.description = "```e!help 1 - General\ne!help 2 - Profiles\ne!help 3 - Miscellaneous\ne!help 4 - Moderation```"
    end
  elsif args.join('') == "1"
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "❓ Emibot General Commands"
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://cdn.discordapp.com/attachments/273573839995142146/301434291496157195/unknown.png')
    e.description = "```e!help  - A list of commands\ne!rate  - Rates inputs out of 10\ne!rep   - Gives a user a reputation point\ne!flip  - Flips a coin\ne!roll  - Rolls a die\ne!8ball - Ask the Magic 8-Ball a question.\ne!ship  - Ships people and estimates their compatibility.\ne!hello - Say hello to the bot.\ne!hug   - Give a user a hug\ne!f     - Shows respects paid```"
    end
  elsif args.join('') == "2"
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "❓ Emibot Profile Commands"
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://cdn.discordapp.com/attachments/273573839995142146/301434291496157195/unknown.png')
    e.description = "```e!profile  - Shows a user's info\ne!fc       - Shows a user's gaming usernames\ne!user     - Shows a user's Discord information\ne!about    - Enter information about you\ne!location - Enter your city, state or country\ne!pronouns - Enter your preferred pronouns```"
    end
  elsif args.join('') == "3"
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "❓ Emibot Miscellaneous Commands"
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://cdn.discordapp.com/attachments/273573839995142146/301434291496157195/unknown.png')
    e.description = "```e!userid    - Gives a user's unique ID\ne!serverid  - Gives a server's unique ID\ne!channelid - Gives a channel's unique ID\ne!messageid - Gives the last message's unique ID\ne!avatar    - Gives a user's avatar URL\ne!icon      - Gives a server's icon URL\ne!channel   - Gives a channel's Discord information\ne!server    - Gives a server's Discord information\ne!message   - Gives the last five message's information```"
    end
  elsif args.join('') == "4"
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "❓ Emibot Moderation Commands"
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: 'https://cdn.discordapp.com/attachments/273573839995142146/301434291496157195/unknown.png')
    e.description = "```e!permcheck - Check a user's permissions\ne!pin       - Pins the most recent message\ne!prune     - Delete multiple messages\ne!kick      - Kicks a user\ne!ban       - Bans a user\ne!greet     - Enable/Disable Emibot's join/leave messages\ne!cchannel  - Create a channel```"
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "Please choose a number between 1 and 4."
    end
  end
end
	
    #===============#
    # User Commands #
    #===============#

#Bot infortmation
bot.command([:ver, :version, :test]) do |event|
  event.channel.send_embed do |e|
  e.colour = '7c26cb'
  e.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'Emibot', url: 'https://discord.gg/', icon_url: 'https://cdn.discordapp.com/attachments/273573839995142146/301434291496157195/unknown.png')
  e.description = "Version #{@version}"
  end
end

#Rates things
bot.command(:rate) do |event,*args|
  rate = args.join(' ').gsub('*','').gsub('_','').gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here")
  if rate == "<@#{event.bot.profile.id}>" or rate == "<@!#{event.bot.profile.id}>" or rate == "Emibot" or rate == 'emibot' or rate == 'emi-bot' or rate == 'EmiBot' or rate == 'Emi-Bot'
    event.respond("Hmm, I'd give myself an 11 out of 10.")
  elsif rate.empty?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!rate `<text>`"
    end
  else
    numb = rand(11)
    event.respond("Hmm, I'd give #{rate} a#{"n" if numb == 8} #{numb} out of 10.")
  end
end

#Ships people
bot.command(:ship) do |event,tag1,x,tag2|
  if tag1.empty? or x.empty?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!ship `<@User1#0001> x <@User2#0002>`"
    end
  elsif x == "x" and tag2.empty?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!ship `<@User1#0001> x <@User2#0002>`"
    end
  else
    ship = rand(101)
    event.respond("#{"💖" if ship > 89}#{"😄" if ship > 79 and ship < 90}#{"😀" if ship > 69 and ship < 80}#{"🙂" if ship > 59 and ship < 70}#{"🤔" if ship > 49 and ship < 60}#{"😐" if ship > 39 and ship < 50}#{"😕" if ship > 29 and ship < 40}#{"🙁" if ship > 19 and ship < 30}#{"🙁" if ship > 9 and ship < 20}#{"😞" if ship < 10} Hmm, there's a #{ship}% chance of that working out.")
  end
end

#Says hello
bot.message(with_text: "<@301080010104766474>") do |event|
    event.respond("Hiya, #{event.user.mentiom}!")
end
bot.message(with_text: "<@!301080010104766474>") do |event|
    event.respond("Hiya, #{event.user.mentiom}!")
end
bot.command(:hello) do |event|
    event.respond("Hiya, #{event.user.mention}!")
end

#Flips a coin
bot.command(:flip) do |event|
  event.respond("The coin landed on #{rand(2) == 0 ? "Tails": "Heads"}!")
end

#Rolls a die
bot.command(:roll) do |event,*args|
  unless args.join('').to_i.nil? num = args.join('').to_i then num = 6; num end
  die = rand(num) + 1
  event.respond("I rolled a #{num} sided die and got#{" a#{"n" if die == 8}" if die < 10} #{die}!")
end

#Magic 8 Ball
bot.command([:"8ball", :magic8]) do |event,*args|
  if args.join(' ').gsub('*','').gsub('_','').gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here").empty?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!8ball `<Y/N Question>`"
    end
  else
    rand = rand(20)
    event.respond(":8ball: #{"It is certain." if rand == 0}#{"It is decidedly so." if rand == 1}#{"Without a doubt." if rand == 2}#{"Yes, definitely." if rand == 3}#{"You may rely on it." if rand == 4}#{"As I see it, yes." if rand == 5}#{"Most likely." if rand == 6}#{"Outlook good." if rand == 7}#{"Yes." if rand == 8}#{"Signs point to yes." if rand == 9}#{"Reply hazy, try again." if rand == 10}#{"Ask again later." if rand == 11}#{"Better not tell you now." if rand == 12}#{"Cannot predict now." if rand == 13}#{"Concentrate and ask again." if rand == 14}#{"Don't count on it." if rand == 15}#{"My reply is no." if rand == 16}#{"My sources say no." if rand == 17}#{"Outlook not so good." if rand == 18}#{"Very doubtful." if rand == 19}")
  end
end

bot.bucket :day, delay: 86400

#Rep
bot.command(:rep, bucket: :day, rate_limit_message: 'You can only use this command every 24 hours!') do |event|
  rep = "#{a = open("./user/#{event.server.member(event.message.mentions[0].id).id}/rep", "rb")
    count = a.read()
    a.close(); count.to_s}" if File.exist?("./user/#{event.server.member(event.message.mentions[0].id).id}/rep")
  if event.message.mentions.empty?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!rep `@User#0000`"
    end
  else
    user = event.server.member(event.message.mentions[0].id)
    if user.id == event.user.id
      event.respond("You can't rep yourself!")
    else
      event.respond("#{event.user.name} gave #{user.name} a reputation point!")
      if !File.exist?("./user/#{user.id}/rep")
        Dir.mkdir "user/#{user.id}"
        write("./user/#{user.id}/rep", 1)
      else
        Dir.mkdir "user/#{user.id}"
        write("./user/#{user.id}/rep", read_s("./user/#{user.id}/rep").to_i + 1)
      end
    end
  end
end

#Rep
bot.command(:forcerep) do |event|
  if event.user.id == 275353479701069825
    rep = "#{a = open("./user/#{event.server.member(event.message.mentions[0].id).id}/rep", "rb")
      count = a.read()
      a.close(); count.to_s}" if File.exist?("./user/#{event.server.member(event.message.mentions[0].id).id}/rep")
    if event.message.mentions.empty?
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!rep `@User#0000`"
      end
    else
      user = event.server.member(event.message.mentions[0].id)
      if user.id == event.user.id
        event.respond("You can't rep yourself!")
      else
        event.respond("#{event.user.name} gave #{user.name} a reputation point!")
        if !File.exist?("./user/#{user.id}/rep")
          Dir.mkdir "user/#{user.id}"
          write("./user/#{user.id}/rep", 1)
        else
          Dir.mkdir "user/#{user.id}"
          write("./user/#{user.id}/rep", read_s("./user/#{user.id}/rep").to_i + 1)
        end
      end
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

# Friendcodes
bot.command([:fc, :friendcode, :friendcodes]) do |event,mode,type,*args|
  if mode == "set" or mode == "s" then
    if type == "3ds" then
      friendcode = args.join('').gsub('-', '').gsub(' ', '')
      if friendcode.length != 12 or friendcode.to_i == 0 then
        event.channel.send_embed do |e|
          e.colour = '7c26cb'
          e.title = "Error"
          e.description = "Invalid 3DS Friend Code. Please only use numbers, spaces and dashes."
        end
      else
        event.respond("Friendcode set to `#{friendcode.insert(8, " - ").insert(4, " - ")}`")
        Dir.mkdir "user/#{event.user.id}"
        a = open("./user/#{event.user.id}/friendcode", "wb")
        a.write(friendcode)
        a.close()
      end
    elsif type == "wiiu" or type == "WiiU" or type == "nnid" then
      nnid = args.join('')
      if nnid.length > 16 or nnid.length < 6 then
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "Invalid NNID. Your NNID must be between 6 and 16 characters long."
        end
      else
        event.respond("NNID set to `#{nnid}`")
        Dir.mkdir "user/#{event.user.id}"
        a = open("./user/#{event.user.id}/nnid", "wb")
        a.write(nnid)
        a.close()
      end
    elsif type == "switch" then
      friendcode = args.join('').gsub('-', '').gsub(' ', '')
      if friendcode.length != 12 or friendcode.to_i == 0 then
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = 'Invalid Switch Friend Code. Please only use numbers, spaces and dashes. Do not include "SW".'
        end
      else
        event.respond("Switch friendcode set to `SW - #{friendcode.insert(8, " - ").insert(4, " - ")}`")
        Dir.mkdir "user/#{event.user.id}"
        a = open("./user/#{event.user.id}/switchfriendcode", "wb")
        a.write(friendcode)
        a.close()
      end
    elsif type == "steam" then
      steamun = args.join('')
      if steamun.length > 64 or steamun.length < 2 then
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "Invalid Steam ID. Your Steam ID must be between 3 and 64 characters long."
        end
      else
        event.respond("Steam ID set to `#{steamun}`")
        Dir.mkdir "user/#{event.user.id}"
        a = open("./user/#{event.user.id}/steam", "wb")
        a.write(steamun)
        a.close()
      end
    elsif type == "psn" then
      psn = args.join('')
      if psn.length > 16 or psn.length < 3 then
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "Invalid PSN ID. Your PSN ID must be between 3 and 16 characters long."
        end
      else
        event.respond("PSN ID set to `#{psn}`")
        Dir.mkdir "user/#{event.user.id}"
        a = open("./user/#{event.user.id}/psn", "wb")
        a.write(psn)
        a.close()
      end
    elsif type == "battle" then
      battletag = args.join('')
	  if battletag.include? "#" then
	    if (battletag.rpartition('#').first.length <= 12) and (battletag.rpartition('#').first.length >= 3)
	      if (battletag.rpartition('#').last !~ /[^0-9]/i) and (battletag.rpartition('#').last.length == 5 or battletag.rpartition('#').last.length == 4)
		    if (battletag.rpartition('#').first !~ /[^a-z0-9]/i)
		      if !(battletag[0] !~ /[^0-9]/i)
		        event.respond("BattleTag set to `#{battletag}`")
			    Dir.mkdir "user/#{event.user.id}"
			    a = open("./user/#{event.user.id}/battletag", "wb")
			    a.write(battletag)
			    a.close()
		      else
			    event.channel.send_embed do |e|
			    e.colour = '7c26cb'
			    e.title = "Error"
			    e.description = "Invalid BattleTag. Your BattleTag must not start with a number."
			    end
		      end
		    else
		      event.channel.send_embed do |e|
		      e.colour = '7c26cb'
		      e.title = "Error"
		      e.description = "Invalid BattleTag. Your BattleTag must not include symbols."
		      end
		    end
	      else
		    event.channel.send_embed do |e|
		    e.colour = '7c26cb'
		    e.title = "Error"
		    e.description = "Invalid BattleTag. Your BattleTag must end with five numbers."
		    end
	      end
	    else
	      event.channel.send_embed do |e|
	      e.colour = '7c26cb'
	      e.title = "Error"
	      e.description = "Invalid BattleTag. Your BattleTag must be between 3 and 12 characters long."
	      end
	    end
	  else
	    event.channel.send_embed do |e|
	    e.colour = '7c26cb'
	    e.title = "Error"
	    e.description = "Invalid BattleTag. Your BattleTag must end with a hashtag and five numbers."
	    end
	  end
    elsif type == "gbatemp" or type == "temp" then
      if event.server.id == 201091353575292928 or event.server.id == 255075882320789517 or event.server.id == 326094857208856578 then
        temp = args.join('')
        if temp.length != 6 then
          event.channel.send_embed do |e|
            e.colour = '7c26cb'
            e.title = "Error"
            e.description = "Invalid GBAtemp ID. Your GBAtemp ID must be 6 numbers long."
          end
        else
          event.respond("GBAtemp ID set to `#{temp}`")
          Dir.mkdir "user/#{event.user.id}"
          a = open("./user/#{event.user.id}/temp", "wb")
          a.write(temp)
          a.close()
        end
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Usage"
        e.description = "```e!fc s 3ds    - Set 3DS friendcode\ne!fc s wiiu   - Set Wii U NNID\ne!fc s switch - Set Switch friendcode\ne!fc s steam  - Set Steam ID\ne!fc s psn    - Set PSN ID```"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Usage"
      e.description = "```e!fc s 3ds    - Set 3DS friendcode\ne!fc s wiiu   - Set Wii U NNID\ne!fc s switch - Set Switch friendcode\ne!fc s steam  - Set Steam ID\ne!fc s psn    - Set PSN ID\ne!fc s battle - Set Battle Tag```"
      end
    end
  elsif mode == "remove" or mode == "r" then
    user = event.user
    if type == "3ds" then
      File.delete("./user/#{user.id}/friendcode") if File.exist?("./user/#{user.id}/friendcode")
      event.respond("3DS friendcode removed.")
    elsif type == "wiiu" or type == "wii u" or type == "Wii U" or type == "WiiU" or type == "nnid" then
      File.delete("./user/#{user.id}/nnid") if File.exist?("./user/#{user.id}/nnid")
      event.respond("Wii U NNID removed.")
    elsif type == "switch" then
      File.delete("./user/#{user.id}/switchfriendcode") if File.exist?("./user/#{user.id}/switchfriendcode")
      event.respond("Switch friendcode removed.")
    elsif type == "steam" then
      File.delete("./user/#{user.id}/steam") if File.exist?("./user/#{user.id}/steam")
      event.respond("Steam ID removed.")
    elsif type == "psn" then
      File.delete("./user/#{user.id}/psn") if File.exist?("./user/#{user.id}/psn")
      event.respond("PSN ID removed.")
    elsif type == "battle" then
      File.delete("./user/#{user.id}/battletag") if File.exist?("./user/#{user.id}/battletag")
      event.respond("BattleTag removed.")
    elsif type == "temp" or "gbatemp" then
      if event.server.id == 201091353575292928 or event.server.id == 255075882320789517 or event.server.id == 326094857208856578
        File.delete("./user/#{user.id}/temp") if File.exist?("./user/#{user.id}/temp")
        event.respond("GBAtemp ID removed.")
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Usage"
        e.description = "```e!fc r 3ds    - Remove 3DS friendcode\ne!fc r wiiu   - Remove Wii U NNID\ne!fc r switch - Remove Switch friendcode\ne!fc r steam  - Remove Steam ID\ne!fc r psn    - Remove PSN ID\ne!fc r battle - Remove BattleTag```"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Usage"
      e.description = "```e!fc r 3ds    - Remove 3DS friendcode\ne!fc r wiiu   - Remove Wii U NNID\ne!fc r switch - Remove Switch friendcode\ne!fc r steam  - Remove Steam ID\ne!fc r psn    - Remove PSN ID\ne!fc r battle - Remove Battle Tag```" if event.server.id != 201091353575292928 or event.server.id != 255075882320789517 or event.server.id != 326094857208856578
      e.description = "```e!fc r 3ds    - Remove 3DS friendcode\ne!fc r wiiu   - Remove Wii U NNID\ne!fc r switch - Remove Switch friendcode\ne!fc r steam  - Remove Steam ID\ne!fc r psn    - Remove PSN ID\ne!fc r battle - Remove Battle Tag\ne!fc r temp   - Remove GBAtemp ID```"  if event.server.id == 201091353575292928 or event.server.id == 255075882320789517 or event.server.id == 326094857208856578
      end
    end
  elsif mode == "view" or mode == "v"
    user = event.user
    if !event.channel.private? and !event.message.mentions.empty? then
      user = event.server.member(event.message.mentions[0].id)
    end
    if !File.exist?("./user/#{user.id}/friendcode") and !File.exist?("./user/#{user.id}/nnid") and !File.exist?("./user/#{user.id}/switchfriendcode") and !File.exist?("./user/#{user.id}/steam") and !File.exist?("./user/#{user.id}/psn") and !File.exist?("./user/#{user.id}/temp") and !File.exist?("./user/#{user.id}/battle") then
      event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "This user has not set any friendcodes or NNIDs." if !event.channel.private? and !event.message.mentions.empty?
        e.description = "You have not set any friendcodes or NNIDs.```e!fc s 3ds    - Set 3DS friendcode\ne!fc s wiiu   - Set Wii U NNID\ne!fc s switch - Set Switch friendcode\ne!fc s steam  - Set Steam ID\ne!fc s psn    - Set PSN ID\ne!fc s battle - Set BattleTag```" if event.channel.private? or event.message.mentions.empty?
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar_id}.#{user.avatar_id.start_with?('a_') ? 'gif' : 'webp'}") unless user.avatar_url == "https://discordapp.com/api/v6/users/#{user.id}/avatars/.jpg"
      e.add_field(name: "Friendcodes", value: "#{user.name}##{user.discriminator}", inline: true)
      e.add_field(name: "3DS", value: read_s("./user/#{user.id}/friendcode"), inline: true) if File.exist?("./user/#{user.id}/friendcode")
      e.add_field(name: "Wii U", value: read_s("./user/#{user.id}/nnid"), inline: true) if File.exist?("./user/#{user.id}/nnid")
      e.add_field(name: "Switch", value: "SW - #{read_s("./user/#{user.id}/switchfriendcode")}", inline: true) if File.exist?("./user/#{user.id}/switchfriendcode")
      e.add_field(name: "Steam", value: read_s("./user/#{user.id}/steam"), inline: true) if File.exist?("./user/#{user.id}/steam")
      e.add_field(name: "PSN ID", value: read_s("./user/#{user.id}/psn"), inline: true) if File.exist?("./user/#{user.id}/psn")
      e.add_field(name: "BattleTag", value: read_s("./user/#{user.id}/battletag"), inline: true) if File.exist?("./user/#{user.id}/battletag")
	  if !event.channel.private?
        if event.server.id == 201091353575292928 or event.server.id == 255075882320789517 or event.server.id == 326094857208856578
          e.add_field(name: "GBAtemp", value: "**[Link](http://gbatemp.net/members/#{read_s("./user/#{user.id}/temp")}/)**", inline: true) if File.exist?("./user/#{user.id}/temp")
        end
	  end
      e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Profile - e!profile | User Info - e!user")
      end
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Usage"
    e.description = "```e!fc s - Set a friendcode\ne!fc r - Remove a friendcode\ne!fc v - View your or another user's friendcodes```"
    end
  end
end

# About
bot.command(:about) do |event,mode,*args|
  if mode == "set" or mode == "s"
    if args.join(' ').gsub('*','').gsub('_','').empty?
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!about set `<about you>`"
      end
	else
      if args.join(' ').length > 50
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "You cannot exceed 50 characters."
        end
      else
        event.respond("About info set! View this with `e!profile`")
        Dir.mkdir "user/#{event.user.id}"
        write_s("./user/#{event.user.id}/about", "wb", args.join(' ').gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here"))
      end
	end
  elsif mode == "remove" or mode == "r"
    if File.exist?("./user/#{event.user.id}/about")
      File.delete("./user/#{event.user.id}/about")
      event.respond("About info removed.")
	else
	  event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "You haven't set your about info yet. Set your about info with `e!about set`"
      end
	end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Usage"
    e.description = "```e!about s - Set about info\ne!about r - Remove about info```"
	end
  end
end

# Location
bot.command([:location, :loc]) do |event,mode,*args|
  if mode == "set" or mode == "s"
    if args.join(' ').gsub('*','').gsub('_','').empty?
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!location set `<location>`"
      end
	else
      if args.join(' ').length > 50
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "You cannot exceed 50 characters."
        end
      else
        event.respond("Location set! View this with `e!profile`")
        Dir.mkdir "user/#{event.user.id}"
        write_s("./user/#{event.user.id}/loc", "wb", args.join(' ').gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here"))
      end
	end
  elsif mode == "remove" or mode == "r"
    if File.exist?("./user/#{event.user.id}/loc")
      File.delete("./user/#{event.user.id}/loc")
      event.respond("Location removed.")
	else
	  event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "You haven't set a location yet. Set a location with `e!location set` or `e!loc s`"
      end
	end
  else
    e.description = "```e!location s - Set location\ne!location r - Remove location```"
  end
end

# Pronouns
bot.command([:pronoun, :pronouns, :pro]) do |event,mode,*args|
  if mode == "set" or mode == "s"
    if args.join(' ').gsub('*','').gsub('_','').empty?
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!pronouns set `<pronouns>`"
      end
	else
      if args.join(' ').length > 50
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "You cannot exceed 50 characters."
        end
      else
        event.respond("Pronouns set! View this with `e!profile`")
        Dir.mkdir "user/#{event.user.id}"
        write_s("./user/#{event.user.id}/pronouns", "wb", args.join(' ').gsub('@everyone', "@\x00everyone").gsub('@here', "@\x00here"))
      end
	end
  elsif mode == "remove" or mode == "r"
    if File.exist?("./user/#{event.user.id}/pronouns")
      File.delete("./user/#{event.user.id}/pronouns")
      event.respond("Pronouns removed.")
	else
	  event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "You haven't set your pronouns yet. Set your pronouns with `e!pronouns set` or `e!pro s`"
      end
	end
  else
    e.description = "```e!pronouns s - Set pronouns\ne!pronouns r - Remove pronouns```"
  end
end

# Profile
bot.command(:profile) do |event|
  user = event.user
  if !event.message.mentions.empty?
    user = event.server.member(event.message.mentions[0].id) # overwrite with first mention if any
  end
  event.channel.send_embed do |e|
  e.colour = '7c26cb'
  e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar_id}.#{user.avatar_id.start_with?('a_') ? 'gif' : 'webp'}") unless user.avatar_url == "https://discordapp.com/api/v6/users/#{user.id}/avatars/.jpg"
  e.add_field(name: "Profile", value: "#{user.name}##{user.discriminator}", inline: true)
  e.add_field(name: "About", value: read_s("./user/#{user.id}/about"), inline: true) if File.exist?("./user/#{user.id}/about")
  e.add_field(name: "About", value: "Nothing set.", inline: true) if !File.exist?("./user/#{user.id}/about")
  e.add_field(name: "Location", value: read_s("./user/#{user.id}/loc"), inline: true) if File.exist?("./user/#{user.id}/loc")
  e.add_field(name: "Location", value: "Nothing set.", inline: true) if !File.exist?("./user/#{user.id}/loc")
  e.add_field(name: "Pronouns", value: read_s("./user/#{user.id}/pronouns"), inline: true) if File.exist?("./user/#{user.id}/pronouns")
  e.add_field(name: "Pronouns", value: "Nothing set.", inline: true) if !File.exist?("./user/#{user.id}/pronouns")
  e.add_field(name: "Rep", value: read_s("./user/#{user.id}/rep"), inline: true) if File.exist?("./user/#{user.id}/rep")
  e.add_field(name: "Rep", value: "0") if !File.exist?("./user/#{user.id}/rep")
  e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Friendcodes - e!fc | User Info - e!user")
  end
end

# User info
bot.command([:user, :me, :lookup, :info]) do |event,*args|
  proceed = true
  user = event.user
  if !event.message.mentions.empty?
    user = event.server.member(event.message.mentions[0].id) # overwrite with first mention if any
  elsif args[0] =~ /\A\d+\z/ ? true : false
    user = event.server.member(args[0].to_i) if !event.server.member(args[0].to_i) == 0
    if event.server.member(args[0].to_i) == 0
      event.respond("That User ID is invalid.")
      proceed = false
    end
  end
  if proceed
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar_id}.#{user.avatar_id.start_with?('a_') ? 'gif' : 'webp'}") unless user.avatar_id.nil?
    if event.message.mentions.empty? and event.user.status.to_s == "offline" then
      status = "Invisible"
    else
      status = user.status.to_s.gsub("dnd", "Do not Disturb").capitalize
    end
    e.add_field(name: "User Info", value: "#{user.name}##{user.discriminator}", inline: true)
    e.add_field(name: "Nickname", value: user.nick, inline: true) unless user.nick.nil?
    e.add_field(name: "Status", value: status, inline: true)
    e.add_field(name: "Playing", value: user.game, inline: true) unless user.game.nil?
    e.add_field(name: "Bot Account", value: "Yes", inline: true) if user.bot_account
    e.add_field(name: "Joined Server", value: datetime_format(user.joined_at,2), inline: true)
    e.add_field(name: "Account Created", value: datetime_format(user.creation_time,2), inline: true)
	e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Profile - e!profile | Friendcodes - e!fc")
    end
  end
end
bot.command([:"user+", :"me+", :"profile+", :"lookup+", :"info+"]) do |event,*args|
  proceed = true
  user = event.user
  if !event.message.mentions.empty?
    user = event.server.member(event.message.mentions[0].id) # overwrite with first mention if any
  elsif args[0] =~ /\A\d+\z/ ? true : false
    user = event.server.member(args[0].to_i) if not event.server.member(args[0].to_i) == 0
    if event.server.member(args[0].to_i) == 0
      event.respond("That User ID is invalid.")
      proceed = false
    end
  end
  if proceed
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar_id}.#{user.avatar_id.start_with?('a_') ? 'gif' : 'webp'}") unless user.avatar_id.nil?
    e.add_field(name: "User Info", value: "#{user.name}##{user.discriminator}", inline: true)
    if not user.nick.nil?
      e.add_field(name: "Nickname", value: user.nick, inline: true)
    else
      e.add_field(name: "Nickname", value: "None", inline: true)
    end
    e.add_field(name: "Status", value: user.status.to_s.gsub("dnd", "Do not Disturb").capitalize, inline: true)
    if not user.game.nil?
      e.add_field(name: "Playing", value: user.game, inline: true)
    else
      e.add_field(name: "Playing", value: "Nothing", inline: true)
    end
    if user.bot_account?
      e.add_field(name: "Bot Account", value: "Yes", inline: true)
    else
      e.add_field(name: "Bot Account", value: "No", inline: true)
    end
    e.add_field(name: "Joined Server", value: datetime_format(user.joined_at,2), inline: true)
    e.add_field(name: "Account Created", value: datetime_format(user.creation_time,2), inline: true)
    e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "User ID: #{user.id} | Avatar ID: #{user.avatar_id}")
    end
  end
end

#Find User ID
bot.command([:userid, :user_id, :uid]) do |event,*args|
  user = event.user
  if !event.message.mentions.empty?
    user = event.server.member(event.message.mentions[0].id) # overwrite with first mention if any
  end
  event.respond("`#{user.name}##{user.discriminator}` | #{user.id}")
end

#Avatar
bot.command(:avatar) do |event,*args|
  proceed = true
  user = event.user
  if !event.message.mentions.empty?
    user = event.server.member(event.message.mentions[0].id) # overwrite with first mention if any
  elsif args[0] =~ /\A\d+\z/ ? true : false
    user = event.server.member(args[0].to_i) if not event.server.member(args[0].to_i) == 0
    if event.server.member(args[0].to_i) == 0
      event.respond("That User ID is invalid.")
      proceed = false
    end
  end
  if user.avatar_id == nil
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = ("Avatar not found.")
    end
  else
    if proceed
      event.respond("https://cdn.discordapp.com/avatars/#{user.id}/#{user.avatar_id}.#{user.avatar_id.start_with?('a_') ? 'gif' : 'jpg'}")
    end
  end
end

#Server info
bot.command(:server) do |event|
  if event.channel.private?
    event.respond(@nopm)
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/icons/#{event.server.id}/#{event.server.icon_id}.jpg") unless event.server.icon_id == nil
    e.add_field(name: "Server Info", value: event.server.name, inline: true)
    onlinebots = event.server.online_members(include_idle: true, include_bots: true).count - event.server.online_members(include_idle: true, include_bots: false).count
    onlinenobot = event.server.online_members(include_idle: true, include_bots: false).count
    e.add_field(name: "Members", value: "#{event.server.member_count} Users | #{onlinenobot} Online | #{onlinebots} Bot#{"s" if onlinebots != 1}", inline: true)
    e.add_field(name: "Owner", value: "#{event.server.owner.name}##{event.server.owner.discriminator}", inline: true)
    e.add_field(name: "Created at", value: datetime_format(event.server.default_channel.creation_time,2), inline: true)
    e.add_field(name: "Region", value: region(event.server.region), inline: true)
    e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Server ID: #{event.server.id}#{" | Icon ID: #{event.server.icon_id}" if !event.server.icon_id.nil?}")
    end
  end
end

#Server icon
bot.command(:icon) do |event|
  if event.channel.private?
    event.respond(@nopm)
  else
    if event.server.icon_id == nil
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = ("Icon not found.")
      end
    else
      event.respond("https://cdn.discordapp.com/icons/#{event.server.id}/#{event.server.icon_id}.jpg")
    end
  end
end

#Server info
bot.command([:serverid, :server_id, :sid]) do |event|
  if event.channel.private?
    event.respond(@nopm)
  else
    event.respond("`#{event.server.name.gsub("`", "")}` | #{event.server.id}")
  end
end

#Channel info
bot.command(:channel) do |event|
  event.channel.send_embed do |e|
  e.colour = '7c26cb'
  if event.channel.private?
    e.add_field(name: "DM Info", value: "#{event.user.name}##{event.user.discrim}", inline: true)
    e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "DMs ID: #{event.channel.id}")
  else
    e.add_field(name: "Channel Info", value: "##{event.channel.name}", inline: true)
    e.add_field(name: "Topic", value: event.channel.topic, inline: true) unless event.channel.topic.nil?
    e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Server ID: #{event.server.id} | Channel ID: #{event.channel.id}")
  end
  end
end

#Channel ID
bot.command([:channelid, :channel_id, :cid]) do |event|
  if event.channel.private?
    event.respond("`##{event.channel.name.gsub("`", "")}` | #{event.channel.id}")
  else
    event.respond("`##{event.channel.name.gsub("`", "")}` | #{event.channel.id}")
  end
end

#Message Info
bot.command(:msg) do |event,*args|
  msg1 = event.channel.history(2)[1]
  msg2 = event.channel.history(3)[2]
  msg3 = event.channel.history(4)[3]
  msg4 = event.channel.history(5)[4]
  msg5 = event.channel.history(6)[5]
  one = "1. #{msg1.content.gsub('`', '')[0...50]}#{"..." if msg1.content.length > 50}\n   Author: #{msg1.user.name}##{msg1.user.discrim}\n   ID: #{msg1.id}"
  two = "2. #{msg2.content.gsub('`', '')[0...50]}#{"..." if msg2.content.length > 50}\n   Author: #{msg2.user.name}##{msg2.user.discrim}\n   ID: #{msg2.id}"
  thr = "3. #{msg3.content.gsub('`', '')[0...50]}#{"..." if msg3.content.length > 50}\n   Author: #{msg3.user.name}##{msg3.user.discrim}\n   ID: #{msg3.id}"
  fou = "4. #{msg4.content.gsub('`', '')[0...50]}#{"..." if msg4.content.length > 50}\n   Author: #{msg4.user.name}##{msg4.user.discrim}\n   ID: #{msg4.id}"
  fiv = "5. #{msg5.content.gsub('`', '')[0...50]}#{"..." if msg5.content.length > 50}\n   Author: #{msg5.user.name}##{msg5.user.discrim}\n   ID: #{msg5.id}"
  event.respond("```#{fiv}\n#{fou}\n#{thr}\n#{two}\n#{one}```")
end

#Message ID
bot.command([:messageid, :message_id, :mid]) do |event,*args|
  event.respond("`#{event.channel.history(2)[1].content.gsub('`', '')}` | #{event.channel.history(2)[1].id}")
end

=begin #Cook
bot.command([:cook, :make]) do |event,food,ingredients|
  if food.nil?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!hug `@User#0000`"
    end
  else
    message = event.channel.send_message("Making #{food}... 0%")
    message
    sleep(0.2)
    message.edit("Making #{food}... 20%")
    sleep(0.2)
    message.edit("Making #{food}... 40%")
    sleep(0.2)
    message.edit("Making #{food}... 60%")
    sleep(0.2)
    message.edit("Making #{food}... 80%")
    sleep(0.2)
    message.edit("Making #{food}... 100%")
    if ingredients.nil?
      event.respond("Your #{food} are ready!")
    else
      message = event.channel.send_message("Adding #{ingredients}... 0%")
      message
      sleep(0.2)
      message.edit("Adding #{ingredients}... 20%")
      sleep(0.2)
      message.edit("Adding #{ingredients}... 40%")
      sleep(0.2)
      message.edit("Adding #{ingredients}... 60%")
      sleep(0.2)
      message.edit("Adding #{ingredients}... 80%")
      sleep(0.2)
      message.edit("Adding #{ingredients}... 100%")
      event.respond("Your #{ingredients} #{food} are ready!")
    end
  end
end
=end

#Hugs
bot.command([:hug, :hugs]) do |event, *_args|
  if !event.message.mentions.empty?
    user = event.user
    target = event.server.member(event.message.mentions[0].id)
    if target.id == user.id
      event.respond("Emibot hugged #{user.id}! :3")
    else
      event.respond("#{user.name} hugged #{target.name}! :3")
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = "#{@badsyntax}e!hug `@User#0000`"
    end
  end
end

    #================#
    # Owner Commands #
    #================#

#Say stuff
bot.command(:say) do |event,*args|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    event.message.delete
    event.respond(args.join(' '))
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Embed stuff
bot.command(:embed) do |event,*args|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    event.message.delete
    embed = args.join(' ')
    event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.description = "#{embed}"
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Change Bot Nickname
bot.command(:nick) do |event,*args|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    nick = args.join(' ')
    if nick.length > 32
      event.respond("Nicknames must be 32 or fewer in length")	
	elsif nick.empty?
	  event.respond("You cannot have a blank nickname.")
	else
      event.respond("Changing nickname to #{nick}...")
      event.bot.profile.on(event.server).nickname = nick
      nil
	end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Reset Bot Nickname
bot.command(:resetnick) do |event|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    event.respond("Resetting nickname...")
    event.bot.profile.on(event.server).nickname = nil
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Change game
bot.command([:game, :play]) do |event,*args|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    game = args.join(' ')
    bot.game = game
    event.respond("Game set to `#{game}`!")
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Reset game
bot.command(:resetgame) do |event|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    event.bot.game = nil
    event.respond("Game reset!")
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Deletes bot's previous message
bot.command(:delete) do |event|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    event.message.delete
    event.channel.history(99).each do |x| 
      if x.author.id == event.bot.profile.id
        x.delete
        break
      end
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Leave server
bot.command(:leave) do |event,*args|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    id = args.join(" ").to_i
    if id.nil?
      id = event.server.id
      name = event.server.name
      event.respond("Leaving server #{name}...")
      event.bot.server(id).leave
    else
      event.respond("Leaving server #{id}...")
      event.bot.server(id).leave
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Eval
bot.command(:beval) do |event, *args|
  if event.user.id == 275353479701069825
    begin
      eval args.join(" ")
    rescue Exception => e
      event.respond("An error has occurred.\nException type: #{e.class}\nException message: #{e.message}")
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Shuts the bot down.
bot.command(:shutdown) do |event|
  if event.user.id == 216226753893498880 or event.user.id == 201016432929144832 or event.user.id == 275353479701069825
    event.respond('❌ Emibot is shutting down.')
    abort
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Shuts the bot down.
bot.command([:restart, :update]) do |event|
    abort if event.user.id == 275353479701069825
end

#Join/Leave Logs
bot.member_join do |event|
  send = true
  channel = event.server.id
  if File.exist?("./server/#{event.server.id}/greet")
    send = false if read_s("./server/#{event.server.id}/greet") == "false"
  end
  if File.exist?("./server/#{event.server.id}/greet_channel")
    channel = read_s("./server/#{event.server.id}/greet_channel").to_i
  end
  bot.send_message(channel,"#{event.user.name} has joined the server!") if send
end

bot.member_leave do |event|
  send = true
  channel = event.server.id
  if File.exist?("./server/#{event.server.id}/greet")
    send = false if read_s("./server/#{event.server.id}/greet") == "false"
  end
  if File.exist?("./server/#{event.server.id}/greet_channel")
    channel = read_s("./server/#{event.server.id}/greet_channel").to_i
  end
  if @leave
    send = false
  end
  if send
    bot.send_message(channel,"#{event.user.name}##{event.user.discrim} has left the server.")
	@leave = false
  end
end

bot.message do |event|
  if event.server.id == 325593726384734210
    if @channel.nil?
      bot.send_message(339449042738085888, "#{event.message.channel.server.name} - ##{event.message.channel.name}\n#{event.message.channel.server.id} -  #{event.message.channel.id}\n```#{event.message.author.name}##{event.message.author.discrim} - Today at #{datetime_format(event.message.timestamp,1)}\n#{event.message.content}\n#{event.message.attachments[0].url if !event.message.attachments.empty?}```")
    elsif @channel != event.message.channel.id
      bot.send_message(339449042738085888, "#{event.message.channel.server.name} - ##{event.message.channel.name}\n#{event.message.channel.server.id} -  #{event.message.channel.id}\n```#{event.message.author.name}##{event.message.author.discrim} - Today at #{datetime_format(event.message.timestamp,1)}\n#{event.message.content}\n#{event.message.attachments[0].url if !event.message.attachments.empty?}```")
    elsif @channel == event.message.channel.id
      bot.send_message(339449042738085888, "```#{event.message.author.name}##{event.message.author.discrim} - Today at #{datetime_format(event.message.timestamp,1)}\n#{event.message.content}\n#{event.message.attachments[0].url if !event.message.attachments.empty?}```")
    else
      bot.send_message(339449042738085888, "#{event.message.channel.server.name} - ##{event.message.channel.name}\n#{event.message.channel.server.id} -  #{event.message.channel.id}\n```#{event.message.author.name}##{event.message.author.discrim} - Today at #{datetime_format(event.message.timestamp,1)}\n#{event.message.content}\n#{event.message.attachments[0].url if !event.message.attachments.empty?}```")
    end
    @channel = event.message.channel.id
  end
end

bot.command(:send) do |event,channel,*args|
  if event.user.id == 275353479701069825
    begin
      bot.send_message(channel, args.join(' '))
    rescue Exception => e
      event.respond("An error has occurred.\nException type: #{e.class}\nException message: #{e.message}")
    end
  end
end

    #=====================#
    # Moderation Commands #
    #=====================#

# Permcheck
bot.command(:permcheck) do |event,user,*args|
  if !event.message.mentions.empty? then
    user = event.server.member(event.message.mentions[0].id)
    if args.join('').empty?
      event.respond('You must include a permission!')
    else
      event.respond("User `#{user.name}##{user.discrim}` has the permission `#{args.join(" ")}`.") if permission_checker(event.server.member(user.id), args.join(' '), event.channel) or permission_checker(event.server.member(user.id), administator, event.channel) or user.owner?
      event.respond("User `#{user.name}##{user.discrim}` does not have the permission `#{args.join(" ")}` or that permission does not exist.") if !permission_checker(event.server.member(user.id), args.join(' '), event.channel)
    end
  else
    event.respond('You must mention a user!')
  end
end

# Pin a message
bot.command(:pin) do |event|
  if event.channel.private?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @nopm
    end
  else
    message = event.channel.history(2)[1]
    if event.server.id == 257798048300793856
      begin
        message.pin
        event.respond("Message `#{message.content}` pinned")
      rescue Discordrb::Errors::NoPermission
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = @botnoperm
        end
      end
    else
      if permission_checker(event.server.member(event.user.id), "Manage Messages" , event.channel) or event.server.member(event.user.id).owner? or permission_checker(event.server.member(event.user.id), "Administrator", event.channel)
        begin
          message.pin
          event.respond("Message `#{message.content}` pinned")
        rescue Discordrb::Errors::NoPermission
          event.channel.send_embed do |e|
          e.colour = '7c26cb'
          e.title = "Error"
          e.description = @botnoperm
          end
        end
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = @usernoperm
        end
      end
    end
  end
end

#Ban
bot.command(:ban) do |event,*args|
  if event.channel.private?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @nopm
    end
  else
    if permission_checker(event.server.member(event.user.id), "Ban Members", event.channel) or permission_checker(event.server.member(event.user.id), "Administrator", event.channel) or event.server.member(event.user.id).owner?
      server = event.server
      if event.message.mentions.size != 0
        begin
          @leave = true
          user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
          server.ban(user.id)
          event.respond("#{user.name}##{user.discriminator} has been banned.")
        rescue Discordrb::Errors::NoPermission
          event.channel.send_embed do |e|
          e.colour = '7c26cb'
          e.title = "Error"
          e.description = @botnoperm
          end
          @leave = false
        end
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!ban `@User#0000`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  end
end

#Kick
bot.command(:kick) do |event|
  if event.channel.private?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @nopm
    end
  else
    if permission_checker(event.server.member(event.user.id), "Kick Members", event.channel) or permission_checker(event.server.member(event.user.id), "Administrator", event.channel) or event.server.member(event.user.id).owner?
      server = event.server
      if event.message.mentions.size != 0
        begin
          @leave = true
          user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
          server.kick(user.id)
          event.respond("#{user.name}##{user.discriminator} has been kicked.")
        rescue Discordrb::Errors::NoPermission
          event.channel.send_embed do |e|
          e.colour = '7c26cb'
          e.title = "Error"
          e.description = @botnoperm
          end
          @leave = false
        end
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!kick `@User#0000`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  end
end

#Greet
bot.command(:greet) do |event,*args|
  server = event.server
  state = args.join(' ')
  if not File.exist?("./server/#{server.id}/greet")
   Dir.mkdir "server/#{server.id}"
  end
  if permission_checker(event.server.member(event.user.id), "Administrator", event.channel) or event.server.member(event.user.id).owner? or event.user.id == 275353479701069825
    if state.empty?
      if not File.exist?("./server/#{server.id}/greet")
        Dir.mkdir "server/#{server.id}"
      end
      if read_s("./server/#{server.id}/greet") == "true"
        write("./server/#{server.id}/greet", "false")
        event.respond("Greetings disabled.")
      elsif read_s("./server/#{server.id}/greet") == "false"
        write("./server/#{server.id}/greet", "true")
        event.respond("Greetings enabled.")
      else
        write("./server/#{server.id}/greet", "false")
        event.respond("Greetings disabled.")
      end
    elsif state == "on" 
      write("./server/#{server.id}/greet", "true")
      event.respond("Greetings enabled.")
    elsif state == "off"
      write("./server/#{server.id}/greet", "false")
      event.respond("Greetings disabled.")
    elsif args[0] =~ /\A\d+\z/ ? true : false
	  begin
	    channel = bot.channel(args[0])
	    event.respond("Setting greet channel to <##{channel.id}>...")
		Dir.mkdir("./server") unless Dir.exist?("./server")
		Dir.mkdir("./server/#{server.id}") unless Dir.exist?("./server/#{server.id}")
		write("./server/#{server.id}/greet_channel", channel.id)
	  rescue Exception
	    event.respond("Invalid Channel ID.")
      end
	elsif msg_channel(args.join(''),1)
	  channel = msg_channel(args.join(''),0)
	  event.respond("Setting greet channel to <##{channel.id}>...")
      Dir.mkdir("./server") unless Dir.exist?("./server")
      Dir.mkdir("./server/#{server.id}") unless Dir.exist?("./server/#{server.id}")
	  write("./server/#{server.id}/greet_channel", channel.id)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "Please use `e!greet on` or `e!greet off` to toggle greetings, or `e!greet <channel_id>` to change what channel they go to."
      end
    end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
end

#Prune
bot.command(:prune) do |event,*args|
  if event.channel.private?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @nopm
    end
  else
    num = args.join(' ').to_i
    if num < 1 or num > 99
      event.respond("Please choose a number between 1 and 99.")
    else
      if permission_checker(event.server.member(event.user.id), "Manage Messages", event.channel) or permission_checker(event.server.member(event.user.id), "Administrator", event.channel) or event.server.member(event.user.id).owner?
        begin
          event.channel.prune num + 1
        rescue Discordrb::Errors::NoPermission
          event.channel.send_embed do |e|
          e.colour = '7c26cb'
          e.title = "Error"
          e.description = @botnoperm
          end
        end
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = @usernoperm
        end
      end
    end
  end
end

#Create channel
bot.command([:createchannel, :cchannel, :cc, :"channel+", :"+channel"]) do |event,*args|
  if event.channel.private?
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @nopm
    end
  else
    if permission_checker(event.server.member(event.user.id), "Manage Channels", event.channel) or permission_checker(event.server.member(event.user.id), "Administrator", event.channel) or event.server.member(event.user.id).owner?
      server = event.server
      if !args.join('').gsub('**', '').gsub('_', '').empty?
        begin
          server.create_channel(args.join(''))
          nil
          event.respond("Channel #{args.join('')} created.")
        rescue Discordrb::Errors::NoPermission
          event.channel.send_embed do |e|
          e.colour = '7c26cb'
          e.title = "Error"
          e.description = @botnoperm
          end
        end
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!createchannel `<Name>`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  end
end

    #=======#
    # Lia's #
    #=======#

#VC Roles
bot.voice_state_update() do |event|
    if not event.channel.nil?
        if event.channel.id == 319871493972557835 #if join
            event.server.member(event.user.id).add_role(319916921245925376)
            next
        end
    end
    if not event.old_channel.nil?
        if event.old_channel.id == 319871493972557835 #if leave
            event.server.member(event.user.id).remove_role(319916921245925376)
            next
        end
    end
end
bot.voice_state_update() do |event|
    if not event.channel.nil?
        if event.channel.id == 320981998099496960 #if join
            event.server.member(event.user.id).add_role(321744661817327625)
            next
        end
    end
    if not event.old_channel.nil?
        if event.old_channel.id == 320981998099496960 #if leave
            event.server.member(event.user.id).remove_role(321744661817327625)
            next
        end
    end
end


#Verify
bot.command(:verify) do |event,*args|
  if event.server.id == 201091353575292928
    if event.server.member(event.user.id).role?(314277049688653825)
      if event.message.mentions.size != 0
        user = event.server.member(event.message.mentions[0].id) #overwrite with first mention if any
        event.respond("#{user.name}##{user.discriminator} has been verified.")
        event.server.member(user.id).add_role(201363748466851840)
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!verify `@User#0000`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  elsif event.server.id == 338230405645860865
    if event.user.role?(339900074362404867)
      if event.message.mentions.size != 0
        user = event.server.member(event.message.mentions[0].id) #overwrite with first mention if any
        event.respond("#{user.name}##{user.discriminator} has been verified.")
        event.server.member(user.id).add_role(339903030289760256)
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!verify `@User#0000`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  else
    event.respond("This command is disabled on this server.")
  end
end
bot.command(:unverify) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("#{user.name}##{user.discriminator} has been unverified.")
      event.server.member(user.id).remove_role(201363748466851840)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!unverify `@User#0000`"
      end
      end
  else
    event.channel.send_embed do |e|
    e.colour = '7c26cb'
    e.title = "Error"
    e.description = @usernoperm
    end
  end
else
  event.respond("This command is disabled on this server.")
  end
end

#Furry
bot.command(:addfurry) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Added the Furry role to #{user.name}##{user.discriminator}.")
      event.server.member(user.id).add_role(201362980632264704)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!addfurry `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end
bot.command(:delfurry) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Removed the Furry role from #{user.name}##{user.discriminator}.")
      event.server.member(user.id).remove_role(201362980632264704)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!delfurry `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end

#Anime
bot.command(:addanime) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Added the Anime role to #{user.name}##{user.discriminator}.")
      event.server.member(user.id).add_role(201403853340409856)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!addanime `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end
bot.command(:delanime) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Removed the Anime role from #{user.name}##{user.discriminator}.")
      event.server.member(user.id).remove_role(201403853340409856)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!delanime `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end

#Dream
bot.command(:adddream) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Added the Dream role to #{user.name}##{user.discriminator}.")
      event.server.member(user.id).add_role(225423356520824832)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!adddream `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end
bot.command(:deldream) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@verifier)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Removed the Dream role from #{user.name}##{user.discriminator}.")
      event.server.member(user.id).remove_role(225423356520824832)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!deldream `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end

#Make verifier
bot.command(:addverifier) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@owner)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Added the Verifier role to #{user.name}##{user.discriminator}.")
      event.server.member(user.id).add_role(314277049688653825)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!addverifier `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end
bot.command(:delverifier) do |event,*args|
server = event.server
if event.server.id == 201091353575292928
  if event.server.member(event.user.id).role?(@owner)
    if event.message.mentions.size != 0
      user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
      event.respond("Removed the Verifier role from #{user.name}##{user.discriminator}.")
      event.server.member(user.id).remove_role(314277049688653825)
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = "#{@badsyntax}e!delverifier `@User#0000`"
      end
      end
  else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
else
  event.respond("This command is disabled on this server.")
  end
end

#Temp ban
bot.command(:tempban) do |event,*args|
  server = event.server
  if event.server.id == 201091353575292928
    if event.server.member(event.user.id).role?(@verifier)
      if event.message.mentions.size != 0
        user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
        event.respond("#{user.name}##{user.discriminator} has been temporarily banned.")
        event.server.member(user.id).add_role(318039338950721538)
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!tempban `@User#0000`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  else
    event.respond("This command is disabled on this server.")
  end
end
bot.command(:untempban) do |event,*args|
  server = event.server
  if event.server.id == 201091353575292928
    if event.server.member(event.user.id).role?(@verifier)
      if event.message.mentions.size != 0
        user = server.member(event.message.mentions[0].id) #overwrite with first mention if any
        event.respond("#{user.name}##{user.discriminator} has been unbanned.")
        event.server.member(user.id).remove_role(318039338950721538)
      else
        event.channel.send_embed do |e|
        e.colour = '7c26cb'
        e.title = "Error"
        e.description = "#{@badsyntax}e!untempban `@User#0000`"
        end
      end
    else
      event.channel.send_embed do |e|
      e.colour = '7c26cb'
      e.title = "Error"
      e.description = @usernoperm
      end
    end
  else
    event.respond("This command is disabled on this server.")
  end
end

    #=======#
    # Memes #
    #=======#

#Text stuff
bot.command(:reverse) do |event,*args|
  event.respond(args.join(' ').reverse)
end
bot.command(:upcase) do |event,*args|
  event.respond(args.join(' ').upcase)
end
bot.command(:downcase) do |event,*args|
  event.respond(args.join(' ').downcase)
end

#Pay respects
bot.message(with_text: ["F","f"]) do |event|
  event.respond("Respects have been paid.")
  if File.exist?("./bot/f")
    fcount = "#{a = open("./bot/f", "rb")
    count = a.read()
    a.close(); count.to_s}"
    a = open("./bot/f", "wb")
    a.write(fcount.to_i + 1)
    a.close()
  else
    a = open("./bot/f", "wb")
    a.write(1)
    a.close()
  end
end
bot.command([:f,:F]) do |event|
  if !File.exist?("./bot/f")
    event.respond("No respects have been paid.")
  else
    fcount = "#{a = open("./bot/f", "rb")
    count = a.read()
    a.close(); count.to_s}"
    if fcount == "1"
      event.respond("1 respect has been paid.")
	else
      event.respond("#{fcount} respects have been paid.")
	end
  end
end
  
bot.run

bot.command :baka do |event|
	bakaa = rand(10) + 1
	bakab = rand(10) + 1
	bakac = rand(3) + 1
	event.respond("b#{"a" * bakaa}k#{"a" * bakab}#{"!" * bakac}")
end
