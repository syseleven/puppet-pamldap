class pamldap (
  $base_dn = hiera('pamldap::base_dn'),
  $uris    = hiera('pamldap::uris'),
  $enable_mod_mkhomedir = hiera('pamldap::enable_mod_mkhomedir', false)
) {
  class { 'pamldap::config':
    base_dn              => $base_dn,
    uris                 => $uris,
    enable_mod_mkhomedir => $enable_mod_mkhomedir,
  }
  include pamldap::install
  include pamldap::service
}
