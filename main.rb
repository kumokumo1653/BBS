    require 'sinatra'
    require './database/msg/'
    require 'cgi/escape'
    set :environment, :production

    NAME_MAX = 15
    ID_MAX = 4
    TEXT_MAX = 500
    PAGE_MAX = 5
    $msg = Msg.new

    #数字かどうか
    def isNumber(id)
        return id =~ /^[0-9]+$/
    end
    #空文字かどうか
    def isEmpty(text)
        return text =~ /\A(\s)*\z/ 
    end
    #投稿件数から最大ページを求める
    def maxPage(len)
        if len == 0
            return 1
        else
            return ((len + PAGE_MAX - 1) / PAGE_MAX)
        end
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

    def dispName(name)
        return CGI.escapeHTML(name)
    end
    def dispText(text)
        text = CGI.escapeHTML(text)

        #改行の置換
        text = text.gsub(/(\r\n|\n|\r)/, '<br>')

        #fontタグを許可
        text = text.gsub(/&lt;\/font&gt;/,'</font>')
        text = text.gsub(/&lt;font.*?&gt;/){$&.gsub(/&quot;/, '"').sub(/&lt;font(.*?)&gt;/,'<font \1>')}
        
        return text
    end

    get '/' do
        redirect '/bbs/1'
    end

    get '/bbs/error' do
        erb :error
    end
    get '/bbs/:page' do
        @comments = $msg.msg 
        #数字かどうか
        if isNumber(params[:page]) == 0
            @page = params[:page].to_i
        else
            puts "notnum"
            redirect '/bbs/error'
        end

        #ページの範囲内か
        @minpage = 1
        @maxpage = maxPage(@comments.length)
        if @page >= @minpage.to_i && @page <= @maxpage.to_i 
            @begin = (@page - 1) * PAGE_MAX
            if @page == @maxpage.to_i
                @end = @comments.length
            else
                @end = @page * PAGE_MAX 
            end
            erb :page
        else
            puts "outnum"
            redirect '/bbs/error'
        end
    end

    post '/bbs/add' do
        name = params[:name].slice(0, NAME_MAX)
        text = params[:text].slice(0, TEXT_MAX)

    #空文字判定
    if isEmpty(name) == 0
        name = ""
    end
    if isEmpty(text) == 0 
    else
        $msg.add(name, text)
    end
        redirect "/bbs/#{maxPage($msg.msg.length)}"
end

post '/bbs/del' do
    id = params[:id]
    puts id
    if isNumber(id) == 0
        if $msg.del(id.to_s.rjust(ID_MAX,"0")) == "error"
            redirect '/bbs/error'
            puts "error"
        end
        redirect '/'
    else 
        redirect "/bbs/error"
    end
end
