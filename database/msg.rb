require 'digest/md5'
require 'active_record'
require 'time'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Board < ActiveRecord::Base
end
class Msg
    def initialize
        @data = Board.all
        @data = @data.sort do |a, b|
            a.id <=> b.id
        end
        @id = 1
        for i in @data do
            if i.id.to_i == @id
                @id += 1
            else 
                break
            end
        end
    end

    def add(username, message)

        puts "username = #{username}"
        puts "message = #{message}"
        if message.length >= 100
            return
        end
        
        s = Board.new
        s.id = @id
        s.name = username
        s.date = Time.now.to_i
        s.message = message
        s.save

        #new id
        for i in @id + 1...@data.length do
            if i.id.to_i == @id
                @id += 1
            else 
                break
            end
        end

    end
    
    def del(id)
       
        s = Board.find(id)
        s.destroy
        if id < @id
            @id = id
            @data = Board.all
        end
    end

    def p 
        pp @data
    end
end
