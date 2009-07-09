require_recipe "apache2"

# Required to compile passenger
package "apache2-prefork-dev"

gem_package "passenger" do
  action :install
  version node[:passenger][:version]
end

execute "passenger_module" do
  command 'echo -en "\n\n\n\n" | passenger-install-apache2-module'
  creates node[:passenger][:module_path]
end

gem_package "SyslogLogger"

template node[:passenger][:apache_load_path] do
  source "passenger.load.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, resources(:service => "apache2")
end

template node[:passenger][:apache_conf_path] do
  source "passenger.conf.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, resources(:service => "apache2")
end

remote_file "/usr/local/bin/passenger_monitor" do
  source "passenger_monitor"
  mode 0755
end

template "/usr/local/bin/ruby_gc_wrapper" do
  source "ruby_gc_wrapper.sh.erb"
  mode 0755
end

cron "passenger memory monitor" do
  command "/usr/local/bin/passenger_monitor 280 550"
end

apache_module "passenger"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_rewrite"