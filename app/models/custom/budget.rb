require_dependency Rails.root.join('app', 'models', 'budget').to_s

class Budget < ActiveRecord::Base

  def investments_orders
    case phase
      when 'accepting', 'reviewing'
        %w{random most_commented created_at}
      when 'balloting', 'reviewing_ballots'
        %w{random most_commented created_at price}
      else
        %w{random confidence_score most_commented}
    end
  end

  def formatted_amount(amount)
    ActionController::Base.helpers.number_to_currency(amount,
                                                      precision: 0,
                                                      locale: I18n.default_locale,
                                                      unit: currency_symbol,
                                                      format: "%u %n")
  end

end

