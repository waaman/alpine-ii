# alpine-ii

ii IRC Client on Alpine 3.16 based image - https://tools.suckless.org/ii/

Use the docker-compose.yml on this repo to start a container.
When started ii join the IRC server and creates a folder inside **/app/servers/**.
After that an echo command is send to the FIFO in file of this server's folder to join the chan asked.