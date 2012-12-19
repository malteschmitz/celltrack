# BitVector can be used to create a binary string from single bits. You can
# create a new instance and append new bits (0 or 1) using << operator.
# BitVector has no support to edit the created binary data and is optimized
# only for performance. 

class BitVector
  def initialize
    @data = []
    @base = 128
    @last = 0
  end
  
  def <<(bit)
    @last += bit * @base
    @base >>= 1
    add_last if @base == 0
  end
  
  def to_binary
    add_last if @base > 0
    @data.pack('C*')
  end
  
  private
  
  def add_last
    @base = 128
    @data << @last
    @last = 0
  end
end