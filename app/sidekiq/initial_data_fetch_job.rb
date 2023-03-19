class InitialDataFetchJob
  include Sidekiq::Job

  sidekiq_options queue: 'remote_data_fetch', retry: 5, timeout: 60,
                  lock: :until_executed, on_conflict: :reject

  def perform(skip, limit)
    FetchAndDataCreationService.new(skip, limit).call
  end
end
