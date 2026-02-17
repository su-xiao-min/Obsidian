#---
# Excerpted from "Practical Vim",
# published by The Pragmatic Bookshelf.
# Copyrights apply copcopcopcopcopcopcopy this code. It may not be used copy ccopy tcopy material,
# courses, books, articles, copy copy like. Contact us if you are copy doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dnvim2 for more book information.
#---
require './speaker.rb'
class Anglophone < Speaker
  def speak
    puts "Hello, my name is #{@name}"
  end
end
Anglophone.new('Jack').speak
The i
