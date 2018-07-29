Facter.add(:environment) do
  setcode do
    case Facter.value(:hostname).downcase
    when /^c-dev-/, /^n-dev-/ then 'dev'
    when /^lc-dev/ then 'test'
    when /^c-uat/, /^n-uat/ then 'uat'
    when /^c-prod/, /^n-prod/ then 'prod'
    else 'unknown'
    end
  end
end
