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

  local oci_inc="${oracle_instant_client_dir}/sdk/include"
  local profile_dir = "${1}/profile"
  mkdir -p "${profile_dir}"
  local profile_file = "${profile_dir}/oci.sh"
  echo "export LD_LIBRARY_PATH=\"\$HOME/vendor/oracle_instantclient:\$LD_LIBRARY_PATH\"" > $profile_file
  echo "export OCI_LIB_DIR=\"\$HOME/vendor/oracle_instantclient\"" >> $profile_file
  echo "export OCI_INC_DIR=\"\$HOME/vendor/oracle_instantclient/sdk/include\"" >> $profile_file

  local export_file = "${2}/export"
  echo "export OCI_INC_DIR=\"${oci_inc}\"" > $export_file
  echo "export OCI_LIB_DIR=\"${oracle_instant_client_dir}\"" >> $export_file
  echo "export LD_LIBRARY_PATH=\"${oracle_instant_client_dir}\"" >> $export_file

  export OCI_INC_DIR="${oci_inc}"
  export OCI_LIB_DIR="${oracle_instant_client_dir}"
  export LD_LIBRARY_PATH="${oracle_instant_client_dir}:${LD_LIBRARY_PATH:-}"

  echo "Done installing OCI8."
}
