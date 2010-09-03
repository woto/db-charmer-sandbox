# Project-specific configuration for CruiseControl.rb

Project.configure do |project|
  project.email_notifier.emails = [ 'webmaster@avtorif.ru' ]
  project.email_notifier.from = 'webtest@avtorif.ru'

  project.scheduler.polling_interval = 10.seconds
  project.build_command = 'script/cruise_build master'
end
