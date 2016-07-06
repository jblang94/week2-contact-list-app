require 'csv'
require_relative 'base'
# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  DATABASE_TABLE_NAME = 'contacts'

  attr_accessor :name, :email, :id

  def initialize(contact_details)
    @name = contact_details['name']
    @email = contact_details['email']
    @id = contact_details['id']
  end

  # Returns a formatted String of the contact's name and email
  def to_s
    "#{self.id}:\t#{self.name}\t(#{self.email})"
  end

  # Saves a new contact or updates an existing contact
  def save
    if contact_in_database?
      Base.connection.exec_params("UPDATE #{DATABASE_TABLE_NAME}
      SET name = $1, email = $2 WHERE id = $3::int;", [self.name, self.email, self.id])
    else
      contact_database_id = Base.connection.exec_params("INSERT INTO #{DATABASE_TABLE_NAME} (name, email)
      VALUES ($1, $2) RETURNING id;", [self.name, self.email])
      self.id = contact_database_id[0]['id']
    end
  end

  # Removes a contact from the database
  def destroy
    return false if !contact_in_database?
    Base.connection.exec_params("DELETE FROM #{DATABASE_TABLE_NAME} WHERE id = $1::int", [self.id])
    true
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Connects to the database and retrieves all records from the contacts table
    # @return [Array<Contact>] Array of Contact objects
    def all
      contact_records = Base.connection.exec("SELECT * FROM #{DATABASE_TABLE_NAME} ORDER BY id;")
      contact_records.map { |contact_record| Contact.new(contact_record) }
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    # @return Contact the newly created contact
    def create(name, email)
      contact = Contact.new({'name' => name, 'email' => email})
      contact.save
      contact
    end

    # Find the Contact with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If the contact is not found, returns nil.
    def find(id)
      contact_record = Base.connection.exec_params("SELECT * FROM #{DATABASE_TABLE_NAME} WHERE id = $1;", [id])
      return nil if empty_query_result?(contact_record)
      Contact.new(contact_record[0])
    end

    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      contact_records = Base.connection.exec("SELECT * FROM #{DATABASE_TABLE_NAME} WHERE name LIKE '%#{term}%';")
      return [] if empty_query_result?(contact_records)
      contact_records.map { |contact_record| Contact.new(contact_record) }
    end

    def empty_query_result?(query_result)
      query_result.num_tuples == 0
    end

    def contact_not_found?(contact)
      contact.nil?
    end

  end

  private

  def contact_in_database?
    self.id != nil
  end

end
