########################################################################################################################
#                                                                                                                      #
#                                  ELK Beats Cookbook          											               #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 11/28/2017                                                                                   #
#   Date Last Update    : 11/28/2017                                                                                   #
#   Version             : 1.0                                                                                          #
#   Author              : Arnaud Thalamot                                                                              #
#                                                                                                                      #
########################################################################################################################

#Windows Beats
if platform_family?('windows')

  remote_file 'C:/metricbeat-7.4.0-windows-x86_64.zip' do
        source 'https://client.com/ibm/chef-client/metricbeat-7.4.0-windows-x86_64'
        owner 'root'
        group 'root'
        mode '0755'
        action :create_if_missing
    end

  directory 'C:/metricbeat' do
    action :create_if_missing
  end

    ruby_block 'unzip-install-file' do
          block do
            command = powershell_out "Add-Type -assembly \"system.io.compression.filesystem\"; [io.compression.zipfile]::ExtractToDirectory('C:/metricbeat-7.4.0-windows-x86_64.zip', 'C:/metricbeat')"
            Chef::Log.debug command.to_s
            action :create
          end
        end

end

#Linux Beats
if platform_family?('rhel')

  remote_file '/tmp/metricbeat-7.4.0-x86_64.rpm' do
        source 'https://client.com/ibm/chef-client/metricbeat-7.4.0-x86_64.rpm'
        owner 'root'
        group 'root'
        mode '0755'
        action :create_if_missing
    end

    # Install metricbeats rpm
	execute 'install metricbeats' do
        command 'rpm -ivh /tmp/metricbeat-7.4.0-x86_64.rpm'
        action :run
        only_if { shell_out("rpm -qa metricbeat").stdout == ''}
    end

    # Copy metricbeats config
    cookbook_file '/etc/metricbeat/metricbeat.yml' do
      source 'metricbeat.yml'
      mode '0600'
      action :create
    end

    # Copy metricbeats config
    cookbook_file '/etc/metricbeat/modules.d/system.yml' do
      source 'system.yml'
      mode '0600'
      action :create
    end

    service 'metricbeat' do
      supports :status => true
      action :start
    end
end