# inventory.mc
inventory do
  format "%s:\t\t%s\t\t%s/%s"

  fields { [ facts["ipaddress"], facts["processors"]["count"], facts["memory"]["system"]["used"], facts["memory"]["system"]["total"], ] }
end
