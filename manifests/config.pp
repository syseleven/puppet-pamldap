class pamldap::config (
  $base_dn,
  $uris,
  $enable_mod_mkhomedir,
) {
  $uris_space = join($uris, ' ')
  $uris_comma = join($uris, ',')
  
  # defaults
  File {
    owner => 'root',
    group => 'root',
  }
  file { '/etc/pam.d/system-auth-ac':
    ensure  => present,
    mode    => '0444',
    content => template('pamldap/system-auth.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  file { '/etc/pam.d/system-auth':
    ensure  => present,
    target  => 'system-auth-ac',
    require => File['/etc/pam.d/system-auth-ac'],
  }
  file { '/etc/pam.d/password-auth-ac':
    ensure  => present,
    mode    => '0444',
    content => template('pamldap/password-auth.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  file { '/etc/pam.d/password-auth':
    ensure  => present,
    target  => 'password-auth-ac',
    require => File['/etc/pam.d/password-auth-ac'],
  }
  file { '/etc/nsswitch.conf':
    ensure  => present,
    mode    => '0444',
    content => template('pamldap/nsswitch.conf.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  file { '/etc/sssd/sssd.conf':
    ensure  => present,
    mode    => '0600',
    content => template('pamldap/sssd.conf.erb'),
    require => Class['pamldap::install'],
    notify  => Class['pamldap::service'],
  }
  
  # FIXME system-auth and password-auth are not being read by pam.d/ssh so put it in proper place
  if $enable_mod_mkhomedir {
    file_line {'enable_mod_mkhomedir':
      line => 'session required pam_mkhomedir.so skel=/etc/skel umask=0022',
      path => '/etc/pam.d/common-session',
    }
  }

  case $::osfamily {
    'RedHat': {
      file { '/etc/ldap.conf':
        ensure  => present,
        mode    => '0444',
        content => template('pamldap/ldap.conf.erb'),
        require => Class['pamldap::install'],
        notify  => Class['pamldap::service'],
      }
      file { [ '/etc/pam_ldap.conf', '/etc/openldap/ldap.conf' ]:
        ensure  => link,
        target  => '/etc/ldap.conf',
        require => File['/etc/ldap.conf'],
        notify  => Class['pamldap::service'],
      }
    }
    'Debian': {
      file { '/etc/ldap/ldap.conf':
        ensure  => present,
        mode    => '0444',
        content => template('pamldap/ldap.conf.erb'),
        require => Class['pamldap::install'],
        notify  => Class['pamldap::service'],
      }
    }
  }
}
