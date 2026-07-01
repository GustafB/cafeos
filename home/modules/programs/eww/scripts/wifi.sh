#!/usr/bin/env bash
# Wi-Fi status + selector backend via NetworkManager (nmcli).
case "${1:-status}" in
  status)
    ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')
    [ -z "$ssid" ] && echo "Disconnected" || echo "$ssid"
    ;;

  icon)
    sig=$(nmcli -t -f active,signal dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')
    if   [ -z "$sig" ];        then echo "󰤭"
    elif [ "$sig" -ge 75 ];    then echo "󰤨"
    elif [ "$sig" -ge 50 ];    then echo "󰤥"
    elif [ "$sig" -ge 25 ];    then echo "󰤢"
    else echo "󰤟"; fi
    ;;

  list)
    # Emit a JSON array [{inuse, ssid, signal, security}] sorted by signal.
    # Uses tab-separated multiline output so SSIDs are parsed field-safely;
    # blank SSIDs (hidden networks) are dropped and duplicates de-duped.
    nmcli -m multiline -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan "${2:-no}" 2>/dev/null \
      | jq -R -n -c '
          [ inputs
            | capture("^(?<k>[A-Z-]+):\\s*(?<v>.*)$")
          ] as $rows
          | reduce range(0; ($rows|length)/4) as $i ([];
              . + [ $rows[$i*4:$i*4+4]
                    | { inuse:  (.[0].v == "*"),
                        ssid:   .[1].v,
                        signal: (.[2].v | tonumber? // 0),
                        security: (.[3].v // "") } ])
          | map(select((.ssid | length > 0) and .ssid != "--"))
          | unique_by(.ssid) | sort_by(-.signal)'
    ;;

  scan)       nmcli dev wifi rescan 2>/dev/null ;;
  connect)    nmcli dev wifi connect "$2" ${3:+password "$3"} 2>&1 ;;
  disconnect) nmcli con down id "$2" 2>/dev/null ;;
  toggle)     nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on ;;
esac
