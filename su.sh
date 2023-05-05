if [ "$(whoami)" != "root" ]
then
    echo $1 | sudo -S su
    ls
fi