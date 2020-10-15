require 'digest/md5'
require 'active_record'
require 'time'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection :development

class Account < ActiveRecord::Base
end

trial_username = "nobunaga"
trial_passwd = "achichi-achichi"

#探す
#try-catch
begin
    a = Account.find(trial_username)
    db_username = a.id
    db_salt = a.salt
    db_hashed = a.hashed
    db_algo = a.algo
    db_date = a.date
rescue => e
    puts "user #{trial_username} is not found."
    exit(-1)
end

#ハッシュアルゴリズムが1であれば
if db_algo == "1"
    trial_hashed = Digest::MD5.hexdigest(db_salt + trial_passwd)
else 
    puts "Unkown algorithm is used for user #{trial_username}."
    exit(-2)
end

#表示
puts "---DB---"
puts "username = #{db_username}"
puts "salt = #{db_salt}"
puts "algorithm = #{db_algo}"
puts "hashed passwd = #{db_hashed}"
puts ""
puts "---TRIAL---"
puts "username = #{trial_username}"
puts "passwd = #{trial_passwd}"
puts "hashed passwd = #{trial_hashed}"
puts ""

#Success?
if db_hashed == trial_hashed
    puts "login success"
    a = Account.find(trial_username)
    if a.date.to_i == -1
        puts "first login"
    else
        puts "last:#{Time.at(a.date.to_i).strftime("%Y年 %m月 %d日 %H時 %M分 %S秒")}"
    end
    a.date = Time.now.to_i
    a.save
    
else 
    puts "login failed"
end
