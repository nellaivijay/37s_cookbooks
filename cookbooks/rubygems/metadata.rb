maintainer        "37signals"
maintainer_email  "sysadmins@37signals.com"
description       "Configures rubygems"
version           "0.1"
recipe            "rubygems::client"
recipe            "rubygems::mirror"
depends           "apache2"