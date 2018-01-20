# Project Heliota
![Project Cover](https://i.imgur.com/RjLkxlg.png)
## Introduction
**Disclaimer**: I am not responsible for any lost funds or Damage caused. Use at your own risk.<hr><br>
Heliota is a lightweight, architecture independent wallet for Iota. It is designed keeping simplicity and functionality in mind. If your machine runs Linux, it will most probably run Heliota, be it the latest and greatest, tech has to offer, or a low power Raspberry Pi.<br>
All you need for running this wallet are:
1. `node.js`, which you can probably install via your package manager.
2. Some `node.js` modules, which will be discussed later on.
3. `zenity`, which is available by default on `gnome`, `cinnamon` and `unity` desktops. If it isn't already installed, please install it via your package manager.

## Prerequisites
1. Install `node.js` (Version >= 8.0.0) either via you package manager or form [here](https://nodejs.org/en/download/).
2. Install `zenity`, if not already installed.
3. Download the zip file and extract it to a suitable location.
4. Open `Terminal` and navigate to the location where you extracted the the zip file.
```
cd /path/to/heliota
```
5. Enter the following commands in the terminal:
```
npm install iota.lib.js nedb
```
6. [Click here](https://iota.dance/nodes/) and choose a node (web/IP address) which has PoW enabled (there is a ✅ present under the PoW column for all such nodes).
7. Open `iota-wallet-config.js`.
8. Replace `http://localhost:14265` with the node (web/IP address) that you selected in the previous step. The `http://localhost:14265` address is the default for [`iotaproxy`](https://github.com/TimSamshuijzen/iotaproxy). I'd recommend setting it up if you plan to use this wallet too often, although, it's not necessary.
9. Further you will see three sections, namely, `my-wallet`, `alices-wallet` and `bobs-wallet`. These are the names of the wallets that you'll be presented with, at startup. **Do not remove or rename the `my-wallet` section.** You can rename `alices-wallet` or `bobs-wallet` to anything you'd like to. You can even create a new section that looks like any of the three sections, with an appropriate name.
10. Once you have chosen the name of your wallet, change the `seed` section accordingly. Do not remove the `""`, just place your seed inside `""`. Your seed is the password that you use to unlock all the addresses (and iota stored in them) that you own. Your seed should be 81 characters long and can consist of only `UPPER CASE ENGLISH ALPHABET`s and `9`s.
11. Save the file and close it.

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

Note:
1. You can test an address by sending 0 iota to it and search for that address in [The Tangle Explorer](https://thetangle.org). The transaction should get confirmed after some time.
2. For information on setting up a full node, [Click Here](https://github.com/MichaelSchwab/iota-commandline-wallet).
3. For setting up `iotaproxy`, [Click Here](https://github.com/TimSamshuijzen/iotaproxy).

## TODO
- [x] Present the user with a list of available wallets.
- [x] Allow the user to use the same wallet file with different configurations.
- [ ] Use an additional password to protect the wallet.
- [ ] Allow the user to create new wallet from GUI.
- [ ] Encrypt all the important data in config file that is now stored as plain text.
- [ ] Automatically update balance at each startup, if enough users demand for it.
- [ ] Integrate `iotaproxy` for doing PoW locally, or at least, create a wiki for how to use it in conjunction with this wallet.
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
![Screenshot10](https://i.imgur.com/U67Fudc.png)

**Note**: Please do not send iotas to any of the above addresses. This seed was just created by me for experimenting.
