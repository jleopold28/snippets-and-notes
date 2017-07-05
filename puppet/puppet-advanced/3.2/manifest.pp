host { 'localhost': ensure => present }
host { 'poppy': ensure => present }

resources { 'host': purge => true }
