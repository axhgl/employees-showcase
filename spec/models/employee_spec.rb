require 'rails_helper'

RSpec.describe Employee do
  context "validations" do
    let!(:employee) { create(:employee) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:height) }
    it { should validate_presence_of(:job_title) }
    it { should validate_uniqueness_of(:email) }

    describe "#generate_full_name" do
      it "joins together the first and last name values" do
        employee = create(:employee, first_name: "John", last_name: "Doe ")
        expect(employee.full_name).to eq("John Doe")
      end
    end
  end

  context "scopes" do
    describe ".by_full_name" do
      it "orders the employees in an alphabetical order" do
        john = create(:employee, first_name: "John", last_name: "Doe")
        alice = create(:employee, first_name: "Alice", last_name: "Smith")
        bob = create(:employee, first_name: "Bob", last_name: "Johnson")

        ordered_users = Employee.by_full_name(1)

        expect(ordered_users.first).to eq(alice)
        expect(ordered_users.second).to eq(bob)
        expect(ordered_users.third).to eq(john)
      end
    end

    describe ".by_full_name_or_email_search" do
      it "returns employee that match the search term by full name or email" do
        john = create(:employee, first_name: "John", last_name: "Doe", email: "emp_1@example.com")
        alice = create(:employee, first_name: "Alice", last_name: "Smith", email: "emp_2@example.com")
        bob = create(:employee, first_name: "Bob", last_name: "Johnson", email: "emp_3@example.com")
        
        expect(Employee.by_full_name_or_email_search("Alice", 1)).to match_array([alice])
        expect(Employee.by_full_name_or_email_search("john", 1)).to match_array([john, bob])
        expect(Employee.by_full_name_or_email_search("example.com", 1)).to match_array([alice, john, bob])
      end
    end

    describe ".by_gender_filter" do
      it "returns employees that match the gender" do
        male = create(:employee, gender: "male")
        female = create(:employee, gender: "female")
        female_2 = create(:employee, gender: "female")

        expect(Employee.by_gender_filter("male", 1)).to eq([male])
        expect(Employee.by_gender_filter("female", 1)).to eq([female, female_2])
      end
    end

    describe ".by_age_filter" do
      let!(:older_emp) { create(:employee, age: 55) }
      let!(:older_emp_2) { create(:employee, age: 50) }
      let!(:younger_emp) { create(:employee, age: 40) }
      let!(:younger_emp_2)  { create(:employee, age: 22) }

      it "returns employees that are older than 50, in descending order" do
        expect(Employee.by_age_filter("over", 1)).to eq([older_emp, older_emp_2])
      end

      it "returns employees that are younger than 50, in descending order" do
        expect(Employee.by_age_filter("under", 1)).to eq([younger_emp, younger_emp_2])
      end
    end
  end

  context "callbacks" do
    describe "#after_destroy_commit" do
      it "enqueues a job to send the deletion notification email" do
        employee = create(:employee, first_name: "John", last_name: "Doe", email: "john@example.com")

        expect(EmployeeDeletionNotificationEmailJob).to receive(:perform_in).
          with(30.minutes, "john@example.com", "John Doe")

        employee.destroy

      end
    end
  end
end
