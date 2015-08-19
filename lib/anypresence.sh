install_ap_binary_dependencies() {
  if test -f $1/.oracle.ini; then
    install_oci8 $1 $2
  else
    info "No trigger found."
  fi
}

install_oci8() {
  info "Installing Oracle OCI8 dependencies"

  s3bucket="https://s3.amazonaws.com/chameleon-heroku-assets"
  oracle_instant_client_tgz="$s3bucket/instantclient_11_2_with_libaio_oci8.tar.gz"
  oracle_instant_client_dir="$1/vendor/oracle_instantclient"

  info "Creating directory"
  mkdir -p $oracle_instant_client_dir

  info "Downloading and installing Oracle binaries from $s3bucket"
  curl $oracle_instant_client_tgz -s -o - | tar xzf - -C $oracle_instant_client_dir

  oci_inc="$oracle_instant_client_dir/sdk/include"
  mkdir -p $1/.profile.d
  echo "export LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH:+LD_LIBRARY_PATH:}\$HOME/vendor/oracle_instantclient\"" > $1/.profile.d/nodejs.sh
  echo "export OCI_LIB_DIR=\"\$HOME/vendor/oracle_instantclient\"" >> $1/.profile.d/nodejs.sh
  echo "export OCI_INC_DIR=\"\$HOME/vendor/oracle_instantclient/sdk/include\"" >> $1/.profile.d/nodejs.sh

  echo "export OCI_INC_DIR=\"$oci_inc\"" > $2/export
  echo "export OCI_LIB_DIR=\"$oracle_instant_client_dir\"" >> $2/export
  echo "export LD_LIBRARY_PATH=\"$oracle_instant_client_dir\"" >> $2/export

  export OCI_INC_DIR=$oci_inc
  export OCI_LIB_DIR=$oracle_instant_client_dir
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+LD_LIBRARY_PATH:}$oracle_instant_client_dir

  info "Done installing OCI8."
}
