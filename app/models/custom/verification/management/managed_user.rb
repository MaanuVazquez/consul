require_dependency Rails.root.join('app', 'models', 'verification/management/managed_user').to_s

class Verification::Management::ManagedUser
  include ActiveModel::Model

  def self.find_user_by_email(email)
    User.find_or_initialize_by(email:   email)
  end

end