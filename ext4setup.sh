#!/usr/bin/env bash
source <(
	curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/functions.sh |
	sed -n '
		/^error[[:space:]]*()/,/^}/p
		/^ext4setup[[:space:]]*()/,/^}/p
	'
)
ext4setup