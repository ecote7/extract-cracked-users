#!/bin/bash
# Retrieve user accounts from an Active Directory dump file (in either CME or NXC format), compare them with another file containing cracked NT hashes (one per line), and display statistics.

# Usage example : ./extract-cracked-users.sh AD-Dump.ntds cracked-hashes.txt

# Note: This script is provided as is and has not been tested.

if [ $# -lt 2 ]
then
	echo -e "Make sure you provide at least 2 files as arguments."
	echo -e "The 1st file is the DCSync dump (CME/NXC format) and the 2nd one is the file containing NT hashes (one per line)."
	echo -e "Usage example : ./extract-cracked-users.sh AD-Dump.ntds cracked-hashes.txt"
	exit
fi

hash=$(sort -u $2)
nb=0
users=""
> output.txt

for h in $hash; do
	users=$(cat $1 |grep -i $h|cut -d ":" -f 1) 
	echo $users |sort -u >> output.txt
	let nb=nb+$(cat $1 |grep -i $h|cut -d ":" -f 1|wc -l) 
done

total=$(wc -l $1|cut -d " " -f 1)
percentage=$(echo $nb $total | awk '{print $1/$2*100}')
echo "$nb hash(es) have been cracked on $total ($percentage%), see output.txt for users list."
