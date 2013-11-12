namespace :taverna_player do
  desc "Delete all completed embedded workflow runs."
  task :delete_completed_embedded_runs => :environment do

    gone = 0
    TavernaPlayer::Run.find_all_by_embedded(true).each do |run|
      if run.complete?
        gone += 1 if run.destroy
      end
    end

    puts "#{gone} complete embedded runs were deleted."
  end
end
