require 'spec_helper'
require 'yaml'

describe 'custom::lvm' do
  # setup for the tests
  let(:facts) { { role: 'role_two' } }
  let(:title) { 'lvm test' }

  test_lvm_hash = YAML.load_file(File.expand_path('../../fixtures/hieradata/common.yaml', __FILE__))['test_lvm_hash']

  context 'with test_lvm_hash' do
    let(:params) { { lvm_hash: test_lvm_hash } }

    it { is_expected.to contain_custom__lvm('lvm test').with_lvm_hash(test_lvm_hash) }

    # sda tests
    it { is_expected.to contain_physical_volume('/dev/sda2').with_ensure('present') }
    it { is_expected.to contain_volume_group('vg00').with(
      'ensure'           => 'present',
      'physical_volumes' => '/dev/sda2'
    )
    }

    # other sd tests
    it { is_expected.to contain_exec("/bin/echo 'n\np\n1\n1\n\nt\n8e\nw' | /sbin/fdisk /dev/sdf").with_unless('/bin/lsblk | /bin/grep sdf1') }
    it { is_expected.to contain_exec("/bin/echo 'n\np\n1\n1\n\nt\n8e\nw' | /sbin/fdisk /dev/sdf").that_comes_before('Physical_volume[/dev/sdf1]') }

    it { is_expected.to contain_physical_volume('/dev/sdf1').with_ensure('present') }
    it { is_expected.to contain_physical_volume('/dev/sdf1').that_comes_before('Volume_group[vg01]') }

    # vg01 tests
    it { is_expected.to contain_volume_group('vg01').with(
      'ensure'           => 'present',
      'physical_volumes' => %w(/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1)
    )
    }

    # informix raw tests
    it { is_expected.to contain_logical_volume('lv_abc_0001').with(
      'ensure'       => 'present',
      'initial_size' => '1.00G',
      'size'         => '1.00G',
      'volume_group' => 'vg01'
    )
    }
    it { is_expected.to contain_logical_volume('lv_abc_0001').that_requires('Volume_group[vg01]') }

    it { is_expected.to contain_file_line('udevrule /dev/vg01/lv_abc_0001').with(
      'ensure' => 'present',
      'path'   => '/etc/udev/rules.d/60-raw.rules',
      'line'   => 'ACTION=="add|change", ENV{DM_VG_NAME}=="vg01", ENV{DM_LV_NAME}=="lv_abc_0001", RUN+="/bin/raw /dev/raw/raw1 %N"',
      'match'  => '.*lv_abc_0001.*raw1.*'
    )
    }
    it { is_expected.to contain_file_line('udevrule /dev/vg01/lv_abc_0001').that_requires('Logical_volume[lv_abc_0001]') }
    it { is_expected.to contain_file_line('udevrule /dev/vg01/lv_abc_0001').that_comes_before('File_line[udevrule kernel]') }

    it { is_expected.to contain_file_line('udevrule kernel').with(
      'ensure' => 'present',
      'path'   => '/etc/udev/rules.d/60-raw.rules',
      'line'   => 'ACTION=="add|change", KERNEL=="raw*", OWNER=="65535", GROUP=="32768", MODE=="0660"'
    )
    }
    it { is_expected.to contain_file_line('udevrule kernel').that_notifies('Exec[/sbin/udevadm control --reload-rules; /sbin/udevadm trigger --action=change]') }

    it { is_expected.to contain_exec('/sbin/udevadm control --reload-rules; /sbin/udevadm trigger --action=change').with_refreshonly('true') }

    # swap tests
    it { is_expected.to contain_exec('/sbin/swapoff /dev/vg01/lv_extended_swap').with_onlyif('/bin/grep lv_extended_swap /etc/fstab') }

    it { is_expected.to contain_logical_volume('lv_extended_swap').with(
      'ensure'       => 'present',
      'initial_size' => '2.00G',
      'size'         => '2.00G',
      'volume_group' => 'vg01'
    )
    }
    it { is_expected.to contain_logical_volume('lv_extended_swap').that_requires(['Exec[/sbin/swapoff /dev/vg01/lv_extended_swap]', 'Volume_group[vg01]']) }

    it { is_expected.to contain_filesystem('/dev/vg01/lv_extended_swap').with(
      'ensure'  => 'present',
      'fs_type' => 'swap'
    )
    }
    it { is_expected.to contain_filesystem('/dev/vg01/lv_extended_swap').that_subscribes_to('Logical_volume[lv_extended_swap]') }

    it { is_expected.to contain_mount('swap').with(
      'device'  => '/dev/vg01/lv_extended_swap',
      'fstype'  => 'swap',
      'options' => 'defaults',
      'dump'    => '0',
      'pass'    => '0',
      'atboot'  => 'true'
    )
    }
    it { is_expected.to contain_mount('swap').that_subscribes_to('Filesystem[/dev/vg01/lv_extended_swap]') }

    it { is_expected.to contain_exec('/sbin/swapon /dev/vg01/lv_extended_swap').with(
      'unless'      => '/bin/grep `/bin/readlink -f /dev/vg01/lv_extended_swap` /proc/swaps',
      'refreshonly' => 'true'
    )
    }
    it { is_expected.to contain_exec('/sbin/swapon /dev/vg01/lv_extended_swap').that_subscribes_to(['Mount[swap]', 'Exec[/sbin/swapoff /dev/vg01/lv_extended_swap]']) }

    # lvm removal tests
    it { is_expected.to contain_mount('/opt/puppetlabs').with(
      'ensure' => 'absent',
      'device' => '/dev/vg01/lv_puppet',
      'atboot' => 'false'
    )
    }
    it { is_expected.to contain_mount('/opt/puppetlabs').that_requires('Volume_group[vg01]') }

    it { is_expected.to contain_filesystem('/dev/vg01/lv_puppet').with_ensure('absent') }
    it { is_expected.to contain_filesystem('/dev/vg01/lv_puppet').that_requires('Mount[/opt/puppetlabs]') }

    it { is_expected.to contain_logical_volume('lv_puppet').with(
      'ensure'       => 'absent',
      'volume_group' => 'vg01'
    )
    }
    it { is_expected.to contain_logical_volume('lv_puppet').that_requires('Filesystem[/dev/vg01/lv_puppet]') }

    # normal lvm maintenance test
    it { is_expected.to contain_logical_volume('lv_var').with(
      'ensure'       => 'present',
      'initial_size' => '768.00M',
      'size'         => '768.00M',
      'volume_group' => 'vg01'
    )
    }
    it { is_expected.to contain_logical_volume('lv_var').that_requires('Volume_group[vg01]') }

    it { is_expected.to contain_filesystem('/dev/vg01/lv_var').with(
      'ensure'  => 'present',
      'fs_type' => 'ext4'
    )
    }
    it { is_expected.to contain_filesystem('/dev/vg01/lv_var').that_subscribes_to('Logical_volume[lv_var]') }

    it { is_expected.to contain_file('/var').with(
      'ensure' => 'directory',
      'owner'  => '0',
      'group'  => '0',
      'mode'   => '755'
    )
    }

    it { is_expected.to contain_mount('/var').with(
      'ensure'  => 'mounted',
      'device'  => '/dev/vg01/lv_var',
      'fstype'  => 'ext4',
      'options' => 'defaults',
      'dump'    => '1',
      'pass'    => '2',
      'atboot'  => 'true'
    )
    }
    it { is_expected.to contain_mount('/var').that_requires('File[/var]') }
    it { is_expected.to contain_mount('/var').that_subscribes_to('Filesystem[/dev/vg01/lv_var]') }
  end
end
