require 'active_record'
require 'time'

ActiveRecord::Base.configurations = YAML.load_file('./database/database.yml')
ActiveRecord::Base.establish_connection :development

class Board < ActiveRecord::Base
end

class Msg
    def initialize
        @data = Board.all
        @id = 1
        @id = init
    end

    def init
        @data = Board.all
        @data = @data.sort do |a, b|
            a.id.to_i <=> b.id.to_i
        end
        @id = 1
        for i in @data do
            if i.id.to_i == @id
                @id += 1
            else 
                break
            end
        end
        return @id
    end

    def add(username, message)

        puts "username = #{username}"
        puts "message = #{message}"
        puts TEXT_MAX
        if username.length == 0
            username = "ななし"
        end
        if message.length > TEXT_MAX
            return
        end
        
        if @id >= 10**ID_MAX
            data = Board.all.sort do |a, b|
                a.date.to_i <=> b.date.to_i
            end
            @id = data[0].id.to_i
            data[0].destroy
        end
        

        s = Board.new
        s.id = @id.to_s.rjust(ID_MAX,"0")
        s.name = username
        s.date = Time.now.to_i
        s.message = message
        s.save

        #new id
        @id = init


    end
    
    def del(id)
        begin 
            s = Board.find(id)
            s.destroy
        rescue
            return "error"
        end

        @id = init
    end

    def p 
        pp Board.all
    end
    
    def msg
        return Board.all
    end

    def clear
        Board.where(id:1..Board.all.length).destroy_all
    end
end
