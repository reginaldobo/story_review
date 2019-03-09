#!/bin/bash
#################################################################
# Key file 
#
CHAVE="/home/keys/key_file.pem"
#
################################################################
#
function menu() {

echo "Options:"
echo "L - List Containers"
echo "D - Deploy Branch"
echo "R - Remove Branch"
echo "S - Sync Database"
echo "Q - Quit"

}
#
################################################################
#
# 
ssh-add -k $CHAVE
clear

while(true)
do
    #clear
    menu

    read choice

    case $choice in
    [lL])
        clear
        echo "Wait..."
        ssh -A ec2-user@bastion_host "ssh ubuntu@instance_ip 'bash ~/scripts/get_links.sh'"
    ;;
    [dD])
        echo "Type a Branch: "
        read branch
        clear    
        echo "Wait..."
        comando="ssh -A ec2-user@bastion_host \"ssh ubuntu@instance_ip 'bash ~/scripts/dockerDeploy.sh $branch'\""
        eval $comando
    ;;
    [rR])
        echo "Type a Branch: "
        read branch
        clear
        echo "Wait..."
        comando="ssh -A ec2-user@bastion_host \"ssh ubuntu@instance_ip 'bash ~/scripts/dockerRemove.sh $branch'\""
        eval $comando
    ;;
    [sS])
        clear
        echo "Wait..."
        ssh -A ec2-user@bastion_host "ssh ubuntu@instance_ip 'bash ~/scripts/sync_prod_db.sh'"
    ;;
    [qQ])
        exit 0
    ;;
    *)
        clear
        echo "Invalid Option!"
    ;;
    esac
done
