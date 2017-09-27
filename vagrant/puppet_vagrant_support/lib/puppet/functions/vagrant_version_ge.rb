# determines vagrant version
Puppet::Functions.create_function(:vagrant_version_ge) do
  dispatch :version_ge do
    param 'String', :version_check
  end

  def version_ge(version_check)
    # grab the installed version
    install_version = /\d\.\d\.\d+/.match(`vagrant --version`).captures[0]
    # is the major.minor installed version ge?
    if install_version.to_f >= version_check.to_f
      # is the patch version installed ge?
      if /\d+$/.match(install_version).captures[0].to_i >= /\d+$/.match(version_check).captures[0].to_i
        true
      else
        false
      end
    else
      false
    end
  end
end
