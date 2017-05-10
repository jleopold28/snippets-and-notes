include_controls 'cis/cis-ubuntu14.04lts-level1' do
  skip_control 'xccdf_org.cisecurity.benchmarks_rule_10.1.1_Set_Password_Expiration_Days'

  control 'xccdf_org.cisecurity.benchmarks_rule_10.1.1_Set_Password_Expiration_Days_To_30' do
    title 'Set Password Expiration Days'
    desc 'The PASS_MAX_DAYS parameter in /etc/login.defs allows an administrator to force passwords to expire once they reach a defined age. It is recommended that the PASS_MAX_DAYS parameter be set to less than or equal to 30 days.'
    impact 1.0

    describe file('/etc/login.defs') do
      its(:content) { is_expected.to match(/^\s*PASS_MAX_DAYS\s+30/) }
    end
  end
end
