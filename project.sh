#!/bin/bash/
Exit=false
while true
do  
    select choice in "createdb" "list" "connnect" "drop" "exit"
    do 
        case $choice in 
            createdb)   
                echo "Please Enter DataBase Name You want to create" ; 
                read name 
                if [ -d "$name" ]
                then
                    echo sorry please enter onther name this exist 
                else 
                    mkdir $name 
                    echo Database created
                fi 
                break
            ;;
            list)
                ls $PWD
                break
            ;;
            connnect)
                echo "Please Enter DataBase Name You want to connect" ; 
                read databaseName 
                if [ -d "$databaseName" ]
                then
                    cd $databaseName
                    echo you are connected to $databaseName
                    # to do after connnection
                    disconnect=false
                    while true
                    do  
                        select choice2 in "createTable" "listTable" "dropTable" "selectfromTable" "insertIntoTable" "deleteFromTable" "disconnect"
                        do 
                            case $choice2 in 
                                createTable)
                                    echo enter table name
                                    read Table
                                    if [ -f $Table ]
                                    then 
                                        echo table already exist 
                                    else 
                                        touch .$Table;
                                        touch $Table;
                                        echo -n 'id' >> $Table
                                        echo -n 'int' >> .$Table
                                        echo "how many Columns you want ?"
                                        typeset -i fnumber 
                                        read fnumber
                                        if [[ $fnumber -gt 0 ]]
                                        then
                                            for (( i=1; i<=$fnumber; i++ ))
                                            do
                                                read -p "Enter column No.$i name : " colName;
                                                echo "1)string  2)int"
                                                read -p "Enter column datatype :" coltype;
                                                case $coltype in
                                                    1)
                                                        echo -n ':string' >> .$Table
                                                        echo -n :$colName >> $Table
                                                    ;;
                                                    2)
                                                        echo -n ':int' >> .$Table
                                                        echo -n :$colName >> $Table
                                                    ;;
                                                    *)
                                                        echo "unknown datatype"
                                                        i=$i-1
                                                    ;;
                                                esac 
                                            done
                                        fi 
                                        echo "$Table has been created Succefully..."
                                    fi 
                                    break 
                                ;;
                                listTable)
                                    ls $PWD
                                    break
                                ;;
                                dropTable)
                                    echo "Please Enter Table Name You want to Drop" ; 
                                    read tableName
                                    if [ -f "$tableName" ]
                                    then
                                        rm -i $tableName
                                        rm .$tableName
                                        echo $tableName deleted 
                                    else 
                                        echo "table name dosen't exit"
                                    fi 
                                    break
                                ;;
                                selectfromTable)
                                    echo "Please Enter table Name" ; 
                                    read tableName
                                    if [[ -f $tableName ]]
                                    then
                                    printf "\n">>$tableName;  #to insert into a newLine  
                                    echo "enter coulmn name : "
                                    read colName 
                                    awk -v colName="$colName"  -v tableName="$tableName" -F : '
                                        BEGIN {
                                            print "************************************"
                                            print "select", colName ,"from" , tableName 
                                            dataF=-1;  
                                        } 
                                        {
                                            if(colName=="*"){
                                                print $0     
                                            }
                                            else{
                                                if(NR==1){
                                                    i=1; 
                                                    while(i<=NF) {
                                                        if(colName==$i){
                                                            print $i;
                                                            dataF=i;
                                                            break;
                                                        }
                                                        i++
                                                    } 
                                                }
                                                else{
                                                    
                                                    i=1; 
                                                    while(i<=NF) {
                                                        if(dataF==i){
                                                            print $i ; 
                                                        }
                                                        i++
                                                    } 
                                                }
                                            } 
                                        } 
                                        END {
                                                print "************************************"
                                            }
                                    ' $tableName
                                    echo end of Select
                                    else
                                    echo "table dosent exist"
                                    fi
                                    break
                                ;;
                                deleteFromTable)
                                        echo "This is all tables"
                                        ls $PWD
                                        read -p "Enter Table You Want to delete From : " tableName;
                                        
                                    if [[ -f $tableName ]] 
                                    then
                                        read -p "Enter the id of col you want do delete :"  recordId ;
                                        regex='^[0-9]+$'
                                        if ! [[ $recordId =~ $regex ]]
                                        then
                                            echo "error Please Enter a number not a string"
                                        elif ! [[ $recordId =~ [`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $1}' $tableName`] ]]
                                        then
                                            echo "Record Not found!"
                                        else
                                            sed -i /^$recordId/d  $tableName
                                            echo "Record deleted succefully!"
                                        fi    
                                    else
                                        echo "Sorry table is not exist"
                                    fi 
                                        break
                                ;;
                                insertIntoTable)

                                    
                                    id=-1
                                    echo "Please Enter table Name" ; 
                                    read tableName
                                    if [[ -f $tableName ]]
                                    then
                                     printf "\n">>$tableName;
                                    colsNum=`awk -F : 'END{print NF}' $tableName` #get the number of the cols
                                    id=`awk -F : 'END{ print $1 }' $tableName` #get the id 
                                    id=$(($id+1))
                                    j=1
                                    Error=false
                                    for (( i=2; i<=$(($colsNum)); i++ )) do
                                        colType=$(awk 'BEGIN{FS=":"}{ if(NR==1)print $'$i';}' .$tableName)
                                        echo enter value of $(awk 'BEGIN{FS=":"}{ if(NR==1)print $'$i';}' $tableName) ,type=$colType
                                        read value
                                        if [[  $colType == "int" ]] ; then
                                            if [[ ! $value =~ ^[0-9]+$ ]] ; then
                                                echo "((((wrong dataType))))"
                                                Error=true
                                                break
                                            fi
                                        fi
                                        row+=($value)
                                        j=$(($j+1))
                                    done 
                                    if [ $Error = false ] ;then
                                        echo -n $id >> $tableName
                                        for element in "${row[@]}"
                                        do
                                        : 
                                            echo -n :$element >> $tableName
                                        done
                                    fi
                                    else
                                            echo "table dosen't exit"
                                    fi
                                    break
                                    
                                ;;
                                disconnect)
                                    disconnect=true
                                    echo disconnected
                                    break
                                ;;
                            esac
                        done
                        if [ $disconnect = true ]
                        then
                            break
                        fi
                    done

                else
                    echo database dose not exist 
                fi
                break
            ;;
            drop)
                echo "Please Enter DataBase Name You want to drop" ; 
                read databaseName 
                if [ -d "$databaseName" ]
                then
                    read -p "Are You Sure Want to delete 1)Yes  2)No " check;
                    case $check in
                        1)  
                            rm -r $databaseName
                            echo "done"
                        ;;
                        2)
                            echo Not deleted
                        ;;
                        
                    esac 
                else
                    echo database dose not exist 
                fi
                break
            
            ;;
            exit)
                Exit=true   
                break

            ;; 
        esac
    done
    if [ $Exit = true ]
    then
        echo good bye
        break
    fi
done

