require 'serverspec'

set :backend, :exec

describe package('ntp') do
  it { should be_installed }
end

$stdout.write(os[:family])

if os[:family] == 'redhat'
  service = 'ntpd'
elsif [ 'debian', 'ubuntu' ].include? os[:family]
  service = 'ntp'
end

describe service(service) do
  it { should be_enabled }
  it { should be_running }
end

describe port(123) do
  it { should be_listening }
end
