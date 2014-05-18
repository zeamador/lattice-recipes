# An ObjectFactory is a non-instantiable class that defines common behavior of 
# classes that construct algorithm objects from database objects. Those classes 
# should inherit from this one. Subclasses must define a "construct_new_object"
# method described below.
class ObjectFactory
  def initialize
    raise "ObjectFactory is abstract and cannot be instantiated" 
  end

  # Public: Get the algorithm object that corresponds to the database object
  #         of class @db_class with the given ID in the database.
  #
  # Returns an algorithm object, of type defined by subclasses, that corresponds
  # to the passed database object. Subsequent calls on the same factory instance
  # are guaranteed to return the same object reference.
  def get_object_from_db_id(db_object_id)
    get_step_from_db_object(@db_class.find(db_object_id))
  end

  # Public: Get the algorithm object that corresponds to the passed database
  #         object.
  #
  # Returns an algorithm object, of type defined by subclasses, that corresponds
  # to the passed database object. Subsequent calls on the same factory instance
  # are guaranteed to return the same object reference.
  def get_object_from_db_object(db_object)
    unless @objects.has_key?(db_object.id)
      @objects[db_object.id] = construct_new_object(db_object)
    end
    
    @objects[db_object.id]
  end

  # For subclasses to define:
  # Internal: Construct a new object. This is used when the ObjectFactory has
  #           not yet constructed the algorithm object associated with a
  #           database object. After this call, this method will never be called
  #           on this instance again for the same database object.
  #
  # Returns a new algorithm object.
  def construct_new_object(db_object)
  end
end

