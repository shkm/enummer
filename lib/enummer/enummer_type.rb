# frozen_string_literal: true

require 'active_record/type'

module Enummer
  class EnummerType < ::ActiveRecord::Type::Value
    # @param [Array<Symbol>] values hash with bit-value pairs for all possible values for this type
    def initialize(values:)
      @values = values
    end

    # @return Symbol Representation of this type
    # @example
    #   :enummer[read|write|execute]
    def type
      :"enummer[#{@values.keys.join('|')}]"
    end

    # @param [Symbol|Array<Symbol>] value Current value represented as one or more symbols
    # @return Numeric Numeric representation of values
    def serialize(value)
      return unless value

      Array.wrap(value).sum { |value_name| @values.fetch(value_name, 0) }
    end

    # @param [Numeric] value Numeric representation of values
    # @return [Array<Symbol>] Current value represented as symbols
    def deserialize(value)
      return [] unless value
      return [] if value.to_i.zero?

      @values.each_with_object([]) do |(pair_name, pair_value), value_names|
        next if (value & pair_value).zero?

        value_names << pair_name
      end
    end

    # @param [Array<Symbol>] value Current value represented as one or more symbols or strings
    # @return [Array<Symbol>] Current value represented as symbols
    def cast(value)
      Array.wrap(value).map(&:to_sym)
    end
  end
end
