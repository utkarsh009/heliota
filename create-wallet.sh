#!/bin/bash
name=`zenity --entry --title="Create Wallet Name" --text="Enter the name of \
the wallet.\nHint: Wallet names don't start with a '.' character." --width=400`
[ "$name" = "" ] && exit 1
[ -f "Wallets/"$name".js" ] && exit 2
[ "${name:0:1}" = "." ] && exit 3
provider=`zenity --entry --title="Create Wallet Name" --text="Enter a node. \
\nHint: Visit https://iota.dance/nodes for more info." --width=400`
[ "$provider" = "" ] && exit 4
seed=`zenity --entry --title="Create Wallet Name" --text="Enter a seed for the \
wallet.\nHint: Seeds (i.e. your PASSWORD) are 81 character long and contain \
UPPER CASE alphabets and '9's" --width=800`
[ "$seed" = "" ] && exit 5
[[ "$seed" =~ [^A-Z9]+ ]] && exit 6
[ "${#seed}" -ne 81 ] && exit 7
[ -d Passwords ] || mkdir Passwords
[ -d Wallets ] || mkdir Wallets
exec 3<<<"$seed"; exec 4<<<"$seed"
openssl enc -e -aes-256-cbc -pass fd:3 -in <(cat <&4) -out Passwords/$name.pass
echo "module.exports = {
	'provider': '$provider',
	doLocalPoW: 1,
	minWeightMagnitude: 14,
	\"$name\": {
                databaseFile: \"database-$name-wallet.db\",
                persistentDatabaseFile: \"persistent-database-$name-wallet.db\",
                addressIndexNewAddressStart: 0,
                addressIndexSeachBalancesStart: 0,
                addressSecurityLevel: 2,
                debugLevel: 3
	}
};">Wallets/$name.js
exec 3<<<"$seed"
openssl enc -e -aes-256-cbc -pass fd:3 -in Wallets/$name.js -out Wallets/$name.utk | \
zenity --progress --pulsate --title="Encrypting" --auto-close --no-cancel \
--text="Please wait while Heliota encrypts your wallet configuration."
rm Wallets/$name.js
exit 0
