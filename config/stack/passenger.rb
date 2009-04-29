package :passenger, :provides => :appserver do
  description 'Phusion Passenger (mod_rails)'

  # we use the version of passenger that's on the box, or installed by :passenger_gem
  version = '`passenger-config --version`'
  gem_dir = '`gem environment gemdir`'
  ruby_bin = '`which ruby`'
  apache_conf = "/etc/apache2/apache2.conf"
  passenger_conf = "/etc/apache2/extras/passenger.conf"
  
  push_text "Include #{passenger_conf}", apache_conf, :sudo => true do
    pre :install, 'echo -en "\n\n\n\n" | sudo passenger-install-apache2-module'
    pre :install, "mkdir -p #{File.dirname(passenger_conf)}"
    
    [ "LoadModule passenger_module #{gem_dir}/gems/passenger-#{version}/ext/apache2/mod_passenger.so",
      "PassengerRoot #{gem_dir}/gems/passenger-#{version}",
      "PassengerRuby #{ruby_bin}",
      "RailsEnv production" ].each do |line|
      pre :install, "echo \"#{line}\" | sudo tee -a #{passenger_conf}" # interpolation echo, b/c of backtics
    end
    
    post :install, '/etc/init.d/apache2 restart'
  end

  verify do
    has_file "#{gem_dir}/gems/passenger-#{version}/ext/apache2/mod_passenger.so"
    has_directory "#{gem_dir}/gems/passenger-#{version}"
    file_contains apache_conf, "Include #{passenger_conf}"
    file_contains passenger_conf, "LoadModule passenger_module" # check just minimal config, as it's likely to change
  end
  
  requires :apache, :apache2_prefork_dev, :ruby_enterprise, :passenger_gem
end

package :passenger_gem do
  gem 'passenger'
  verify { has_gem 'passenger' }
end