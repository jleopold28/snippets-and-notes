Facter.add(:location) do
  setcode do
    case Facter.value(:hostname)
    when /^sea/ then 'seattle'
    when /^glas/ then 'glasgow'
    when /^atl/ then 'atlanta'
    else 'unknown'
    end
  end
end
