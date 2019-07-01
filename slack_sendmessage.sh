#!/bin/bash

# Title : Send a message to slack
# Description : Send a message to slack
# How to Use : ./slack_sendmessage.sh [message]
# Maker : LT
# Date : 2018.12.12.



### Set variable
WEBHOOKURL="[WebHook URL : https://hooks.slack.com/services/~ ]"
CHANNEL="[#CHANNEL]"
SENDER="[Sender Name]"
ICON="[:icon:]"
# icon : https://www.webpagefx.com/tools/emoji-cheat-sheet/

### Check $1
if [ -n "$1" ]; then
	### Send Message
	MSG=$1
	curl -X POST --data-urlencode \
		   	"payload={\"channel\": \"$CHANNEL\", \
		   	\"username\": \"$SENDER\", \
		   	\"text\": \"$MSG\", \
		   	\"icon_emoji\": \":$ICON:\"}" \
			$WEBHOOKURL
else
	echo "* Usage : $0 [message]"
fi
