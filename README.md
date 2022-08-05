
# alpine-ii

ii IRC Client on Alpine 3.16 based image - https://tools.suckless.org/ii/

Use the docker-compose.yml on this repo to start a container.
When started ii join the IRC server and creates a folder inside **/app/servers/**.
After that an echo command is send to the FIFO in file of this server's folder to join the chan asked.

When connected on your chan you can send and read messages.

## Usage when connected

 When ii is connected you can echo your message to the target chan from host. 
 The /app volume is mapped to /home/alpine/appdata/ii for me.
 By example this is my **/home/alpine/appdata/ii/servers/** content :
>  └── 192.168.1.43

>     ├── #test

>     │   ├── in

>     │   └── out

>     ├── in

>     └── out
>     
**192.168.1.43** is the host/ip of my IRC server and ii joined the **#test** channel.
Inside the **#test** folder there are 2 files representing 2 ways of message stream to and from the chan itself.

The **in** file is a FIFO file where you pipe your echo command to send message.
The **out** file is all messages received from the channe.

**To send a message in this example**, from the host i send:

    echo "My message to the channel, enjoy!" > /home/alpine/appdata/ii/servers/192.168.1.43/#test/in

**To read messages from the channel in this example** i read the file:

> /home/alpine/appdata/ii/servers/192.168.1.43/#test/out
