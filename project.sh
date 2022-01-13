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
                        select choice2 in "createTable" "listTable" "dropTable" "selectfromTable" "isnertIntoTable" "deleteFromTable" "disconnect"
                        do 
                            case $choice2 in 
 
                                createTable)
                                    echo "Please Enter Table Name You want to create" ; 
                                    read tableName 
                                    if [ -f "$tableName" ]
                                    then
                                        echo sorry please enter onther name this exist 
                                    else 
                                        touch $tableName.csv
                                        echo table created
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
                                        rm $tableName
                                        echo table deleted 
                                    else 
                                
                                        echo "table name dosen't exit"
                                    fi 
                                    break
                                ;;
                                selectfromTable)
                                    echo "Please Enter DataBase Name You want to connect" ; 
                                    read tableName
                                    awk '{
                                        print $1
                                    }' $tableName.csv

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
                    rm -r $databaseName
                    echo you are connected to $databaseName
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
