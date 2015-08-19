install_ap_binary_dependencies() {
  if test -f "$1/.oracle.ini"; then
    install_oci8 $1 $2
  else
    info "No trigger found."
  fi
}

install_oci8() {
  echo "Installing Oracle OCI8 dependencies"

  local s3bucket="https://s3.amazonaws.com/chameleon-heroku-assets"
  local oracle_instant_client_tgz="$s3bucket/instantclient_11_2_with_libaio_oci8.tar.gz"
  local oracle_instant_client_dir="$1/vendor/oracle_instantclient"

  echo "Creating directory"
  mkdir -p $oracle_instant_client_dir

  echo "Downloading and installing Oracle binaries from $s3bucket"
  curl $oracle_instant_client_tgz -s -o - | tar xzf - -C $oracle_instant_client_dir

  echo "${oracle_instant_client_dir}" > "/etc/ld.so.conf.d/oracle-instantclient.conf"

  sudo ldconfig

  echo "Done installing OCI8."
}
