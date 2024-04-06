# frozen_string_literal: true

module Enummer
  module Extension
    # @param [Hash] values The attribute name to options mapping for an multi-option enum
    # @option values [Boolean|String] :_prefix The prefix to give to generated methods. If true, uses the attribute name.
    # @option values [Boolean|String] :_suffix The suffix to give to generated methods. If true, uses the attribute name.
    # @example Defining an enummer with a prefix. This would generate `#can_read?`, `#can_read=`, `#can_read!`, `.can_read`, etc.
    #   enummer permissions: %i[read write execute], :_prefix: 'can'
    def enummer(values)
      options = {}
      options[:_prefix] = values.delete(:_prefix)
      options[:_suffix] = values.delete(:_suffix)

      name, values = values.first

      attribute(name, :enummer, value_names: values)

      singleton_class.__send__(:define_method, name) { values }

      _enummer_build_with_scope(name, values)
      _enummer_build_values(name, values, options)
    end

    private

    def _enummer_build_with_scope(attribute_name, value_names)
      scope "with_#{attribute_name}", lambda { |desired|
        expected = Array.wrap(desired).sum(0) { |value| 1 << value_names.index(value) }

        where("#{attribute_name} & :expected = :expected", expected: expected)
      }
    end

    def _enummer_build_values(attribute_name, value_names, options)
      value_names.each_with_index do |name, i|
        method_name = _enummer_method_name(attribute_name, name, options)

        define_method("#{method_name}?") { self[attribute_name].include?(name) }
        define_method("#{method_name}=") do |new_value|
          if new_value
            self[attribute_name] += [name]
          else
            self[attribute_name] -= [name]
          end
          self[attribute_name].uniq!
        end
        define_method("#{method_name}!") do
          update(attribute_name => self[attribute_name] + [name])
        end

        bit = 1 << i

        scope method_name, -> { where("#{attribute_name} & :bit = :bit", bit: bit) }
        scope "not_#{method_name}", -> { where("#{attribute_name} & :bit != :bit", bit: bit) }
      end
    end

    def _enummer_method_name(attribute_name, value_name, options)
      prefix = _enummer_affix(attribute_name, options[:_prefix])
      suffix = _enummer_affix(attribute_name, options[:_suffix])

      [prefix, value_name, suffix].compact.join("_")
    end

    def _enummer_affix(attribute_name, value)
      return unless value
      return attribute_name if value == true

      value
    end
  end
end
