#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	set -uo pipefail

	# console_codes(4)

	#   Daniel Crisman's ANSI color chart script from
	#   The Bash Prompt HOWTO: 6.1. Colours
	#   http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
	echo '16 colors'
	T='•••'
	echo -e "         def     40m     41m     42m     43m     44m     45m     46m     47m";
	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
			'1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
			'  36m' '1;36m' '  37m' '1;37m'; do
		FG=${FGs// /}
		echo -en " $FGs \033[$FG  $T  "
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
			do echo -en "${EINS:-} \033[$FG\033[$BG  $T  \033[0m";
		done
		echo
	done

	echo; echo; echo '16 and 256 colors'
	local -a fg
	local -a bg
	for color in {0..255}; do
			fg+=("$(printf "\e[38;5;%sm  %3s  \e[0m" "$color" "$color")")
			bg+=("$(printf "\e[48;5;%sm  %3s  \e[0m" "$color" "$color")")
	done
	for v in fg bg; do
		local -n fgbg="$v"
		for ((i=0; i<4; i++)); do
			printf "%s" "${fgbg[i]}"
		done
		printf "%s%s" "       " "       "
	done
	echo
	for ((i=4; i<${#fg[@]}; i=i+6)); do
		for v in fg bg; do
			local -n fgbg="$v"
			for ((j=0; j<6; j++)); do
				printf "%s" "${fgbg[i+j]}"
			done
		done
		echo
	done

	echo; echo; echo '16 and 256 colors'
	for bgfg in 38 48; do
		for i in {0..16}; do
			printf "\x1b[${bgfg};5;${i}m%3d \e[0m" "$i"
		done
		echo
	done
	echo
	for i in {16..255}; do
		printf "\x1b[38;5;${i}m%3d \e[0m" "${i}"
		if (( (i-15) % 12 == 0 )); then
				for ((j=i-11; j<i+1; j++)); do
					printf "\x1b[48;5;${j}m%3d \e[0m" "$j"
				done
				echo
		fi
	done

	# #Background
	# for clbg in {40..47} {100..107} 49 ; do
	# 	#Foreground
	# 	for clfg in {30..37} {90..97} 39 ; do
	# 		#Formatting
	# 		for attr in 0 1 2 4 5 7 ; do
	# 			#Print the result
	# 			echo -en "\e[${attr};${clbg};${clfg}m color \e[0m"
	# 		done
	# 		echo #Newline
	# 	done
	# done

	echo; echo; echo 'truecolor'
	awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
		s="/\\";
		for (colnum = 0; colnum<term_cols; colnum++) {
			r = 255-(colnum*255/term_cols);
			g = (colnum*510/term_cols);
			b = (colnum*255/term_cols);
			if (g>255) g = 510-g;
			printf "\033[48;2;%d;%d;%dm", r,g,b;
			printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
			printf "%s\033[0m", substr(s,colnum%2+1,1);
		}
		printf "\n";
	}'
}

main "$@"
