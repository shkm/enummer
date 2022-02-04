# frozen_string_literal: true

require "active_record/type"

module Enummer
  class EnummerType < ::ActiveRecord::Type::Value
    # @param [Array<Symbol>] value_names list of all possible values for this type
    def initialize(value_names:)
      @value_names = value_names
      @bit_pairs = determine_bit_pairs(value_names)
    end

    # @return Symbol Representation of this type
    # @example
    #   :enummer[read|write|execute]
    def type
      "enummer[#{@value_names.join("|")}]".to_sym
    end

    # @param [Symbol|Array<Symbol>] value Current value represented as one or more symbols
    # @return Numeric Numeric representation of values
    def serialize(value)
      return unless value

      Array.wrap(value).sum { |value_name| @bit_pairs.fetch(value_name, 0) }
    end

    # @param [Numeric] value Numeric representation of values
    # @return [Array<Symbol>] Current value represented as symbols
    def deserialize(value)
      return [] unless value

      @bit_pairs.each_with_object([]) do |(pair_name, pair_value), value_names|
        next if (value & pair_value).zero?

        value_names << pair_name
      end
    end

    private

    def determine_bit_pairs(value_names)
      value_names.map.with_index do |name, shift|
        [name, 1 << shift]
      end.to_h
    end
  end
end
