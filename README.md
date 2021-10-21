# Bash F609

## 🤔 Concept
**This repo is automatically installed anything 😐 hopefully**<br />
Basically this script will getting a information or restart your modem<br />

### ⚠️ WARNING
This script only run in **Ubuntu 18.04, 20.04, kali linux, centos 7,8**<br />
FOR OS NOT LISTED IN ABOVE I RECOMMEND TO INSTALL THIS AND MODIFIED THIS<br />
CHANGE IN THE SCRIPT :
- GetIp.sh = Remove from [#checking if package installed / line 18](https://github.com/Orangeskai/BashF609/blob/9f6bfff21e735de53558d8b6c62f85fc5c7e3a24/GetIp.sh#L18) to [fi / line 82](https://github.com/Orangeskai/BashF609/blob/9f6bfff21e735de53558d8b6c62f85fc5c7e3a24/GetIp.sh#L82)
- Reboot.sh = Makesure you install **curl** and **wget**

AND INSTALL **recode, curl,wget** Or you cannot use this script and use this [parse](https://github.com/Orangeskai/BashF609/blob/0cf06d42bb0e1c89680e5c3fd4b7bd5cf8521726/GetIp.sh#L221)


### ✍️ How to install this
```script
git clone https://github.com/Orangeskai/BashF609
```
and change in the .sh file like ip and user password or what information you need (expert)<br />
By default it already showing the Connection 1 which include : <br />
IP Version, IP, IPv4 Connection Status, IPv4 Online Duration, Disconnect Reason

### ✨ Run this
```shell
GetIp.sh    ---> Get information
Reboot.sh    ---> Restart Modem
```

### ⁉️ Q&A
1. Why you not include it in the app so it just AIO ????<br />
- Good question because im dumb and kinda busy maybe also lazy

2. I had problem or bug please fix this ASAP<br />
- Sorry im kinda busy also after this maybe im not maintain this script anymore

### 🙏 Thanks for :
The bash version of f609 restarter thx again for the source 
- Fork repo [@djhtml](https://gist.github.com/djhtml/a005858cd5206e549fa2e1290c3906d0) 
- Source Repo [@ali-essam](https://gist.github.com/ali-essam/80b58ea170051a96108b5f320754564f)
