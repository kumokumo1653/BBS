require 'digest/md5'
require 'active_record'
require 'time'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Board < ActiveRecord::Base
end

if(ARGV.count == 2)
    username = ARGV[0];
    message = ARGV[1];
else
    return
end

puts "username = #{username}"
puts "message = #{message}"
if message.length >= 10
    return
end
data = Board.all

s = Board.new
s.name = username
s.date = Time.now.to_i
s.message = message
s.save

data = Board.all
data.each do |a|
    puts a.id 
end

