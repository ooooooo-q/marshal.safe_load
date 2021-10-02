module Marshal

  def self.safe_load(str, permitted_classes: [])
    permitted_classes = permitted_classes + [String, Hash, FalseClass, TrueClass, Symbol, Numeric, NilClass, Array]

    f = proc { |obj|
      unless permitted_classes.any? {|c| obj.is_a?(c) }
        raise ::TypeError, "unexepected type #{obj.class}" 
      end
      obj
    }

    self.load(str, f)
  end

end
