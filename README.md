# occ-automate
a bash script to automate running nextcloud occ command line tools.

The nextcloud occ comand is hard to remember the format for the whole thing. This bash script helps format the commands.

The occ command need to be run as the webserver user, for me that is www-data. 

Then occ is a php file and needs php to run it. sometimes you may need to use a exact path to php but mostly you shouldn't have to. 


Test that with running this at the command line "php -v"
It should show you the php version you have installed and proove that it is in your system path so you can run it from anywhere.
then the path to the occ file in my case needs to be in the command.

for me the occ file is located in :/var/www/html/occ


so my command looks like this.
sudo -u www-data php /var/www/html/occ
then add the options like this.

I put my two files in my user root dir.
./occ-command.sh list
./occ-command.sh files:scan

don't for get to run "chmod +x occ-command.sh" first
