# @summary configuration of puppet client
#
# @param absent_packages
#   Array of package names to ensure absent
#
# @param packages
#   Array of package names to install
#
# @param repo_rpm_name
#   String of package name for puppet repo package
#
# @param repo_rpm_url
#   String of URL for puppet repo package
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
# @example
#   include profile_puppet_agent
class profile_puppet_agent
(
  Array[ String ] $absent_packages,
  Array[ String ] $packages,
  String          $repo_rpm_name,
  String          $repo_rpm_url,
  Boolean         $service_enabled,
  String          $service_name,
  Boolean         $service_running,
) {

  $absent_packages_defaults = {
    ensure  => purged,
  }
  # Ensure the resources
  ensure_packages( $absent_packages, $absent_packages_defaults )

  package { $repo_rpm_name:
    source   => $repo_rpm_url,
    provider => 'rpm',
  }

  $packages_defaults = {
    require => Package[$repo_rpm_name],
  }
  ensure_packages( $packages, $packages_defaults )

  service { $service_name:
    ensure => $service_running,
    enable => $service_enabled,
  }

}
