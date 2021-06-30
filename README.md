# crontab-admin
Linux crontab admin shell


## Usage
```sh
cron='* * * * * /path/to/watch.sh /path/to/target' #your cron
cron='* * * * *' '/path/to/watch.sh' '/path/to/target' #or your cron
```
list crons
```sh
./crontadm.sh l
```
add cron
```sh
./crontadm.sh add $cron
```
remove cron
```sh
/path/to/crontadm.sh rm $cron
```