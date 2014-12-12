class pamldap (
  $base_dn = hiera('pamldap::base_dn'),
  $uris    = hiera('pamldap::uris'),
  $enable_mod_mkhomedir = hiera('pamldap::enable_mod_mkhomedir', false),
  $tls_reqcert = 'allow',
  $binddn = false,
  $bindpw = false,
  $sssd_conf_vars = false
) {
  class { 'pamldap::config':
    base_dn              => $base_dn,
    uris                 => $uris,
    enable_mod_mkhomedir => $enable_mod_mkhomedir,
    tls_reqcert          => $tls_reqcert,
    binddn               => $binddn,
    bindpw               => $bindpw,
    sssd_conf_vars       => $sssd_conf_vars,

  }
  include pamldap::install
  include pamldap::service
}
