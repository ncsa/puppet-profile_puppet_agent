# @summary configuration of puppet client
#
# @param absent_packages
#   Array of package names to ensure absent
#
# @param packages
#   Array of package names to install
#
# @param service_enabled
#   Boolean to determine if the puppet agent service is enabled
#
# @param service_name
#   String of the name of the puppet agent service
#
# @param service_running
#   Boolean to determine if the puppet agent service is ensured running
#
# @param yumrepo
#   Hash of yumrepo resource for puppet yum repository
#
# @example
#   include profile_puppet_agent
class profile_puppet_agent
(
  Array[ String ] $absent_packages,
  Array[ String ] $packages,
  Boolean         $service_enabled,
  String          $service_name,
  Boolean         $service_running,
  Hash            $yumrepo,
) {

  $absent_packages_defaults = {
    ensure  => purged,
  }
  # Ensure the resources
  ensure_packages( $absent_packages, $absent_packages_defaults )

  $yumrepo_defaults = {
    ensure  => present,
    enabled => true,
  }
  ensure_resources( 'yumrepo', $yumrepo, $yumrepo_defaults )

  $packages_defaults = {
  }
  ensure_packages( $packages, $packages_defaults )

  service { $service_name:
    ensure => $service_running,
    enable => $service_enabled,
  }

}
