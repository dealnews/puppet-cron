require 'spec_helper'
describe 'cron', :type => :class do
  context 'default params' do
    it { should include_class( 'cron::install' ) }
  end


  context 'with tidy => true, job_prefix => "puppet-cron-"' do
    let (:params) { { :tidy => true, :job_prefix => 'puppet-cron-' } }
    it do
        should contain_tidy('puppet-cron-tidy').with({
            'path'    => '/etc/cron.d',
            'matches' => 'puppet-cron-*',
            'recurse' => true
        })
    end
  end

  context 'with tidy => true, job_prefix => ""' do
    let (:params) { { :tidy => true } }
    it do
      expect { should contain_tidy('puppet-cron-tidy')}.to raise_error(Puppet::Error,/Job prefix must not be blank if you enable tidy on Cron class/)
    end
  end

  context 'with manage_install => false' do
    let (:params) { { :manage_install => false } }
    it { should_not include_class( 'cron::install' ) }
  end
end

