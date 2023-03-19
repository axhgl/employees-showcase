class EmployeeDeletionNotificationEmailJob
  include Sidekiq::Job

  sidekiq_options queue: 'email', retry: 3, timeout: 60,
                  lock: :until_executed, on_conflict: :reject

  def perform(email, full_name)
    EmployeeMailer.with(email: email).data_deletion_email.deliver_now
  end
end
