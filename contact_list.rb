require 'csv'
require_relative 'contact'
# Provides the Contact List Application
class ContactList

  @@contacts = []
  CSV_FILE_NAME = "contacts.csv"

  class ContactListError < StandardError
  end

  class << self
    # Show the application commands
    def show_commands
      puts ("*" * 10) + "  COMMANDS  " + ("*" * 10)
      puts "new     - Create a new contact"
      puts "list    - List all contacts"
      puts "show    - Show a contact"
      puts "search  - Search for a contact"
      puts "*" * 32
    end

    # Run the application
    def run
      retrieve_current_contacts
      show_commands if ARGV.length == 0
      case ARGV[0]
      when "list"
        list_contacts
      when "new"
        contact = create_contact
        @@contacts << contact
        update_csv_file
        puts "Added #{contact.name} with ID #{contact.id} successfully!"
      when "show"
        return if ARGV[1].nil?
        show_contact(ARGV[1].to_i)
      when "search"
        return if ARGV[1].nil?
        found_contacts = find_contacts(ARGV[1])
        puts (found_contacts.empty?) ? "Could not find contacts that matched #{ARGV[1]}" : found_contacts
      end
      rescue ContactListError => error
        puts "Error when trying to list all contacts: #{error}"
    end

    # Opens the CSV file, converts its entries into Contacts, and stores them in @@contacts
    def retrieve_current_contacts
      return unless File.file?(CSV_FILE_NAME)
      contacts = CSV.read(CSV_FILE_NAME)
      contacts.each_with_index do |contact, index|
        @@contacts << Contact.new(contact[1], contact[2])
      end
    end

    # List all contacts from the CSV file
    def list_contacts
      puts @@contacts
      puts "---"
      puts "#{@@contacts.length} records total"
    end

    # Return a new contact with the name and email provided by the user
    def create_contact
      puts "Enter the new contact's full name: "
      name = STDIN.gets.chomp
      puts "Enter the new contact's email: "
      email = STDIN.gets.chomp
      Contact.new(name,email)
    end

    # Show the details of the contact with "id"
    def show_contact(id)
      contact = find_contact_by_id(id)
      puts (contact.nil?) ? "Could not find contact with id #{id}" : contact.show_details
    end

    # Returns the contact with "id" if found, nil otherwise
    def find_contact_by_id(id)
      @@contacts.detect { |contact| contact.id == id }
    end

    # Returns all contacts that match search_term, nil otherwise
    def find_contacts(search_term)
      @@contacts.select { |contact| contact.matches?(search_term) }
    end

    # Store the contacts back into the CSV file
    def update_csv_file
      csv_file = CSV.open(CSV_FILE_NAME, "w")
      @@contacts.each { |contact| csv_file << [contact.id, contact.name, contact.email] }
      csv_file.close
    end
  end
end

ContactList.run