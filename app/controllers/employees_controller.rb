class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_no_employees

  def index
    @employees =
      if params[:search_term].present?
        Employee.by_full_name_or_email_search(params[:search_term], params[:page] || 1)
      elsif params[:gender].present?
        Employee.by_gender_filter(params[:gender], params[:page] || 1)
      elsif params[:age].present?
        Employee.by_age_filter(params[:age], params[:page] || 1)
      else
        Employee.by_full_name(params[:page] || 1)
      end

    respond_to do |format|
      format.html
      format.json { render json: { employees: @employees } }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @employee }
    end
  end

  def new
    @employee = Employee.new
    @employee.build_employee_address
    @employee.build_employee_bank_information
  end

  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: "Employee was successfully created." }
        format.json { render json: @employee, status: :created }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employees_path, notice: "Employee was successfully updated." }
        format.json { render json: @employee}
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_path, notice: "Employee was successfully destroyed." }
      format.json { render json: { message: "Employee deleted successfully" } }
      format.turbo_stream
    end
  end

  def bulk_destroy
    Employee.destroy(params[:employee_ids])
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def redirect_if_no_employees
    redirect_to remote_data_fetches_path if Employee.none?
  end

  def employee_params
    params.require(:employee).permit(
      :first_name,
      :last_name,
      :email,
      :gender,
      :age,
      :height,
      :company_id,
      :job_title,
      employee_address_attributes: %i[street city],
      employee_bank_information_attributes: %i[card_expiration card_number card_type currency iban]
    )
  end
end
