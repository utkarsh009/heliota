# Project Heliota
![Project Cover](https://i.imgur.com/RjLkxlg.png)
## Introduction
**Disclaimer**: I have not put any malicious code in any of the files. If you end up losing your funds because of your own carelessness (like using online seed generator, forgetting your seed etc.), then I'm not responsible for it. <br>

1. Please write down your seed/password on a piece of paper and store it in a safe location. If you lose your seed, you will not be able to access your funds, because Heliota wallet needs you to enter your seed everytime you launch it and verifies it against the encrypted seed, which can only be decrypted by using your seed.
2. Please test the new Local Proof of work feature with addresses having small balances, like 10 or 20 iotas and let others know about it. So far, I have only tested it myself.
3. Local PoW feature is only available for Linux and Mac users who have a 64-bit intel or AMD (x86_64/amd64 architecture) processor.
4. This commit introduces some new options (see commit message) and has removed the `Replay all unconfirmed Transactions` because it creates unnecessary reattachments everytime you choose it. Instead, now you can reattach using the bundle hash.
<hr><br>

**NOTE: This commit breaks compatibility with previous commits to some extent. Either generate new wallet using your previous seed (you will retain all your balance, just in case you're worried) or insert a `doLocalPoW: 1,` (as depicted in the code block below) in the config file after opening the wallet (when the config file gets decrypted).**

```
{
	'provider': 'YOUR_PROVIDER_HERE',
	doLocalPoW: 1,
	minWeightMagnitude: 14,
	"wallet_name": {
                databaseFile: "database-wallet_name.db",
                persistentDatabaseFile: "persistent-database-wallet_name.db,
                addressIndexNewAddressStart: 0,
                addressIndexSeachBalancesStart: 0,
                addressSecurityLevel: 2,
                debugLevel: 3
}
```

**PS: Don't Forget the `,` after the config option.**
<hr><br>
Heliota is a secure, lightweight, cross-platform and architecture independent wallet for Iota. It is designed keeping simplicity and functionality in mind. If your machine runs Linux/macOS/Windows, it will most probably run Heliota, be it the latest and greatest, tech has to offer, or a low power Raspberry Pi.<br>
All you need for running this wallet are:
1. `node.js`, which you can probably install via your package manager.
2. Some `node.js` modules, which will be discussed later on.
3. `zenity`, which is available by default on `gnome`, `cinnamon` and `unity` desktops. If it isn't already installed, please install it via your package manager.
4. `openssl`, which should also be installed by default.

## Prerequisites
1. Install `node.js` (Version >= 8.0.0) either via you package manager or form [here](https://nodejs.org/en/download/).
2. Install `zenity` and `openssl`, if not already installed.
3. Download the zip file and extract it to a suitable location.
4. Open `Terminal` and navigate to the location where you extracted the the zip file.
```
cd /path/to/heliota
```
5. Enter the following commands in the terminal:
```
npm install iota.lib.js nedb
```
6. [Click here](https://iota.dance/nodes/) and choose a node (web/IP address) which has PoW enabled (there is a ✅ present under the PoW column for all such nodes). If your device supports Local PoW (64-bit intel or AMD CPUs), then you can choose any working node.

## Special prerequisites section for Windows users
In addition to the above prerequisites, you need to have the following:
1. Download cygwin setup from [here](https://cygwin.com/install.html)
2. Install it and while selecting the packages, search for, and check the following for installation: `zenity`, `xorg-server`, `xinit` and `xlaunch`.
3. Find the location where you installed node.js. Lets assume that you installed it in `D:\Program Files\nodejs`.
4. Open up Cygwin from the desktop shortcut and enter the following command (based on the location of nodejs):
```
echo 'export PATH=$PATH:/cygdrive/d/Program\ Files/nodejs'>>~/.bash_profile
```
5. Close the cygwin and search for Xwin Server in the search box of windows taskbar
![Windows1](https://i.imgur.com/zRBWAgu.png)
6. Now as depicted in the following screenshot, select xterm from the notification area and navigate to the location of heliota wallet and execute it. (If heliota wallet is located in `D:\heliota`, the location for cygwin will be `/cygdrive/d/heliota`)
```
cd /cygdrive/d/heliota
./heliota.sh
```
![Windows2](https://i.imgur.com/DzimV6Q.png)

## Special prerequisites section for macOS users
In addition to the above prerequisites, you need to have the following:
1. Download `macports` .pkg file from [here](https://www.macports.org/install.php) and install it.
2. Download `xquartz` .dmg file from [here](https://www.xquartz.org) and install it.
3. Open a terminal window and type in the following commands:
```
port -v install zenity
```
4. After the previous step is finished, type this command in the terminal:
```
echo 'export PATH=$PATH:/opt/local/bin'>>~/.bash_profile
```
5. Search for `xquartz` in launchpad and run it.
6. Navigate to the location where you extracted the zip file.
```
cd /path/to/heliota
```
7. Execute the shell script by typing this command (and skip the installation section):
```
./heliota.sh
```
**Note**: It doesn't look visually appealing on macOS, but it works. I'll see what can be done about the looks, in case enough users care about it.

## Installation
After you're done with the prerequisites, double-click on `heliota.sh` and enjoy using the wallet.
**NOTE**: If you're using the `heliota` for the first time, you'll be prompted with a dialog to create a new wallet. In addition, you also need to enter the seed for a particular wallet everytime you open Heliota wallet. This is done for security purposes. Heliota wallet doesn't store your seed, in decrypted form on the disk, which makes it highly secure.

Note:
1. You can test an address by sending 0 iota to it and search for that address in [The Tangle Explorer](https://thetangle.org). The transaction should get confirmed after some time.
2. For information on setting up a full node, [Click Here](https://github.com/MichaelSchwab/iota-commandline-wallet).
3. For setting up `iotaproxy`, [Click Here](https://github.com/TimSamshuijzen/iotaproxy).

## TODO
- [x] Added Local PoW support for x86_64/amd64.
- [x] Present the user with a list of available wallets.
- [x] Allow the user to use the same wallet file with different configurations.
- [x] Use the seed to protect the wallet, everytime someone wants to open it.
- [x] Allow the user to create new wallet from GUI.
- [x] Encrypt the seed in config file, that was stored as plain text, and store it elsewhere.
- [x] Encrypt all the database and config files, which are decrypted only when you use the wallet.
- [x] Create a wiki section for how to set up `zenity` in macOS, after which, this should be usable on that too.
- [x] Extend this project to Windows as well.

## Screenshots
![Screenshot1](https://i.imgur.com/Wb9m0mo.png)
![Screenshot2](https://i.imgur.com/SuZ6YwS.png)
![Screenshot3](https://i.imgur.com/Vtw1nfh.png)
![Screenshot4](https://i.imgur.com/PY1WhYb.png)
![Screenshot5](https://i.imgur.com/yG9nfFA.png)
![Screenshot6](https://i.imgur.com/7Wf8UfC.png)
![Screenshot7](https://i.imgur.com/yluTds6.png)
![Screenshot8](https://i.imgur.com/zhDsZWq.png)
![Screenshot9](https://i.imgur.com/WG6hoB7.png)
![Screenshot10](https://i.imgur.com/VcwJGNi.png)

**Note**: Please do not send iotas to any of the above addresses. This seed was just created by me for experimenting.
