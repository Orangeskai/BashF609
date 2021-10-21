#!/bin/bash
# Source_code = https://gist.github.com/ali-essam/80b58ea170051a96108b5f320754564f
# Forked_source = https://gist.github.com/djhtml/a005858cd5206e549fa2e1290c3906d0
# Remoded again by me = https://github.com/orangeskai 
#V.1

########################################
# Parameters                           #
########################################
Router_Ip='192.0.1.1'
Username='user'
Password='user'


########################################
# Functions                            #
########################################

#checking if package installed
OUTPUT=$(cat /etc/*release)
REQUIRED_PKG="recode"
PKG=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null| grep "install ok installed")

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit

elif  echo $OUTPUT | grep -q "CentOS Linux 7" ; then
    echo -e "\nDetecting Centos 7...\n"
    yum install wget curl -y 1> /dev/null
    echo Checking for $REQUIRED_PKG: $PKG
          if [ "" = "$PKG" ]; then
              echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
              yum install $REQUIRED_PKG wget curl -y 1> /dev/null
          fi
elif echo $OUTPUT | grep -q "CentOS Linux 8" ; then
     echo -e "\nDetecting Centos 8...\n"
     yum install wget curl -y 1> /dev/null
     echo Checking for $REQUIRED_PKG: $PKG
          if [ "" = "$PKG" ]; then
              echo -e "\nDetecting Centos 8...\n"
              echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
              yum install $REQUIRED_PKG wget curl -y 1> /dev/null
          fi
elif echo $OUTPUT | grep -q "Ubuntu 18.04" ; then
     echo -e "\nDetecting Ubuntu 18.04...\n"
     apt install -y -qq -y wget curl &> /dev/null
     echo Checking for $REQUIRED_PKG: $PKG
          if [ "" = "$PKG" ]; then
              echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
              apt install -y -qq -y $REQUIRED_PKG wget curl &> /dev/null
          fi
elif echo $OUTPUT | grep -q "Ubuntu 20.04" ; then
          echo -e "\nDetecting Ubuntu 20.04...\n"
          apt install -y -qq -y wget curl &> /dev/null
          echo Checking for $REQUIRED_PKG: $PKG
               if [ "" = "$PKG" ]; then
                   echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
                   apt install -y -qq -y $REQUIRED_PKG wget curl &> /dev/null
               fi
elif echo $OUTPUT | grep -q "Kali *" ; then
          echo -e "\nDetecting Kali Linux...\n"
          apt install -y -qq -y wget curl &> /dev/null
          echo Checking for $REQUIRED_PKG: $PKG
               if [ "" = "$PKG" ]; then
                   echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
                   apt install -y -qq -y $REQUIRED_PKG wget curl &> /dev/null
               fi
elif echo $OUTPUT | grep -q "Debian *" ; then
          echo -e "\nDetecting Debian...\n"
          apt install -y -qq -y wget curl &> /dev/null
          echo Checking for $REQUIRED_PKG: $PKG
               if [ "" = "$PKG" ]; then
                   echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
                   apt install -y -qq -y $REQUIRED_PKG wget curl &> /dev/null
               fi
else

                echo -e "\nUnable to detect your OS...\n"
                echo -e "\nThis script is only supported on Ubuntu 18.04, Ubuntu 20.04, kali linux, CentOS 7.x and CentOS 8.x..."
                echo -e "\nYou cannot use the connection name !!!"
                echo -e "\nOr install manually ex : apt get install recode\n"
fi

# color message
function message {
	echo -e "\e[94m${@}\e[0m"
}


# debug message
function dbg_msg {
	echo -e "\e[90m${@}\e[0m"
}


# error message
function error {
	>&2 echo -e "\e[31m${@}\e[0m"
}


# login function
function login {
	# save name of return variable
	local  __resultvar=$1


	# get login page to fetch login token
	local FRMTOKEN=$( \
		curl -s "http://${Router_Ip}/" \
			--cookie '_TESTCOOKIESUPPORT=1' \
			-H "Host: ${Router_Ip}" \
			-H 'Connection: keep-alive' \
			-H 'Cache-Control: max-age=0' \
			-H 'Upgrade-Insecure-Requests: 1' \
			-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
			-H 'Accept-Encoding: gzip, deflate' \
			-H 'Accept-Language: en-US,en;q=0.8' \
			--compressed \
			| grep "\"Frm_Logintoken\"" | grep -o "[0-9]*" \
	)

#	dbg_msg "Frm_Logintoken=$FRMTOKEN"


	# generate random number between 10000000 and 10032767
	RNDNUM=$((RANDOM + 10000000))
#	dbg_msg "UserRandomNum=$RNDNUM"

	# hash password + rnd num (SHA256)
	PWDHASH=$(echo -n "${Password}${RNDNUM}" | sha256sum | grep -P -o -i "^[0-9a-f]+")

	# concat HTTP POST data
	POSTDATA="action=login&Username=${Username}&Password=${PWDHASH}&Frm_Logintoken=${FRMTOKEN}&UserRandomNum=${RNDNUM}"
#	dbg_msg "POST_DATA: ${POSTDATA}"


	# login with HTTP POST and get cookie SID
	local COOKIESID=$( \
		curl -s -v "http://${Router_Ip}/" \
			--cookie '_TESTCOOKIESUPPORT=1' \
			-H "Host: ${Router_Ip}" \
			-H 'Connection: keep-alive' \
			-H 'Cache-Control: max-age=0' \
			-H 'Upgrade-Insecure-Requests: 1' \
			-H "Origin: http://${Router_Ip}" \
			-H 'Content-Type: application/x-www-form-urlencoded' \
			-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
			-H "Referer: http://${Router_Ip}/" \
			-H 'Accept-Encoding: gzip, deflate' \
			-H 'Accept-Language: en-US,en;q=0.8' \
			--compressed \
			--data "${POSTDATA}" \
			2>&1 | grep -o -P -e "(?<=SID=)[0-9a-fA-F]+" \
	)

#	dbg_msg "Cookie SID=${COOKIESID}"

	# set return value
	eval $__resultvar="'$COOKIESID'"
}

# get session token
function get_token {
	# save name of return variable
	local  __resultvar=$1

	# get reboot page and fetch session token
	local SESSION_TOKEN=$( \
		curl -s "http://${Router_Ip}/getpage.gch?pid=1002&nextpage=manager_dev_conf_t.gch" \
			--cookie "_TESTCOOKIESUPPORT=1; SID=${SID}" \
			-H "Host: ${Router_Ip}" \
			-H 'Connection: keep-alive' \
			-H 'Upgrade-Insecure-Requests: 1' \
			-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
			-H 'Accept-Encoding: gzip, deflate' \
			-H 'Accept-Language: en-US,en;q=0.8' \
			--compressed | grep -o -P -e "(?<=session_token = \")[0-9]+" \
	)

	# set return value
	eval $__resultvar="'$SESSION_TOKEN'"
}

# get session token
function get_token {
	# save name of return variable
	local  __resultvar=$1

	# get reboot page and fetch session token
	local SESSION_TOKEN=$( \
		curl -s "http://${Router_Ip}/getpage.gch?pid=1002&nextpage=IPv46_status_wan2_if_t.gch" \
			--cookie "_TESTCOOKIESUPPORT=1; SID=${SID}" \
			-H "Host: ${Router_Ip}" \
			-H 'Connection: keep-alive' \
			-H 'Upgrade-Insecure-Requests: 1' \
			-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
			-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
			-H 'Accept-Encoding: gzip, deflate' \
			-H 'Accept-Language: en-US,en;q=0.8' \
			--compressed | grep -o -P -e "(?<=session_token = \")[0-9]+" \
	)

	# set return value
	eval $__resultvar="'$SESSION_TOKEN'"
}

# reboot router
function reboot_router {
	# set HTTP POST data
	POSTDATA="IF_ACTION=devrestart&IF_ERRORSTR=SUCC&IF_ERRORPARAM=SUCC&IF_ERRORTYPE=-1&flag=1&_SESSION_TOKEN=$1"
#	dbg_msg "POST_DATA: ${POSTDATA}"


	# reboot with HTTP POST
	curl -s "http://${Router_Ip}/getpage.gch?pid=1002&nextpage=manager_dev_conf_t.gch" \
		--cookie "_TESTCOOKIESUPPORT=1; SID=${SID}" \
		-H "Host: ${Router_Ip}" \
		-H 'Connection: keep-alive' \
		-H 'Upgrade-Insecure-Requests: 1' \
		-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
		-H 'Accept-Encoding: gzip, deflate' \
		-H 'Accept-Language: en-US,en;q=0.8' \
		--compressed \
		--data "${POSTDATA}" \
		> /dev/null
}



# try to login with timeout
TM=1
TM_MAX=16
while [ -z "$SID" ]
do
	# try to login
	message "Logging in..."
	login SID
#	dbg_msg "SID: $SID"

	# exit or timeout if login was unsuccessful
	if [ -z "$SID" ]; then
		# exit when max tries reached
		if [ $TM -gt $TM_MAX ]; then
			error ""
			error "Cannot login, exiting."
			exit 1
		fi

		# sleep and double timeout
		message ""
		message "Retrying Login In $TM seconds..."
		sleep $TM
		TM=$((TM * 2))
	fi
done

message "Successful login."


# get session token
get_token TOKEN
message "Get session token..."
#dbg_msg "TOKEN: $TOKEN"


# reboot the router
message "Restarting the router..."
reboot_router $TOKEN