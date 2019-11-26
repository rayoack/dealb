# frozen_string_literal: true

namespace :import_old_database do
  desc 'Import old database task... migration from old db'
  task import: [:environment] do
    puts '-- Start importing'

    ImportOldDatabaseService.run

    puts '-- Finished importing'
  end
end
