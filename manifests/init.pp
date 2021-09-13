# @summary configuration of puppet client
#
# @param absent_packages
#   Array of package names to ensure absent
#
# @param config
#   Array of puppet agent config hashes for puppet_agent::config
#
# @param config_file
#   Full path to puppet config file
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
  Array[ Hash ]   $config,
  String          $config_file,
  Array[ String ] $packages,
  Boolean         $service_enabled,
  String          $service_name,
  Boolean         $service_running,
  Hash            $yumrepo,
) {

  ## IN THE FUTURE WE MAY WANT TO EXPLORE USING 
  ## https://github.com/puppetlabs/puppetlabs-puppet_agent/

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

  # LOGIC COPIED FROM 
  # https://github.com/puppetlabs/puppetlabs-puppet_agent/blob/main/manifests/configure.pp
  $config.each |$item| {
    $ensure = $item['ensure'] ? {
      undef   => present,
      default => $item['ensure'],
    }

    ini_setting { "puppet-${item['section']}-${item['setting']}":
      ensure  => $ensure,
      section => $item['section'],
      setting => $item['setting'],
      value   => $item['value'],
      path    => $config_file,
    }
  }

}
