# frozen_string_literal: true

module Enummer
  class Railtie < ::Rails::Railtie
    initializer 'enummer' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Type.register(:enummer, EnummerType)
        extend Enummer::Extension
      end
    end
  end
end
