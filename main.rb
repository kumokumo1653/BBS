require 'sinatra'
require './database/msg/'
set :environment, :production

NAME_MAX = 15
ID_MAX = 4
TEXT_MAX = 100
$msg = Msg.new
get '/' do
    @comments = $msg.msg 
    @begin = 0
    @end = @comments.length
    erb :index
end

post '/add' do
    name = params[:name]
    text = params[:text]

    if name.length >= NAME_MAX
        puts "error"
    end 

    if text.length >= TEXT_MAX
        puts "error"
    end 

    $msg.add(name, text)

    redirect '/'
end

post '/del' do
    id = params[:id]

    if $msg.del(id.to_s.rjust(ID_MAX,"0")) == "error"
        puts "error"
    end
    redirect '/'
end
