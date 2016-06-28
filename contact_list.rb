require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # Runs the Contact List application
  def self.run
    contacts = Contact.all
    show_options if ARGV.length == 0
    case ARGV[0]
    when "list"
      puts contacts
    when "new"
      puts "Enter the new contact's name: "
      name = STDIN.gets.chomp
      puts "Enter the new contact's email: "
      email = STDIN.gets.chomp
      contact = Contact.create(name, email)
      puts "Added #{contact.name} with ID #{contact.id} successfully!"
    when "show"
      return if ARGV[1].nil?
      contact = Contact.find(ARGV[1].to_i)
      puts (contact.nil?) ? "Contact with ID #{ARGV[1]} does not exist." : contact_details(contact)
    when "search"
      return if ARGV[1].nil?
      found_contacts = Contact.search(ARGV[1])
      puts (found_contacts.empty?) ? "Did not find any contacts that matched #{ARGV[1]}" : found_contacts
    end 
  end

  # Show the options for the Contact List app
  def self.show_options
    puts ("*" * 10) + "  COMMANDS  " + ("*" * 10)
    puts "new     - Create a new contact"
    puts "list    - List all contacts"
    puts "show    - Show a contact"
    puts "search  - Search for a contact"
    puts "*" * 32
  end

  # Returns a String with the contact's name and email on separate lines
  def self.contact_details(contact)
    "#{contact.name}\n#{contact.email}"
  end

end

ContactList.run