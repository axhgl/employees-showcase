class EmployeeMailer < ApplicationMailer
  def data_deletion_email
    @email = params[:email]
    @full_name = params[:full_name]

    mail(to: @email, subject: "Data deletion confirmation!")
  end
end
