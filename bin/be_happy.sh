#!/bin/sh

for i in `ls -1 /usr/local/share/cows/*.cow  | sed 's!\.cow!!'`;
do 
	echo $i;
	 cowsay -f ${i} "$(fortune -a)"; 
done

