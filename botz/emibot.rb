require 'discordrb'
require 'yaml'

CONFIG = YAML.load_file('config.yaml')
bot = Discordrb::Commands::CommandBot.new token: CONFIG['emitoken'], client_id: 352488228739088385, prefix: ['e!']
# Put bot token in config.yaml file
owner = 275353479701069825 #Place your User ID here

bot.command :help do |event|
end

# The following is not necessary for self-hosting
bot.command [:restart,:start,:update,:shutdown,:stop] do |event|
	if event.user.id == owner
		abort
		nil
	end
end

bot.command :baka do |event|
	bakaa = rand(10) + 1
	bakab = rand(10) + 1
	bakac = rand(3) + 1
	event.respond("b#{"a" * bakaa}k#{"a" * bakab}#{"!" * bakac}")
end

bot.run
