class PhoneSMSSender
  OPT_OUT_MESSAGE = 'To no longer receive text messages, text STOP'.freeze

  attr_accessor :message, :from_user_id, :to_mobile_phone, :to_user, :media_url, :twilio, :opt_out_message_sent,
                :exception

  def initialize(message, from_user_id, to_mobile_phone, media_url, force_opt_out)
    raise "The message from user #{from_user_id} failed: the message is blank." if message.blank?
    raise 'The message failed: the mobile phone number is blank.' if to_mobile_phone.blank?

    self.from_user_id = from_user_id
    self.to_mobile_phone = to_mobile_phone
    self.media_url = media_url
    self.twilio = RadicalTwilio.new
    self.message = augment_message(message, force_opt_out)
  end

  def send!
    RadicalRetry.perform_request(raise_original: true) do
      if mms?
        twilio.send_mms to: to_number, message: message, media_url: media_url
      else
        twilio.send_sms to: to_number, message: message
      end
    end

    log_event true
    true
  rescue Twilio::REST::RestError => e
    self.exception = e
    raise e.message unless blacklisted?

    log_event false
    handle_blacklist
    false
  end

  def from_number
    mms? ? twilio.from_number_mms : twilio.from_number
  end

  private

    def handle_blacklist
      # override as needed
    end

    def mms?
      media_url.present?
    end

    def augment_message(message, force_opt_out)
      if !force_opt_out && opt_out_message_already_sent?
        self.opt_out_message_sent = false
        return message
      end

      self.opt_out_message_sent = true
      return "#{message} - #{OPT_OUT_MESSAGE}" unless %w[. ! ?].include?(message[-1])

      "#{message} #{OPT_OUT_MESSAGE}."
    end

    def to_number
      RadicalTwilio.human_to_twilio_format(to_mobile_phone)
    end

    def blacklisted?
      # https://www.twilio.com/docs/api/errors/21610
      exception.message.include?('21610')
    end

    def opt_out_message_already_sent?
      TwilioLog.opt_out_message_sent?(to_number)
    end

    def log_event(success)
      TwilioLog.create! to_number: to_number,
                        from_number: from_number,
                        to_user: to_user,
                        from_user_id: from_user_id,
                        message: message,
                        media_url: media_url,
                        success: success,
                        opt_out_message_sent: opt_out_message_sent
    end
end
