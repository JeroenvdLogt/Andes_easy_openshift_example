# Installs the packages from imports and depends in the DESCRIPTION file
tryCatch({

	warnings()
	print('installing project dependencies...')

	args = commandArgs(trailingOnly = TRUE)
  
  	nexus <- ''
	installPath <- ''
	installParams <- ''
	binary_install <- FALSE  # default do not use binary install, unless specified in the input arguments
	re_cache_agent <- FALSE  # default do not try to compile all the agent libs, unless specified in the input arguments
	build_option <- c('--build')

	if (length(args) > 0) {
		nexus = args[1]
		installPath = args[2]
		if (length(args) > 2) {
			installParams = c(args[3])
			print(paste('params found:', installParams))
			binary_install = ("--binary=true" %in% installParams)
			re_cache_agent = ("--re-cache-agent" %in% installParams)
		}
	}

	# check linux version and architecture
	os_version <- system("cat /etc/os-release 2>&1 ", intern=TRUE)
	os_arch <- system("uname -m 2>&1 ", intern=TRUE)
	if (os_arch != "x86_64" || !("REDHAT_BUGZILLA_PRODUCT=\"Red Hat Enterprise Linux 7\"" %in% os_version)) {
		print("Binary install is not available for the OS or architecture")
		print(os_version)
		print(os_arch)
		binary_install <- FALSE
		re_cache_agent <- FALSE
		build_option <- c()
	}

	repos <-  c(
    	paste0(nexus, "/repository/r-internal/"),
	  	paste0(nexus, "/repository/r-official/"))
  	if (binary_install) {
    	r <- c(paste0(nexus, "/repository/r-binary/"), r)
	}
	
	fileName <- file.path(getwd(), "DESCRIPTION")
	conn <- file(fileName, open = "r")
	linn <- readLines(conn)

	collect <- FALSE

	packs <- c()
	pindex <- 1

	for (i in 1:length(linn)) {

		if (grepl(":", linn[i])) {

			if (startsWith(linn[i], "Depends") || startsWith(linn[i], "Imports")) {
				collect <- TRUE
			}
			else {
				collect <- FALSE
			}
		}

		if (collect) {

			pack <- gsub(" ", "", linn[i], fixed = TRUE)
			pack <- gsub(",", "", pack, fixed = TRUE)
			pack <- gsub("\t", "", pack, fixed = TRUE)

			if (!startsWith(pack, "Depends") &&
			!startsWith(pack, "Imports") &&
			!startsWith(pack, "r(") &&
			!startsWith(pack, "R(") &&
			pack != "r" &&
			pack != "R") {
				corepack <- strsplit(pack, '\\(')[[1]][[1]]
				packs[[pindex]] <- corepack
				pindex <- pindex + 1
			}
		}
	}

	print('Packages in DESCRIPTION found:')
	print(packs)
	close(conn)

	#libpath = file.path("/usr/src/Rlibs")		# r packages will be installed here
	#pkg_path = file.path("/usr/src/Rpkgs")		# r source .tar.gz files will be stored here
	#pkg_bin_path = file.path("/usr/src/Rpkgs_bin")  # compiled r binary .tar.gz files will be stored here
	libpath = installPath
	pkg_path = installPath
	
	.libPaths(libpath)

	installed_packages <- installed.packages()

	# temporary set pwd to bin path to receive build
	#old_pwd <- getwd()
	#setwd(pkg_bin_path)
	for (pack in packs) {

		plist <- strsplit(pack, "[(]")[[1]]
		p <- plist[1]
		vers <- 'latest'
		if (length(plist) > 1 && substr(plist[2], 1, 2) == '==') {
			vers <- substr(plist[2], 3, nchar(plist[2]) - 1)
		}

		print(paste0('Package: ', p, '. Version: ', vers))
		if (!(p %in% installed_packages)) {

			if (vers == 'latest') {
				install.packages(p, lib = libpath, repos = repos,
					upgrade = TRUE, 
					INSTALL_opts = build_option, destdir = pkg_path)
			} else {
				library('devtools')
				install_version(p, lib = libpath, repos = repos,
					version = vers, 
					INSTALL_opts = build_option, destdir = pkg_path)
			}

			installed_packages <- installed.packages()
			if (!(p %in% installed_packages)) {
				stop(paste0('There was a problem installing ', p))
			}
		}
		else {
			print(paste0(p, ' is already installed.'))
		}
	}
	# re-cache agent if needed
	# this will download and compile all the agent libs
	# NOTE: the agengLib will not be re-installed
	# this option is only intended for professionalisering team members
	if (re_cache_agent) {
		print("Re-cache the following agent libs for binary repo")
		print(existing_agent_libs)
		install.packages(existing_agent_libs, lib = libpath, repos = repos, upgrade = TRUE, 
		INSTALL_opts = build_option, destdir = pkg_path)
	}
	
	#setwd(old_pwd)
	
}, error = function(err) {
	print(err)
	quit("no", 666, FALSE)