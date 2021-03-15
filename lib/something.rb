# frozen_string_literal: true

class Something
  attr_reader :something, :something_else

  def initialize(something = 1, something_else = 2)
    @something = something
    @something_else = something_else
  end

  def add
    something + something_else
  end
end
