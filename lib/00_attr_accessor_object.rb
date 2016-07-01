require 'byebug'

class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |method|
      define_method(method) do
        instance_variable_get("@#{method}")
      end

      define_method("#{method}=") do |value|
        instance_variable_set("@#{method}", value)
      end
    end
  end
end
