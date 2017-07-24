require_dependency Rails.root.join('app', 'helpers', 'mailer_helper').to_s

module Custom::MailerHelper
    def mail_link_style
      return "font-family: Arial, sans-serif; text-align: left; color: #EB186A; font-size: 13px; text-decoration: underline;"
    end
  end
