require 'rails_helper'

RSpec.feature "Employees Showcase page" do
  context "when no employees exist", :vcr do
    it "displays a redirection link" do
      visit root_path

      expect(page).to have_link("Click Here")
    end
  end

  context "employees have already been created" do
    let!(:john) { create(:employee, first_name: "John", last_name: "Doe", gender: "male", age: 50) }
    let!(:alice) { create(:employee, first_name: "Alice", last_name: "Smith", gender: "female", age: 35) }
    let!(:bob)  { create(:employee, first_name: "Bob", last_name: "Johnson", gender: "male", age: 55) }

    it "displays employees" do
      visit root_path

      expect(page).to have_link("John Doe")
      expect(page).to have_link("Bob Johnson")
      expect(page).to have_link("Alice Smith")
    end

    context "search box" do
      it "it is displayed" do
        visit root_path

        expect(page).to have_selector("form", id: "search-employees")
      end

      it "displays employees that match the search term" do
        visit root_path

        fill_in(:search_term, with: "john")

        click_button "Search"

        expect(page).to have_link("John Doe")
        expect(page).to have_link("Bob Johnson")
        expect(page).to_not have_link("Alice Smith")
      end
    end

    context "gender filter" do
      it "it is displayed" do
        visit root_path

        expect(page).to have_selector("form", id: "gender-filter")
      end

      it "displays employees that match the selected option" do
        visit root_path

        choose(:gender, with: "male")

        click_button "Filter by gender"

        expect(page).to have_link("John Doe")
        expect(page).to have_link("Bob Johnson")
        expect(page).to_not have_link("Alice Smith")
      end
    end

    context "age filter" do
      it "it is displayed" do
        visit root_path

        expect(page).to have_selector("form", id: "age-filter")
      end

      it "displays employees that match the selected option" do
        visit root_path

        choose(:age, with: "under")

        click_button "Filter by age"

        expect(page).to_not have_link("John Doe")
        expect(page).to_not have_link("Bob Johnson")
        expect(page).to have_link("Alice Smith")
      end
    end

    context "employee bulk destroy" do
      it "displays the employee bulk destroy form" do
        visit root_path

        expect(page).to have_selector("form", id: "employees_bulk_destroy_form")
      end

      it "deletes selected employees from the list" do
        visit root_path

        els = all("#employee_ids_")

        els.each(&:check)

        click_button("Delete selected employees")

        expect(page).to_not have_link("John Doe")
        expect(page).to_not have_link("Alice Smith")
        expect(page).to_not have_link("Bob Johnson")
      end
    end

    context "creating a new employee" do
      it "displays the 'New employee' link" do
        visit root_path

        expect(page).to have_link("New employee")
      end

      it "clicking the 'New employee' link displays the creation form" do
        visit root_path

        click_link("New employee")

        expect(page).to have_selector("form", id: "new-employee-form")
      end

      it "clicking the 'Cancel' link removes the creation form" do
        visit root_path

        click_link("New employee")
        click_link("Cancel")

        expect(page).to_not have_selector("form", id: "new-employee-form")
      end

      it "submiting the creation form creates a new employee" do
        visit root_path

        click_link("New employee")

        fill_in(:employee_first_name, with: "Jack")
        fill_in(:employee_last_name, with: "Jones")
        fill_in(:employee_email, with: "example@ex.com")
        fill_in(:employee_age, with: 23)
        fill_in(:employee_height, with: 198)
        choose(:employee_gender_male, with: "male")
        fill_in(:employee_job_title, with: "Engineer")
        select(john.company.name, from: "employee_company_id")
        fill_in(:employee_address_street, with: "Rand street name")
        fill_in(:employee_address_city, with: "Rand city")
        fill_in(:employee_bank_information_card_expiration, with: "12/28")
        fill_in(:employee_bank_information_card_number, with: "123456789101234")
        fill_in(:employee_bank_information_card_type, with: "visa")
        fill_in(:employee_bank_information_currency, with: "USD")
        fill_in(:employee_bank_information_iban, with: "RAND RAND RAND RAND 123")

        click_button("Save")

        expect(page).to have_link("Jack Jones")
      end

      it "submiting the creation form with invalid data renders errors" do
        visit root_path

        click_link("New employee")

        click_button("Save")

        expect(page).to have_selector("div", id: "new-employee-errors")
      end
    end

    context "editing an employee" do
      it "updates the name" do
        visit root_path

        click_link("Edit", id: alice.id)
        fill_in(:employee_first_name, with: "Alice Updated Smith")
        click_button("Save")

        expect(page).to have_link("Alice Updated")
      end
    end
  end
end
