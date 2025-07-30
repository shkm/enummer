# Enummer

[![Gem](https://img.shields.io/gem/v/enummer?color=%2330336b)](https://rubygems.org/gems/enummer)
[![Codecov](https://img.shields.io/codecov/c/github/shkm/enummer/main)](https://app.codecov.io/gh/shkm/enummer)
[![Licence](https://img.shields.io/github/license/shkm/enummer?color=%2395afc0)](https://github.com/shkm/enummer/blob/main/MIT-LICENSE)
[![Documentation](https://img.shields.io/badge/yard-docs-%23686de0)](https://www.rubydoc.info/github/shkm/enummer/main)

Enummer is a lightweight answer for adding enums with multiple values to Rails, with a similar syntax to Rails' built-in `enum`.

Enummer officially supports Ruby versions 2.7, 3.0 and 3.1 with SQLite, PostgreSQL, and MariaDB.

## Installation

Add `gem "enummer"` to your Gemfile and `bundle`.

## Usage

### Setup

Create a migration for an integer that looks something like this:

```ruby
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :permissions, default: 0, null: false
    end
  end
end
```

Now set up enummer with the available values in your model:

```ruby
enummer permissions: %i[read write execute]
```

Similar to `enum`, enummer can also be initialized with a hash, where the numeric index represents the position of the bit that maps to the flag:

```ruby
enummer permissions: {
  read: 0,
  write: 1,
  execute: 2
}
```

This makes it easier to add/remove entries without worrying about migrating historical data.

### Scopes

Scopes will now be provided for `<option>` and `not_<option>`.

```ruby
User.read
User.not_read
User.write
User.not_write
User.execute
User.not_execute
```

Additionally, a `with_<name>` scope will be generated which returns all records that match all given options. E.g.:

```ruby
user1 = User.create!(permissions: %i[read write execute])
user2 = User.create!(permissions: %i[read write])
user3 = User.create!(permissions: %i[read])

# .where(permissions: ...) will generate an `IN` query, returning all records that have *any*
# of those permissions.
User.where(permissions: %i[read write]) # => [user1, user2, user3]

# .with_permissions will return only users that have at least all of the given set of permissions
User.with_permissions(%i[read write]) # => [user1, user2]
```

### Getter methods

Simply calling the instance method for the column will return an array of options. Question mark methods are also provided.

```ruby
user = User.last

user.permissions # => [:read, :write]

user.read? # => true
user.write? # => true
user.execute? # => false
```

### Setter methods

Options can be set with an array of symbols or via bang methods. Bang methods will additionally persist the changes.

```ruby
user.update(permissions: %i[read write])
user.write!
```

## FAQ

### Which data type should I use?

That depends on how many options you expect to store. [In PostgreSQL](https://www.postgresql.org/docs/9.1/datatype-numeric.html) you should be able to store `bytes * 8 - 1` of your data type:

| Type     | Bytes | Values      |
| -------- | ----- | ----------- |
| smallint | 2     | 15          |
| integer  | 4     | 31          |
| bigint   | 8     | 65          |
| numeric  | ???   | all of them |

### How can I use it outside of Rails?

lol stop

## Contributing

Make an issue / PR and we'll see.

### Development

```bash
$ cd enummer
$ bundle config set without 'postgres mysql'
$ bundle install
$ cd test/dummy
$ RAILS_ENV=test DATABASE_URL=sqlite3:dummy_test bundle exec rails db:setup
$ cd ../..
$ RAILS_ENV=test DATABASE_URL=sqlite3:dummy_test bundle exec bin/test
```

## Alternatives

- [flag_shih_tzu](https://github.com/pboling/flag_shih_tzu)
- Lots of booleans
- DB Arrays

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
