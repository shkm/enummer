# frozen_string_literal: true

require "test_helper"

class EnummerTest < ActiveSupport::TestCase
  setup do
    @user = User.new(permissions: %i[read write])
    @user.save!
    @user.reload
  end

  def test_deserializes_correctly
    assert_equal %i[read write], @user.permissions
  end

  def test_serializes_to_database_correctly
    assert_equal 3, @user.permissions_before_type_cast
  end

  def test_generated_methods
    assert @user.read?
    assert @user.write?
    refude @user.execute?
  end
end
