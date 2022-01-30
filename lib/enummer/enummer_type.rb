# frozen_string_literal: true

require "active_record/type"

module Enummer
  class EnummerType < ::ActiveRecord::Type::Value
    attr_reader :bit_pairs

    def initialize(value_names:, limit:)
      @value_names = value_names
      @bit_pairs = determine_bit_pairs(value_names)
      @limit = limit
    end

    def type
      "enummer[#{@value_names.join("|")}]".to_sym
    end

    def serialize(value)
      return unless value

      int = Array.wrap(value).sum { |value_name| @bit_pairs.fetch(value_name, 0) }

      int.to_s(2).rjust(@limit, "0")
    end

    def deserialize(value)
      return [] unless value

      value = value.to_i(2)
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
