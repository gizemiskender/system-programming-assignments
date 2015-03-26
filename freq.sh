#/bin/bash

ext="";
ands="";
ors="";

function find_folder_and() {
    
    for i in "$1"/*;do
        if [ -d "$i" ]
        then
            find_folder_and "$i";
        else
            if [[ $i == $ext  ]]
            then
                par1=$(cat $i | tr ' ' '\n' | grep $parameter1 | wc -l);
                par2=$(cat $i | tr ' ' '\n' | grep $parameter2 | wc -l);

                if [ "$par1" != "0" ] && [ "$par2" != "0" ];
                    then
                        sum_to_and=$(($par1+$par2));
                        ands+="$i $sum_to_and";
                        ands+=$'\n';
                fi
            fi
        fi
    done
}  

function find_folder_or() {
    for i in "$1"/*;do
        if [ -d "$i" ]
        then
            find_folder_or "$i";
        else
            if [[ $i == $ext  ]]
            then
                par_or1=$(cat $i | tr ' ' '\n' | grep $parameter1 | wc -l);
                par_or2=$(cat $i | tr ' ' '\n' | grep $parameter2 | wc -l);

                if [[ "$par_or1" == "0"  ||  "$par_or2" == "0" ]];
                    then
                        son_to_or=$(($par_or1+$par_or2));

                        if [ "$son_to_or" != "0" ]
                            then
                                ors+="$i $son_to_or";
                                ors+=$'\n';
                            fi
                 fi
        	fi
        fi
    done
}

parameter1=$3;
parameter2=$4;

if [ -z "$6" ];
then
    ext+="*.*";
else
    ext+="*.$6";
fi

find_folder_and $1
echo "Search results for \"$3\" and \"$4\""
echo -n "$ands" | sort -s -t '/' | sort -s -k2 -r -n

find_folder_or $1
echo "Search results for \"$3\" or \"$4\""
echo -n "$ors" | sort -s -t '/' | sort -s -k2 -r -n






