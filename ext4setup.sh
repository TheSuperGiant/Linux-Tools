#!/usr/bin/env bash
curl -L URL |
sed -n '
	/^error[[:space:]]*()/,/^}/p
	/^ext4setup[[:space:]]*()/,/^}/p
'
ext4setup