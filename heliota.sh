#!/bin/bash
flag=1
wallet_program="my-wallet.js"
wallet=`node $wallet_program my-wallet ShowWallets`
wallet=`echo $wallet | \
sed 's/ /\'$'\n''/g' | sed '/provider/d;/minWeightMagnitude/d' | \
zenity --list --title="Wallet Selection" --width=400 --column="a" \
--hide-header --text="Choose a wallet from the list"`
if [ "$wallet" = "" ]
then
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
 "Replay all unconfirmed Transactions for an Address"\
 "Automatic Replay"\
 "Show Database"\
 "Exit" )
cmdList=()
for (( i = 0; i < "${#cmdListActual[@]}"; ++i ))
do
  cmdList[2*i]=FALSE
  cmdList[2*i + 1]="${cmdListActual[i]}"
done
cmdList[0]=TRUE
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
      output=`node $wallet_program $wallet Transfer $address $amount`
      `echo $output | grep failed` || `echo $output | awk -F " " \
      '{print $1;print $2}' | awk -F ":" '{print $1"\t";print $2}' | zenity \
      --title="Transaction succeeded" --list --width=800  --hide-header \
      --column="a" --column="b"`
      `echo $output | grep failed` && zenity --title="Error" --error \
      --width=200  --text="Transfer Failed"
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
    ${cmdList[17]}) address=`zenity --width=800 --title="Address Selection" \
    --entry --text="Enter an Address"`
    [ "$address" = "" ] && continue
    output=`node $wallet_program $wallet Replay $address`
    zenity --width=200 --title="Replay Info" --info --text=$output
    ;;
    ${cmdList[21]}) output=`node $wallet_program $wallet ShowEntireDB`
    echo $output | sed 's/ /\'$'\n''/g' | awk -F ":" '{print $2}' | zenity \
    --list --column="index" --column="address" --column="balance" \
    --column="status" --width=1100 --height=500 --title="Address Database" \
    --text=""
    ;;
    ""|"Exit") flag=0;;
    *) zenity --width=200 --info --text="Not Yet Implemented!";;
  esac
done
