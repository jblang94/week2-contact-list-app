# Represent a Contact in the ContactList
class Contact

  @@contacts_count = 1
  attr_reader :name, :email, :id

  def initialize(name, email)
    @name = name
    @email = email
    @id = @@contacts_count
    @@contacts_count+=1
  end

  # Returns a formatted String of the contact's name and email
  def to_s
    "#{self.id}:\t#{self.name}\t(#{self.email})"
  end

  # Returns a String with the contact's name and email on separate lines
  def show_details
    "#{self.name}\n#{self.email}\n"
  end

  # Returns true if the contact's name and/or email matches search_term, false otherwise
  def matches?(search_term)
    search_term = /#{search_term.downcase}/
    !(search_term =~ self.name.downcase).nil? || !(search_term =~ self.email.downcase).nil?
  end
end