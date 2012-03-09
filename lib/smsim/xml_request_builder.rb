require 'builder'

module Smsim
  class XmlRequestBuilder

    def self.build_send_sms(message_text, phones, options = {})
      raise ArgumentError.new("Text must be at least 1 character long") if message_text.blank?
      raise ArgumentError.new("Phones must include at least one phone") if phones.blank?
      raise ArgumentError.new("Username and password must be present in options") if options[:username].blank? || options[:password].blank?
      phones = phones.to_a unless phones.is_a?(Array)
      raise ArgumentError.new("Max phones number is 100") if phones.count > 100

      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!
      xml.Inforu do |root|
        root.User do |user|
          user.Username options[:username]
          user.Password options[:password]
        end
        root.Content(:Type => 'sms') do |content|
          content.Message message_text
        end
        root.Recipients do |recipients|
          recipients.PhoneNumber phones.join(';')
        end
        root.Settings do |settings|
          settings.SenderNumber options[:reply_to_number]
        end
      end
    end

  end
end

