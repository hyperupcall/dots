# ({
# 	if [ -z "$XDG_RUNTIME_DIR" ]; then
# 		# If 'XDG_RUNTIME_DIR' is not set, then most likely dbus has not started, which means
# 		# the following commands will not work. This can occur in WSL environments, for example
# 		exit
# 	fi

# 	dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# 	printenv -0 \
# 	| awk '
# 		BEGIN {
# 			RS="\0"
# 			FS="="
# 		}
# 		{
# 			if($1 ~ /^LESS_TERMCAP/) { next }
# 			if($1 ~ /^TIMEFORMAT$/) { next }
# 			if($1 ~ /^_$/) { next }

# 			printf "%s\0", $1
# 		}' \
# 	| xargs -0 systemctl --user import-environment
# } &)
