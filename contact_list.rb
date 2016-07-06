#!/usr/bin/env ruby
require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # Runs the Contact List application
  def self.run
    show_options if ARGV.length == 0
    case ARGV[0]
    when "list"
      puts Contact.all
    when "new"
      contact = create_contact
      puts success_msg("Created", contact.id.to_i, contact)
    when "show"
      return if ARGV[1].nil?
      id = ARGV[1].to_i
      contact = Contact.find(id)
      puts (contact.nil?) ? contact_not_found_msg(id) : success_msg("Found", id, contact)
    when "search"
      return if ARGV[1].nil?
      search_term = ARGV[1]
      found_contacts = Contact.search(search_term)
      puts (found_contacts.empty?) ? "Did not find any contacts that matched #{search_term}" : found_contacts
    when "update"
      return if ARGV[1].nil?
      id = ARGV[1].to_i
      contact = update_contact(id)
      puts (contact.nil?) ? contact_not_found_msg(id) : success_msg("Updated", id, contact)
    when "destroy"
      return if ARGV[1].nil?
      id = ARGV[1].to_i
      contact = destroy_contact(id)
      puts (contact.nil?) ? contact_not_found_msg(id) : success_msg("Deleted", id, contact)
    else
      puts "Please enter a valid command\n\n"
      show_options
    end
  end

  # Show the options for the Contact List app
  def self.show_options
    puts ("*" * 10) + "  COMMANDS  " + ("*" * 10)
    puts "new                     - Create a new contact"
    puts "list                    - List all contacts"
    puts "show    [id]            - Show a contact"
    puts "search  [search_term]   - Search for a contact"
    puts "update  [id]            - Update a contact"
    puts "delete  [id]            - Delete a contact"
    puts "*" * 32
  end

  # Returns a String with the contact's name and email on separate lines
  # @param contact [Contact] The contact who's name and email is being formatted
  def self.contact_details(contact)
    "NAME: #{contact.name}\nEMAIL: #{contact.email}"
  end

  def self.create_contact
    puts "Enter the new contact's name: "
    name = STDIN.gets.chomp
    puts "Enter the new contact's email: "
    email = STDIN.gets.chomp
    Contact.create(name,email)
  end

  def self.update_contact(id)
    contact = Contact.find(id)
    unless contact.nil?
      puts "Enter #{contact.name}'s new name: "
      contact.name = STDIN.gets.chomp
      puts "Enter #{contact.name}'s new email: "
      contact.email = STDIN.gets.chomp
      contact.save
      contact
    end
  end

  def self.destroy_contact(id)
    contact = Contact.find(id)
    contact if !contact.nil? && contact.destroy
  end

  def self.contact_not_found_msg(id)
    "Did not find the contact with ID #{id}"
  end

  def self.success_msg(action, id, contact)
    "#{action} Contact ID #{id}\n#{contact_details(contact)}"
  end

end

ContactList.run
