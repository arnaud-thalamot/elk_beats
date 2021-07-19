########################################################################################################################
#                                                                                                                      #
#                                  OpenSSH Cookbook           											               #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 11/28/2017                                                                                   #
#   Date Last Update    : 11/28/2017                                                                                   #
#   Version             : 1.0                                                                                          #
#   Author              : Arnaud Thalamot                                  											   #
#                                                                                                                      #
########################################################################################################################

#Windows Beats
if platform_family?('windows')
end

#Linux Beats
if platform_family?('rhel')

  remote_file '/tmp/filebeat-7.4.0-x86_64.rpm' do
        source 'https://client.com/ibm/chef-client/filebeat-7.4.0-x86_64.rpm'
        owner 'root'
        group 'root'
        mode '0755'
        action :create_if_missing
    end

    # Install metricbeats rpm
	execute 'install filebeat' do
        command 'rpm -ivh /tmp/filebeat-7.4.0-x86_64.rpm'
        action :run
        only_if { shell_out("rpm -qa filebeat").stdout == ''}
    end

    service 'filebeat' do
      supports :status => true
      action :start
    end
end