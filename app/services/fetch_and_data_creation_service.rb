class FetchAndDataCreationService
  def initialize(skip, limit)
    @skip = skip
    @limit = limit
  end

  def call
    response = HTTParty.get('https://dummyjson.com/users', query: { skip: @skip, limit: @limit } )

    return "Error retrieving users: #{response.code} - #{response.message}" unless response.success?

    response['users'].each do |user|
      company = Company.find_or_create_by!(name: user["company"]["name"])
      company_address = CompanyAddress.find_or_create_by!(company: company) do |ca|
        ca.street = user["company"]["address"]["address"]
        ca.city = user["company"]["address"]["city"]
        ca.coordinates = [user["company"]["address"]["coordinates"]["lat"], user["company"]["address"]["coordinates"]["lng"]]
        ca.company = company
      end

      Department.find_or_create_by!(name: user["company"]["department"], company: company)

      employee = Employee.find_or_create_by!(email: user["email"]) do |e|
        e.first_name = user["firstName"]
        e.last_name = user["lastName"]
        e.email = user["email"]
        e.age = user["age"]
        e.gender = user["gender"]
        e.height = user["height"]
        e.weight = user["weight"]
        e.image = user["image"]
        e.hair = user["hair"]
        e.ip = user["ip"]
        e.job_title = user["company"]["title"]
        e.company = company
      end
      employee_address = EmployeeAddress.find_or_create_by!(employee: employee) do |ea|
        ea.street = user["address"]["address"]
        ea.city = user["address"]["city"]
        ea.coordinates = [user["address"]["coordinates"]["lat"], user["address"]["coordinates"]["lng"]]
        ea.employee = employee
      end
      employee_bank_info = EmployeeBankInformation.find_or_create_by!(employee: employee) do |ebi|
        ebi.card_expiration = user["bank"]["cardExpire"]
        ebi.card_number  = user["bank"]["cardNumber"]
        ebi.card_type = user["bank"]["cardType"]
        ebi.currency = user["bank"]["currency"]
        ebi.iban = user["bank"]["iban"]
        ebi.employee = employee
      end
    end
  end
end
