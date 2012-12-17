require 'benchmark'

n = 500000
Benchmark.bm do |x|
  x.report do
    10.times do
      a = []
      n.times do
        a << 34
      end
      a.pack('C*')
      # use a.unpack('C*')[i] to extract data
    end
  end    
  x.report do
    10.times do
      s = ""
      0.upto(n-1) do |i|
        s << 34.chr
      end
      #use s[i].ord to extract data
    end
  end
end