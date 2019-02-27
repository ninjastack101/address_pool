class Address
  # Random characters, digits, uppercase, lowercase. Uppercase letter "O", uppercase letter "I", lowercase letter "l", and the number "0" are excluded!
  def self.generate(length = 10)
    ([*('A'..'Z'),*('0'..'9'), *('a'..'z')] - %w(O I l 0)).sample(length).join
  end
end