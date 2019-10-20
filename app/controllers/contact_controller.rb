class ContactController < ApplicationController
  layout 'no_container'

  def contact
    @contact_form = ContactForm.new
  end

  def submit_contact
    @contact_form = ContactForm.new(contact_params)
    if @contact_form.deliver
      redirect_to contact_path, notice: 'Thank you for your message. We will contact you soon!'
    else
      flash.now[:error] = 'Cannot send message.'
      render :contact
    end
  end

  def bug_report
    @bug_report_form = BugReportForm.new
  end

  def submit_bug_report
    @bug_report_form = BugReportForm.new(bug_report_params)
    if @bug_report_form.deliver
      redirect_to bug_report_path, notice: 'Thank you for reporting this bug. We will work on fixing this ASAP!'
    else
      flash.now[:error] = 'Cannot report bug.'
      render :bug_report
    end
  end

  private

    def contact_params
      params.require(:contact_form).permit(:first_name, :last_name, :email, :message)
    end

    def bug_report_params
      params.require(:bug_report_form).permit(:first_name, :last_name, :email, :description, :page, :screenshot)
    end
  
end
