namespace :batch_tasks do
  desc '每隔10分钟检查一次，是否有话题的浏览量需要增值'
  task increase_view_number: :environment do
    Rails.application.eager_load!
    puts 'increase_view_number start'
    Services::AutoIncreaseCount.call
    puts 'increase_view_number end'
  end
end