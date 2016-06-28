require 'csv'
# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@contacts_count = 1
  @@contacts = []

  CSV_FILE_NAME = 'contacts.csv'

  attr_reader :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    @name = name.strip
    @email = email.strip
    @id = @@contacts_count
    @@contacts_count += 1
  end

  # Returns a formatted String of the contact's name and email
  def to_s
    "#{self.id}:\t#{self.name}\t(#{self.email})"
  end

  # Returns true if the contact's name and/or email matches search_term, false otherwise
  # @param term [String] The search term used to match the contact
  def matches?(term)
    term = /#{Regexp.escape(term)}/i
    !((term =~ self.name).nil? && (term =~ self.email).nil?)
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      return unless File.file?(CSV_FILE_NAME)
      @@contacts = CSV.read(CSV_FILE_NAME)
      @@contacts.map! { |contact| Contact.new(contact[1], contact[2]) }
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      contact = Contact.new(name, email)
      @@contacts << contact
      update_csv_file
      contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
     @@contacts.detect { |contact| contact.id == id }
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      @@contacts.select { |contact| contact.matches?(term) }
    end

    # Update the contacts.csv file
    def update_csv_file
      csv_file = CSV.open(CSV_FILE_NAME, "w")
      @@contacts.each { |contact| csv_file << [contact.id, contact.name, contact.email] }
      csv_file.close
    end

  end

end