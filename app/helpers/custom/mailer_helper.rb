require_dependency Rails.root.join('app', 'helpers', 'mailer_helper').to_s

module Custom::MailerHelper
    def darkness
        'Hello darkness my old friend'
    end
  end