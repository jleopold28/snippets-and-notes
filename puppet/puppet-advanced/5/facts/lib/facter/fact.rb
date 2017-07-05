require 'facter'

Facter.add(:environment) do
  setcode do
    case Facter.value(:hostname)
    when 'node1' then 'dev'
    when 'node2' then 'qa'
    when 'node3' then 'prod'
    when 'puppet' then 'none'
    else raise 'Unknown env!'
    end
  end
end

Facter.add(:node_num) do
  setcode do
    node_num = Facter.value(:hostname).match(/\d$/)[0]
    node_num.nil? ? 'invalid' : node_num
  end
end
