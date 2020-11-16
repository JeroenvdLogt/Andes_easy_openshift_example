#
# Installs a R package with dependencies given the packagename and the install folder
#
tryCatch({

  args = commandArgs(trailingOnly=TRUE)
  
  nexus <- ''
  packagename <- ''
  version <- ''
  installPath <- ''  
  binary_install <- FALSE

  # check arguments
  if (length(args) >= 4 && length(args) <= 5) {
    nexus = args[1]
    packagename = args[2]
    version = args[3] 
    installPath = args[4]
  }
  else {
	  stop('expecting four or five arguments: nexus, packagename, version, installPath, binaryInstall')
  }
  if (length(args) == 5 && args[5] == '--binary=true') {
    binary_install <- TRUE
  }

  # check linux version and architecture
  os_version <- system("cat /etc/os-release 2>&1 ", intern=TRUE)
  os_arch <- system("uname -m 2>&1 ", intern=TRUE)
  if (os_arch != "x86_64" || !("REDHAT_BUGZILLA_PRODUCT=\"Red Hat Enterprise Linux 7\"" %in% os_version)) {
    print("Binary install is not available for the OS or architecture")
    print(os_version)
    print(os_arch)
    binary_install <- FALSE
  }

  # add binary repo if binary switch is on
  r <-  c(
    paste0(nexus, "/repository/r-internal/"),
	  paste0(nexus, "/repository/r-official/"))
  if (binary_install) {
    r <- c(
	    paste0(nexus, "/repository/r-binary/"),
      r)
  }
  
  # HACK: replace with this proper download later
  # install latest with all dependencies
  #install.packages(packagename, installPath, repos = r, upgrade = TRUE)
  # remove latest
  #remove.packages(packagename)
  # install real version
  packageurl <- paste0(nexus, "/repository/r-internal/src/contrib/", packagename, '_', version, ".tar.gz")
  install.packages(packageurl, installPath, repos=NULL, type="source")

  # check if installed
  installed_packages <- installed.packages(installPath)
  if (!(packagename %in% installed_packages)) {
	  stop(paste(packagename, 'could not be found.'))
  }
  
}, error = function(err) {
  print(err)
  quit("no", 666, FALSE)
})