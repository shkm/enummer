# frozen_string_literal: true

require "test_helper"

class EnummerTest < ActiveSupport::TestCase
  def setup
    @user1 = User.new(permissions: %i[read write execute],
      facial_features: %i[nose],
      diets: %i[cigarettes alcohol],
      transport: %i[submarine],
      home: %i[box])
    @user2 = User.new(permissions: %i[read write], diets: %i[cigarettes])
    @user3 = User.new(permissions: %i[execute])

    [@user1, @user2, @user3].map { |user| user.save && user.reload }
  end

  test "it has a version number" do
    assert Enummer::VERSION
  end

  test "get list of all valid values" do
    assert_equal %i[read write execute], User.permissions
  end

  test "plain scopes return users with those values set" do
    assert_equal [@user1, @user2], User.read
    assert_equal [@user1, @user2], User.write
    assert_equal [@user1, @user3], User.execute
  end

  test "with_ scope returns users with all of those bits set" do
    assert_equal [@user1], User.with_permissions(%i[execute read write])
    assert_equal [@user1], User.with_permissions(%w[execute read write])
    assert_equal [@user1, @user2], User.with_permissions(["read", :write])
    assert_equal [@user1, @user2], User.with_diets(%i[cigarettes])
  end

  test "not scopes return users without those bits set" do
    assert_equal [@user3], User.not_read
    assert_equal [@user3], User.not_write
    assert_equal [@user2], User.not_execute
  end

  test "it serializes into a numeric" do
    assert_equal 3, @user2.permissions_before_type_cast
  end

  test "it deserializes into an array of values" do
    assert_equal %i[read write], @user2.permissions
  end

  test "it generates object query methods" do
    assert @user2.read?
    assert @user2.write?
    refute @user2.execute?
  end

  test "setting a setter to true adds the value" do
    @user3.read = true

    assert_equal %i[execute read], @user3.permissions

    @user3.save

    assert_equal %i[execute read].sort, @user3.permissions.sort
  end

  test "setting a setter to false removes the value" do
    @user1.write = false

    assert_equal %i[read execute], @user1.permissions

    @user1.save

    assert_equal %i[read execute].sort, @user1.permissions.sort
  end

  test "setting the attribute with strings adds the values" do
    @user3.update(permissions: ["read", "write"])

    assert_equal %i[read write], @user3.permissions
  end

  test "using a bang method properly updates the persisted field" do
    @user3.read!
    @user3.reload

    assert_equal %i[read execute], @user3.permissions
  end

  test "methods respect _prefix" do
    assert @user1.facial_features_nose?
    refute @user1.facial_features_mouth?
    refute @user1.facial_features_eyes?

    assert @user1.consumes_cigarettes?
    assert @user1.consumes_alcohol?
    refute @user1.consumes_greens?
  end

  test "update with prefix" do
    assert @user1.consumes_cigarettes?
    refute @user1.consumes_greens?
    @user1.update!(consumes_cigarettes: true)
    refute @user1.consumes_greens?
  end

  test "recognizes boolean params" do
    @user1.update!(ActionController::Parameters.new({"consumes_cigarettes" => "false"}).permit(:consumes_cigarettes))
    refute @user1.consumes_cigarettes?
  end

  test "methods respect _suffix" do
    refute @user1.car_transport?
    refute @user1.truck_transport?
    assert @user1.submarine_transport?

    assert @user1.box_home?
    refute @user1.apartment_home?
    refute @user1.house_home?
  end
end
