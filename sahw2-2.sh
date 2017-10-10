#! /bin/sh



id=$( dialog --title "學號" --inputbox \
"請輸入你的學號:" 10 30 3>&1 1>&2 2>&3 3>&-)

password=$( dialog  --title  "密碼"  --insecure  \
--passwordbox  "請輸入你的密碼:"  10  30 3>&1 1>&2 2>&3 3>&-)

while true ; do
while true ; do
curl -s -c cookie.txt https://portal.nctu.edu.tw/captcha/pic.php > /dev/null
curl -s -b cookie.txt -o img.png https://portal.nctu.edu.tw/captcha/pitctest/pic.php > /dev/null 
seccode=$(curl -s -F "image=@img.png"  https://nasa.cs.nctu.edu.tw/sap/2017/hw2/captcha-solver/api/)


if echo "$seccode" | grep -q '^[0-9]' ; then
	break
fi

done

response=$(curl -s -b cookie.txt -d "username=$id&password=$password&seccode=$seccode&pwdtype=static&Submit2=Login" https://portal.nctu.edu.tw/portal/chkpas.php?)

x=$(echo "$response" | tr -d "\t" | tr -d "\r" | tr -d " " | tr -d "\n" | tr -d "<")
if echo "$x" | grep -q '^[h]'; then
	break
fi
done

data=$(curl -s -b cookie.txt https://portal.nctu.edu.tw/portal/relay.php?D=cos | node extractFormdata.js)
curl -s -b cookie.txt -c cookie.txt -d "${data}" \
https://course.nctu.edu.tw/index.asp > /dev/null
html=$(curl -s -b cookie.txt https://course.nctu.edu.tw/adSchedule.asp | iconv -f big5 -t utf8)

schedule=$(echo "$html" | sed -n '/><font size="2">/,/</p ' | awk '!/<font COLOR/' | awk '!/<td/' | awk '{gsub("<br>","");print $1}')

sche=$(echo "$schedule" | tr -d "\t" | tr -d " " | tr "\r" " ")


echo "Mon\nTue\nWed\nThu\nFri\nSat\nSun\n$sche" | awk 'BEGIN { mon=".";tue=".";wed=".";thu=".";fri=".";sat=".";sun=".";}{ \
if ( NR % 7 == 1){ mon = ($1 == "")?".":$1; }\
if ( NR % 7 == 2){ tue = ($1 == "")?".":$1; }\
if ( NR % 7 == 3){ wed = ($1 == "")?".":$1; }\
if ( NR % 7 == 4){ thu = ($1 == "")?".":$1; }\
if ( NR % 7 == 5){ fri = ($1 == "")?".":$1; }\
if ( NR % 7 == 6){ sat = ($1 == "")?".":$1; }\
if ( NR % 7 == 0){ sun = ($1 == "")?".":$1; print mon "," tue "," wed "," thu "," fri "," sat "," sun; }\
 }' | column -t -s ','
