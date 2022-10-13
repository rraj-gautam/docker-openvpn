#syntaxt: ./add-remove-user.sh add_user username
USER=$1
OVPN_DATA=openvpn-data

add_user(){
  echo "creating user: $USER"
  docker run -v  $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $USER  nopass
  docker run -v  $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $1 > $USER.ovpn
  sudo chmod 755 $USER.ovpn
  #aws s3 sync . s3://openvpn-clients/
}
remove_user(){
  echo "deleting user: $USER"
  docker run --rm -it -v $OVPN_DATA:/etc/openvpn kylemanna/openvpn ovpn_revokeclient $USER remove
  rm -f $USER.ovpn
  # aws s3 sync --delete . s3://openvpn-clients/
}

check_syntax(){
# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi

#check the arguments
if [ $# -ne 1 ]; then
  echo "Usage: $0  ./script_name function_name username"
  exit 2
fi
}

check_syntax()
