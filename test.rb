require 'time'

a = Time.at(2147483648,in:"+00:00")
puts a.strftime("%Y-%m-%d %H:%M;%S")
