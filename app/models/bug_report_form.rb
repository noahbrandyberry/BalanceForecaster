class BugReportForm < MailForm::Base
  attribute :first_name, :validate => true
  attribute :last_name, :validate => true
  attributes :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attributes :description, :validate => true
  attributes :page,  :validate => ["Login", "Sign Up", "Reset Password", "Contact", "Accounts", "Transactions", "Forecast"]
  attributes :screenshot, :attachment => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :to => "support@balanceforecaster.com",
      :subject => "Bug Report",
      :from => %("#{first_name} #{last_name}" <#{email}>),
      :reply_to => %("#{first_name} #{last_name}" <#{email}>)
    }
  end
end
