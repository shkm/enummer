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
      values = _enummer_determine_bit_pairs(values)

      attribute(name, :enummer, values: values)

      singleton_class.__send__(:define_method, name) { values.keys }

      _enummer_build_with_scope(name, values)
      _enummer_build_values(name, values, options)
    end

    private

    def _enummer_build_with_scope(attribute_name, values)
      scope "with_#{attribute_name}", lambda { |desired|
        expected = Array.wrap(desired).sum(0) { |value| values[value.to_sym] }

        where("#{attribute_name} & :expected = :expected", expected: expected)
      }
    end

    def _enummer_build_values(attribute_name, values, options)
      values.each do |name, bit|
        method_name = _enummer_method_name(attribute_name, name, options)

        define_method(:"#{method_name}?") { self[attribute_name].include?(name) }
        define_method(:"#{method_name}=") do |new_value|
          if ActiveModel::Type::Boolean.new.cast(new_value)
            self[attribute_name] += [name]
          else
            self[attribute_name] -= [name]
          end
          self[attribute_name].uniq!
        end
        define_method(:"#{method_name}!") do
          update(attribute_name => self[attribute_name] + [name])
        end

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

    def _enummer_determine_bit_pairs(values)
      values = values.map.with_index { |value, i| [value, i] }.to_h if values.is_a?(Array)
      values.transform_values do |shift|
        1 << shift
      end
    end
  end
end
