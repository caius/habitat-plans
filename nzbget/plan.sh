pkg_name=nzbget
pkg_origin=caius
pkg_version="21.0"
pkg_description="The most efficient usenet downloader."
pkg_upstream_url="http://nzbget.net/"
pkg_maintainer="Caius Durling <dev@caius.name>"
pkg_license=("GPL-2.0-only")

pkg_source="https://github.com/nzbget/nzbget/releases/download/v${pkg_version}/${pkg_name}-${pkg_version}-src.tar.gz"
pkg_filename="${pkg_name}-${pkg_version}-src.tar.gz"
pkg_shasum="65a5d58eb8f301e62cf086b72212cbf91de72316ffc19182ae45119ddd058d53"

pkg_deps=(
  core/gcc-libs
  core/glibc
  core/openssl
  core/libxml2
  core/ncurses
  core/zlib
)

pkg_build_deps=(
  core/gcc
  core/make
  core/patch
  core/pkg-config
)

pkg_bin_dirs=(bin)

# Optional.
# The command for the Supervisor to execute when starting a service. You can
# omit this setting if your package is not intended to be run directly by a
# Supervisor of if your plan contains a run hook in hooks/run.
# pkg_svc_run="haproxy -f $pkg_svc_config_path/haproxy.conf"

# Optional.
# An associative array representing configuration data which should be gossiped to peers. The keys
# in this array represent the name the value will be assigned and the values represent the toml path
# to read the value.
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )

# Optional.
# An array of `pkg_exports` keys containing default values for which ports that this package
# exposes. These values are used as sensible defaults for other tools. For example, when exporting
# a package to a container format.
# pkg_exposes=(port ssl-port)

# Optional.
# An associative array representing services which you depend on and the configuration keys that
# you expect the service to export (by their `pkg_exports`). These binds *must* be set for the
# Supervisor to load the service. The loaded service will wait to run until it's bind becomes
# available. If the bind does not contain the expected keys, the service will not start
# successfully.
# pkg_binds=(
#   [database]="port host"
# )

# Optional.
# Same as `pkg_binds` but these represent optional services to connect to.
# pkg_binds_optional=(
#   [storage]="port host"
# )

# Optional.
# The signal to send the service to shutdown. The default is TERM.
# pkg_shutdown_signal="TERM"

# Optional.
# The number of seconds to wait for a service to shutdown. After this interval
# the service will forcibly be killed. The default is 8.
# pkg_shutdown_timeout_sec=8

do_prepare() {
  do_default_prepare

  # core/openssl isn't built with comp enabled, so patch that out
  patch -p0 < "$PLAN_CONTEXT"/patches/000-nzbget-openssl-no-comp.patch
}

do_build() {
  ./configure --prefix=$pkg_prefix --with-tlslib=OpenSSL && make
}

do_check() {
  nzbget --version
}
