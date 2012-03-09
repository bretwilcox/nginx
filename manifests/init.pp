class nginx (
	$rubyBinPath = $nginx::params::rubyBinPath,
	$nginxConfPath = $nginx::params::nginxConfPath
) inherits nginx::params {
		
	package { "build-essential": ensure => "installed" }
	package { "libcurl4-openssl-dev": ensure => "installed" }
	package { "zlib1g-dev": ensure => "installed" }
	package { 'passenger':
	   ensure   => 'installed',
	   provider => 'gem',
	}
	
	exec { 'passenger-install-nginx-module':
		command => "${nginx::params::rubyBinPath}/passenger-install-nginx-module --auto --auto-download --prefix='/opt/nginx'",
		require => Package['build-essential','libcurl4-openssl-dev', 'zlib1g-dev', 'passenger'];
	}

	file { 'nginx-conf':
		path    => "${nginx::params::nginxConfPath}/nginx.conf",
		owner   => root,
		group   => root,
		mode    => 644,
		source  => "puppet:///modules/nginx/nginx.conf",
		require => Exec['passenger-install-nginx-module'];
	}


	file { 'nginx-init':
      path    => "/etc/init.d/nginx",
      owner   => root,
	  group   => root,
	  mode    => 755,
	  source  => "puppet:///modules/nginx/nginx",
	  require => File['nginx-conf'];
	}
	
}

