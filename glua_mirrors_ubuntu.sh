#####################################################################
#               Grupo Linux da Universidade de Aveiro               #
#                                                                   #
#  Script para instalação automática dos mirrors de ubuntu (bionic) #
#####################################################################

text="###### GLUA Ubuntu Main Repos
deb http://glua.ua.pt/pub/ubuntu/ bionic main restricted universe multiverse 
deb-src http://glua.ua.pt/pub/ubuntu/ bionic main restricted universe multiverse 
###### GLUA Ubuntu Update Repos
deb http://glua.ua.pt/pub/ubuntu/ bionic-security main restricted universe multiverse 
deb http://glua.ua.pt/pub/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://glua.ua.pt/pub/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://glua.ua.pt/pub/ubuntu/ bionic-updates main restricted universe multiverse
";

PID=$$;

if ! grep -q "glua.ua.pt" /etc/apt/sources.list; then
    echo "$text" > /tmp/$PID;
    cat /etc/apt/sources.list >> /tmp/$PID;
    mv /tmp/$PID /etc/apt/sources.list;
    apt update;
fi