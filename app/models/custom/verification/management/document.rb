require_dependency Rails.root.join('app', 'models', 'verification/management/document').to_s

class Verification::Management::Document

  attr_accessor :email

  clear_validators!
  validates :document_type, presence: true, if: :document_type_required?
  validates :document_number, presence: true, if: :document_number_required?
  validates :email, presence: true

  attr_accessor :skip_document_type_validation
  attr_accessor :skip_document_number_validation

  delegate :username, to: :user, allow_nil: true

  def user
    if !self.document_type_required? && !self.document_number_required?
      @user = User.active.by_email(email).first
    else
      @user = User.active.by_document(document_type, document_number).first
    end
  end

  def verified?
    user?
  end

  def verify
    user.update(verified_at: Time.current) if user?
  end

  def document_type_required?
    return false if skip_document_type_validation
  end

  def document_number_required?
    return false if skip_document_number_validation
  end

end
