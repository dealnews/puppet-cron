require 'spec_helper'

describe 'cron', :type => :class do

  context 'when using default params' do
    it { should contain_class('cron::install') }
  end

  context 'with tidy => true, job_prefix => "puppet-cron-"' do
    let(:params) do
      {
        :tidy       => true,
        :job_prefix => 'puppet-cron-'
      }
    end
    it do
        should contain_tidy('puppet-cron-tidy').with({
            'path'    => '/etc/cron.d',
            'matches' => 'puppet-cron-*',
            'recurse' => true
        })
    end
  end

  context 'with tidy => true, job_prefix => ""' do
    let(:params) { { :tidy => true } }
    it do
      expect { should contain_tidy('puppet-cron-tidy')}.to raise_error(Puppet::Error,/Job prefix must not be blank if you enable tidy on Cron class/)
    end
  end

  context 'with package_ensure => absent' do
    let(:params) { { :package_ensure => 'absent' } }
    it { should contain_class('cron::install').with_package_ensure('absent') }
  end

end
