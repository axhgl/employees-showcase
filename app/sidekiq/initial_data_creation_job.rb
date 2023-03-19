class InitialDataCreationJob
  include Sidekiq::Job

  sidekiq_options queue: 'remote_data_fetch', retry: 5, timeout: 60,
                  lock: :until_executed, on_conflict: :reject

  def perform
    response = HTTParty.get('https://dummyjson.com/users')
    return "Error retrieving users: #{response.code} - #{response.message}" unless response.success?

    records_total = response["total"]
    return "no records to fetch" if records_total <= 0

    limit = 10
    skip = 0
    pages = (records_total / limit).round

    pages.times.each do |p|
      InitialDataFetchJob.perform_async(skip, limit)
      skip += limit
    end
  end
end
