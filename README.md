# blueiris-monitor

quick and dirty script that will monitor blue iris api and ensure all of the cameras are recording - exiting 1 if not

## usage script
    ruby monitor.rb --host "foo.com" --user "monitor" --password "monitor" --cameras frontdoor backdoor sidedoor
## usage docker
    docker run --name blueiris-monitor -d --restart=always -e "host=foo.com" -e "user=monitor" -e "password=monitor" -e "cameras=frontdoor backdoor sidedoor" -p 4567:4567 blueiris-monitor
