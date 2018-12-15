#!/bin/bash

#connect to GLUA Ubuntu Mirrors via ftp and list all available releases

ftp -in  glua.ua.pt <<EOF
user anonymous
cd pub/ubuntu-releases
ls -l output
quit
EOF

# Filtering the existing releases by name
awk '{print $11}' output>output1
uniq output1>output
sed '/^[[:space:]]*$/d' output >output1
sed '/^\.*$/d' output1 >output
sed '/^precise*$/d' output >output1


#text with the name of the release installed
$(lsb_release -c>output2)
awk '{print $2}' output2>output3
installed_release=`cat output3`
echo $installed_release

#checking whether the release installed is available in our mirrors or not
if [[ "$installed_release" =~ $(echo ^\($(paste -sd'|' output1)\)$) ]]; then # adapted from https://unix.stackexchange.com/a/111518
 echo "Release disponível nos mirrors"
else
 echo "Release não disponível nos mirrors"
 rm output*;
 exit 1
fi



text="###### GLUA Ubuntu Main Repos
deb http://glua.ua.pt/pub/ubuntu/ ""$installed_release"" main restricted universe multiverse
deb-src http://glua.ua.pt/pub/ubuntu/ ""$installed_release"" main restricted universe multiverse
###### GLUA Ubuntu Update Repos
deb http://glua.ua.pt/pub/ubuntu/ ""$installed_release""-security main restricted universe multiverse
deb http://glua.ua.pt/pub/ubuntu/ ""$installed_release""-updates main restricted universe multiverse
deb-src http://glua.ua.pt/pub/ubuntu/ ""$installed_release""-security main restricted universe multiverse
deb-src http://glua.ua.pt/pub/ubuntu/ ""$installed_release""-updates main restricted universe multiverse";

echo $text

PID=$$;

if ! grep -q "glua.ua.pt" /etc/apt/sources.list; then
    echo "$text" > /tmp/$PID;
    cat /etc/apt/sources.list >> /tmp/$PID;
    mv /tmp/$PID /etc/apt/sources.list;
    apt update;
fi

rm output*
