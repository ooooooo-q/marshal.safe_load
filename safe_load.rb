module Marshal

  def self.safe_load(str, allowClass = nil)
    allowclass ||= [String, Hash, FalseClass, TrueClass, Symbol, Numeric, NilClass, Array]

    f = proc { |obj|
      unless allowclass.any? {|c| obj.is_a?(c) }
        raise ::TypeError, "unexepected type #{obj.class}" 
      end
      obj
    }

    self.load(str, f)
  end

end
