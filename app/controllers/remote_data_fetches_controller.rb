class RemoteDataFetchesController < ApplicationController
  before_action :redirect_if_employees_exist

  def index
    InitialDataCreationJob.new.perform
  end

  private

  def redirect_if_employees_exist
    redirect_to employees_path if Employee.any?
  end
end
