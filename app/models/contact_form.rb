class ContactForm < MailForm::Base
  attribute :first_name, :validate => true
  attribute :last_name, :validate => true
  attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message, :validate => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :to => "info@balanceforecaster.com",
      :subject => "Contact Form Submission",
      :from => %("#{first_name} #{last_name}" <#{email}>),
      :reply_to => %("#{first_name} #{last_name}" <#{email}>)
    }
  end
end