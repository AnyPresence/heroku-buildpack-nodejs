install_ap_binary_dependencies() {
  echo "arg one is $1"
  if [ -f $1/.oracle.ini ]; then
    install_oci8
  fi
}

install_oci8() {
  echo "Installing Oracle OCI8 dependencies"

  s3bucket="https://s3.amazonaws.com/chameleon-heroku-assets"
  oracle_instant_client_tgz="$s3bucket/instantclient_11_2_with_libaio_oci8.tar.gz"
  oracle_instant_client_dir="$1/vendor/oracle_instantclient"

  echo "Creating directory"
  mkdir -p $oracle_instant_client_dir

  echo "Downloading and installing Oracle binaries from $s3bucket"
  curl $oracle_instant_client_tgz -s -o - | tar xzf - -C $oracle_instant_client_dir

  echo "Dir is now $oracle_instant_client_dir"

  LD_LIBRARY_PATH=$oracle_instant_client_dir:$LD_LIBRARY_PATH
  OCI_LIB_DIR=$oracle_instant_client_dir
  OCI_INC_DIR=$oracle_instant_client_dir/sdk/include
}
