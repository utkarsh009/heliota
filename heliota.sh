#!/bin/bash
export system=`uname`
flag=1
wallet_program="heliota.js"
basename -a `ls Wallets/*.utk` || ./create-wallet.sh
wallet=`basename -a $(ls Wallets/*.utk) | sed 's/ /\'$'\n''/g;s/.utk//g' | \
zenity --list --title="Wallet Selection" --width=400 --column="a" --hide-header \
--text="Choose a wallet from the list"`
if [ "$wallet" = "" ]
then
  exit 1
fi
counter=0
[ -e "Passwords/$wallet.pass" ] || counter=1
if [ "$counter" -eq 1 ]
then
  zenity --error --width=400 --title="Error" \
  --text="Password for this wallet is not available. It might have been deleted."
  exit 1
fi
pass=`zenity --password --title="Seed Verification" --width=800 \
--text="Please Enter the Seed."`
[ "$pass" = "" ] && exit 1
exec 3<<<"$pass"
decpass=`openssl enc -d -aes-256-cbc -pass fd:3 -in Passwords/$wallet.pass`
[ "$pass" = "$decpass" ] || counter=1
if [ "$counter" -eq 1 ]
then
  zenity --error --width=400 --title="Wrong Seed" \
  --text="The seed that you entered is wrong. Exiting Program."
  exit 1
fi
cmdListActual=( "(Re)build Local Database"\
 "Update Database for address currently in use"\
 "Send Amount"\
 "Get a New Address for Receiving"\
 "List all Bundles for an Address"\
 "Get Confirmation State for bundle"\
 "Update Balance"\
 "Show Balance"\
 "Reattach a Bundle"\
 "Create New Wallet"\
 "Show Database"\
 "Change Node"\
 "Show Node"\
 "Show/Change PoW Mode"\
 "Exit" )
cmdList=()
for (( i = 0; i < "${#cmdListActual[@]}"; ++i ))
do
  cmdList[2*i]=FALSE
  cmdList[2*i + 1]="${cmdListActual[i]}"
done
cmdList[0]=TRUE
export pass
if [ ! -f "database-$wallet-wallet.db" ]
then
  exec 3<<<"$pass"
  openssl enc -d -aes-256-cbc -pass fd:3 -in database-$wallet-wallet.utk -out \
  database-$wallet-wallet.db | zenity --progress --pulsate --title="Decrypting" \
  --text="Please wait while Heliota decrypts your database." --auto-close
fi
if [ ! -f "Wallets/$wallet.js" ]
then
  exec 3<<<"$pass"
  openssl enc -d -aes-256-cbc -pass fd:3 -in Wallets/$wallet.utk -out \
  Wallets/$wallet.js | zenity --progress --pulsate --auto-close \
  --title="Decrypting" \
  --text="Please wait while Heliota decrypts your wallet configuration."
fi
content="Content-Type: application/json"
api="X-IOTA-API-Version: 1"
while [ "$flag" -eq 1 ]
do
  cmd=`zenity --title="Heliota Wallet" --width=400 --height=250 --list \
  --radiolist --cancel-label="Quit" --column "Select" --column "Commands" \
  "${cmdList[@]}"`
  case $cmd in
    ${cmdList[1]}) node $wallet_program $wallet SyncAll | zenity --progress \
    --pulsate --auto-close --text="Syncing All..." --title "SyncAll" --no-cancel
    zenity --width=200 --title="Sync Completed" --info \
    --text="Local Database (Re)built"
    ;;
    ${cmdList[3]}) node $wallet_program $wallet Sync | zenity --progress \
    --pulsate --auto-close --text="Syncing ..." --title "Sync" --no-cancel
    zenity --width=200 --title="Database Updated" --info \
    --text="Local Database Updated"
    ;;
    ${cmdList[5]}) address=`zenity --width=800 --title="Address Selection" \
    --entry --text="Enter the destination address"`
    [ "$address" = "" ] && continue
    amount=`zenity --width=200 --title="Amount Selection" \
    --entry --text="Enter the amount"`
    [ "$amount" = "" ] && continue
    bal=`node $wallet_program $wallet ShowBalance | sed "s/[^0-9]//g"`
    if [ $((bal)) -lt $amount ]
    then
      zenity --width=200 --title="Error" --error --text="Insufficent Funds"
    else
      status=`node $wallet_program $wallet getPoWstatus`
      if [ "$status" = "1" ]
      then
        command='{"command": "getTransactionsToApprove", "depth": 5}'
        provider=`node $wallet_program $wallet getProvider`
        ret1=`curl $provider -X POST -H "$content" -H "$api" -d "$command" | \
        awk -F "," '{print $1$2}' | sed 's/{"trunkTransaction":"//;s/""branchTransaction":"//;s/"//g'`
        export trunk="${ret1:0:81}"
        export branch="${ret1:81:81}"
        output=`node $wallet_program $wallet Transfer $address $amount`
        command="{\"command\": \"broadcastTransactions\", \"trytes\": $output}"
        ret2=`curl $provider -X POST -H "$content" -H "$api" -d "$command"`
        echo $ret2 | zenity --text-info --width=800 --height=200 --title="Transaction Results"
      else
        output=`node $wallet_program $wallet Transfer $address $amount`
        echo $output | zenity --text-info --width=800 --height=200 --title="Transaction Results"
      fi
    fi
    ;;
    ${cmdList[7]}) address=`node $wallet_program $wallet GetNewAddress | \
    sed "s/[^A-Z9]//g"`
    zenity --width=200 --title="Address Acquired" --info \
    --text="New Address is $address"
    ;;
    ${cmdList[9]}) address=`zenity --width=800 --title="Address Selection" \
    --entry --text="Enter an Address"`
    [ "$address" = "" ] && continue
    output=`node $wallet_program $wallet GetBundles $address`
    zenity --width=200 --title="Bundles" --info --text=$output
    ;;
    ${cmdList[11]}) bunhash=`zenity --width=800 --title="Enter Bundle" --entry \
    --text="Enter Bundle Hash"`
    [ "$bunhash" = "" ] && continue
    output=`node $wallet_program $wallet GetConfirmationState $bunhash`
    echo $output | sed 's/[{}]//g' | awk -F "," '{print $1;print $2;print $3}' \
    | awk -F ":" '{print $1"\t";print $2}' | \
    sed 's/"//g;s/confirmedTransactionsCount/confirmed transactions count/g' | \
    zenity --width=400 --text="" --title="Confirmation Info" \
    --list --hide-header --column="a" --column="b"
    ;;
    ${cmdList[13]}) output=`node $wallet_program $wallet UpdateBalances`
    zenity --width=200 --title="Balance Updation Info" --info --text=$output
    ;;
    ${cmdList[15]}) bal=`node $wallet_program $wallet ShowBalance | \
    sed "s/[^0-9]//g"`
    zenity --width=200 --title="Balance" --info --text="$wallet has $bal iotas"
    ;;
    ${cmdList[17]}) bunhash=`zenity --width=800 --title="Bundle Selection" \
    --entry --text="Enter a Bundle Hash"`
    [ "$bunhash" = "" ] && continue
    status=`node $wallet_program $wallet getPoWstatus`
    if [ "$status" = "1" ]
    then
      command='{"command": "getTransactionsToApprove", "depth": 5}'
      provider=`node $wallet_program $wallet getProvider`
      ret1=`curl $provider -X POST -H "$content" -H "$api" -d "$command" | \
      awk -F "," '{print $1$2}' | sed 's/{"trunkTransaction":"//;s/""branchTransaction":"//;s/"//g'`
      export trunk="${ret1:0:81}"
      export branch="${ret1:81:81}"
      output=`node $wallet_program $wallet Replay $bunhash`
      command="{\"command\": \"broadcastTransactions\", \"trytes\": $output}"
      ret2=`curl $provider -X POST -H "$content" -H "$api" -d "$command"`
      echo $ret2 | zenity --text-info --width=800 --height=200 --title="Reattach Information"
    else
      output=`node $wallet_program $wallet Replay $bunhash`
      echo $output | zenity --width=800 --title="Reattach Information" --text-info
    fi
    ;;
    ${cmdList[19]}) ./create-wallet.sh
    output=$?
    case $output in
      1) res="Wallet name cannot be an empty string.";;
      2) res="Wallet already exists. Please choose another name.";;
      3) res="Wallet name cannot start with a '.'";;
      4) res="Node name cannot be an empty string.";;
      5) res="Seed cannot be an empty string.";;
      6) res="The seed is your password. It can only contain UPPER CASE english alphabets and '9's.";;
      7) res="The seed must be 81 characters long.";;
      *) res="A new wallet has been created.";;
    esac
    zenity --info --width=400 --title="Wallet Creation Status" --text="$res"
    ;;
    ${cmdList[21]}) output=`node $wallet_program $wallet ShowEntireDB`
    echo $output | sed 's/ /\'$'\n''/g' | awk -F ":" '{print $2}' | zenity \
    --list --column="index" --column="address" --column="balance" \
    --column="status" --width=1100 --height=500 --title="Address Database" \
    --text=""
    ;;
    ${cmdList[23]}) output=`zenity --entry --width=400 --title="Node Selection" \
    --text="Please Enter a new node."`
    rep="\'provider\': \'$output\'\,"
    sed "2s,.*,"$'\t'"$rep," Wallets/$wallet.js > Wallets/$wallet.js.new
    [ -s "Wallets/$wallet.js.new" ] && mv Wallets/$wallet.js.new Wallets/$wallet.js
    ;;
    ${cmdList[25]}) output=`node $wallet_program $wallet getProvider`
    zenity --info --width=500 --title="Node Information" \
    --text="Your Current node is set to $output"
    ;;
    ${cmdList[27]}) status=`node $wallet_program $wallet getPoWstatus`
    disp=""
    if [ "$status" = "1" ]
    then
      disp="on"
      status=0
    else
      disp="off"
      status=1
    fi
    output=`zenity --list --radiolist --width=300 --height=160 \
    --title="Flip PoW" --text="Local Proof-of-Work is $disp. Do you want to flip it?" \
    --column="Select" --column="Choices" FALSE yes TRUE no`
    if [ "$output" = "yes" ]
    then
      rep="doLocalPoW: $status\,"
      sed "3s,.*,"$'\t'"$rep," Wallets/$wallet.js > Wallets/$wallet.js.new
      [ -s "Wallets/$wallet.js.new" ] && mv Wallets/$wallet.js.new Wallets/$wallet.js
    fi
    ;;
    ""|"Exit") flag=0;;
    *) zenity --width=200 --info --text="Not Yet Implemented!";;
  esac
done
exec 3<<<"$pass"
openssl enc -e -aes-256-cbc -pass fd:3 -in database-$wallet-wallet.db -out \
database-$wallet-wallet.utk | zenity --progress --pulsate --title="Encrypting" \
--text="Please wait while Heliota encrypts your database." --no-cancel \
--auto-close
exec 3<<<"$pass"
openssl enc -e -aes-256-cbc -pass fd:3 -in Wallets/$wallet.js -out Wallets/$wallet.utk | \
zenity --progress --pulsate --title="Encrypting" --auto-close --no-cancel \
--text="Please wait while Heliota encrypts your wallet configuration."
unset pass
rm database-$wallet-wallet.db Wallets/$wallet.js
