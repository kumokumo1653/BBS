require 'sinatra'
require './database/msg/'
set :environment, :production

NAME_MAX = 15
ID_MAX = 4
TEXT_MAX = 100
PAGE_MAX = 5
$msg = Msg.new

#投稿件数から最大ページを求める
def maxPage(len)
    return ((len + PAGE_MAX - 1) / PAGE_MAX)
end

#前ページ
def pagePrev(page)
    if page - 1 < 1
        return page
    end
    return page - 1
end

#後ページ
def pageNext(page)
    if page + 1 > maxPage($msg.msg.length)
        return page
    end
    return page + 1
end

get '/' do
    redirect '/1'
end

get '/:page' do
    @comments = $msg.msg 
    #数字かどうか
    if (params[:page] =~ /^[0-9]+$/) == 0
        @page = params[:page].to_i
    else
        erb :error
        return
    end

    #ページの範囲内か
    @minpage = 1
    @maxpage = maxPage(@comments.length)
    puts @maxpage
    if @page >= @minpage.to_i && @page <= @maxpage.to_i 
        @begin = (@page - 1) * PAGE_MAX
        if @page == @maxpage.to_i
            @end = @comments.length
        else
            @end = @page * PAGE_MAX 
        end
        erb :page
    else
        erb :error
        puts "error"
    end
end

post '/add' do
    name = params[:name]
    text = params[:text]

    if name.length >= NAME_MAX
        erb :error
        puts "error"
    end 

    if text.length >= TEXT_MAX
        erb :error
        puts "error"
    end 

    $msg.add(name, text)

    redirect "/#{maxPage($msg.msg.length)}"
end

post '/del' do
    id = params[:id]

    if $msg.del(id.to_s.rjust(ID_MAX,"0")) == "error"
        erb :error
        puts "error"
    end
    redirect '/'
end
