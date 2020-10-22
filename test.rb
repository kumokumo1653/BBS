require 'time'

#符号なし32bitの最大値+1
a = Time.at(2147483648,in:"+00:00")
puts a.strftime("%Y-%m-%d %H:%M;%S")
#10進数15桁の最大値
a = Time.at(999999999999999,in:"+00:00")
puts a.strftime("%Y-%m-%d %H:%M;%S")
