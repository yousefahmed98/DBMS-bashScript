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
                                                echo "1) string 2) int 3) boolen "
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
                                                    3)
                                                        echo -n ':boolen' >> .$Table
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
                                    echo end of awk
                                    break
                                ;;
                                disconnect)
                                    disconnect=true
                                    cd .. ;
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
