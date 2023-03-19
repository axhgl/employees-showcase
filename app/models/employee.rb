class Employee < ApplicationRecord
  belongs_to :company, counter_cache: true

  has_one :employee_bank_information, dependent: :destroy
  has_one :employee_address, dependent: :destroy

  enum gender: { male: "male", female: "female" }

  validates :first_name, :last_name, :full_name,
            :email, :age, :height, :job_title,
            presence: true
  validates :email, uniqueness: true

  before_validation :generate_full_name

  after_destroy_commit -> { broadcast_remove_to "employees" }

  accepts_nested_attributes_for :employee_address, :employee_bank_information

  paginates_per 10

  after_destroy_commit :schedule_deletion_notification_email

  scope :by_full_name, ->(page) do
    order(:full_name).
    includes(:company).
    page(page)
  end

  scope :by_full_name_or_email_search, -> (term, page) do
    where("full_name ILIKE ? OR email ILIKE ?", "%#{term}%", "%#{term}%").
    includes(:company).
    page(page)
  end

  def self.by_gender_filter(term, page)
    if term == "male"
      male
    elsif term == "female"
      female
    end.includes(:company).page(page)
  end

  def self.by_age_filter(term, page)
    if term == "over"
      where('age >= 50')
    elsif term == "under"
      where('age < 50')
    end.order(age: :desc).includes(:company).page(page)
  end

  private

  def generate_full_name
    self.full_name = "#{first_name} #{last_name}".strip
  end

  def schedule_deletion_notification_email
    EmployeeDeletionNotificationEmailJob.perform_in(30.minutes, email, full_name)
  end
end
