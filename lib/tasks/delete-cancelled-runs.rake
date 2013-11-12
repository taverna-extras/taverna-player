namespace :taverna_player do
  desc "Delete all cancelled workflow runs."
  task :delete_cancelled_runs => :environment do

    gone = 0
    TavernaPlayer::Run.all.each do |run|
      if run.cancelled?
        gone += 1 #if run.destroy
      end
    end

    puts "#{gone} cancelled runs were deleted."
  end
end
