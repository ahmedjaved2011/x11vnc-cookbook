#
# Cookbook Name:: x11vnc
# Recipe:: default

package "x11vnc"

password_opt = ""
unless node[:x11vnc][:password].empty?
  password_opt = "-rfbauth /etc/x11vnc.pass"

  execute "generate x11vnc password file" do
    command "x11vnc -storepasswd #{node[:x11vnc][:password]} /etc/x11vnc.pass"
  end
end

template "/etc/init/x11vnc.conf" do
  source "x11vnc.conf.erb"
  mode 0644
  variables(
    :password_opt => password_opt,
    :port => node[:x11vnc][:port]
  )
end

service "x11vnc" do        
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end


