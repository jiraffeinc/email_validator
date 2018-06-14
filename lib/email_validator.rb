require "email_validator/version"
require "active_model"
require "active_support/i18n"

I18n.load_path += Dir[File.dirname(__FILE__) + "/locale/*.yml"]

module ActiveModel
  module Validations
    class EmailValidator < ::ActiveModel::EachValidator

      EMAIL_REGEX = /\A([a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-](?!.*(\.\.))[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+[a-zA-Z0-9!#$%&'*+=\/?^_`{|}~-]|[a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+)@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+\z/

      def validate_each(record, attribute, value)
        if value.match(EMAIL_REGEX).blank?
          record.errors.add(attribute, I18n.t("errors.messages.invalid_email"))
        end
      end
    end
  end
end
