IDE = Integrated development env
winscp -- FTP FILE TYPE PROTOCOL

shebang = you need to declare the path of interpreter to let linux server how to exec your shell script

date +%F

 cat -A 01-variables.sh -- for hidden chars

 ^M$ - windows line ending
 $ - unix/linux

variables = you declare one place, then it'll reflect everywhere you no need to worry how many places == DRY don't repeat yourself

int i = 10

NAME = Ramesh --> wrong
NAME=Ramesh

native --> hybrid
100% using shell
python --> not 100% --> in background it uses shell script
if you are callin other systems then you can go for python

variables
data types
conditions
loops
functions

list of commands + scripting concepts

1. you can directly create vars and assign value inside shell script
2. how can you run a cmd inside shell script & get value inside vars
3. you can pass val to shell script from outside through args
4. YOU can ask user to enter the val dynamiclly i.e read cmd
running a script that connects to DB, username & password

##### DATA TYPES #########
mostly everything is string here, but you pass number shell script understand its number

array = list of elements

##### BOOLEAN - TRUE/FALSE ###
boolean --> 0 = failure
            1 = success

#### EXIT CODES #####
1
2 -> error, is it safe to move forward or not?
3
4

unfortunately shell dont care the error, it'll just move forward
it is our responsibility to check success or not
$? = 0 success
1-127 = failure
check the exit code at every line...
0 or not

### CONDITION ####
if [ expression ] 
then
    Statements to be exec if expression is true
else
    Statements to be exec if expression is false
fi

first findout user has root access or not
if he has root access forward, otherwise inform him you are not root user

algorithm
TASK: install any package
1. we need root access
2. check user has root access or not
3. if yes proceed
4. if no tell him you are not root user and exit

if id -u is 0 then root

sleep 20 & # to send this cmd in background
echo $? # exit code

# required to install multiple packages

git 
vim
wget
net-tools

functions -- does a unit of work, you can create functions and use it wherever required. a change in single place reflects everywhere

variables -- using wherever we require, if you change in one place this is reflected everywhere

FUNCTION_NAME() {

}

FUNCTION_NAME # THIS is how you call the function

logs 

output redirection =
1 = success
2 = failure
& = both

> = redirection
>> = appending
GREEN = 32m
RED = 31m
NORMAL = 0m

date +"%F-%H-%M-%S"

##### LOOPS ####
loops --> DRY
for (int i=0; i<20; i++>) {
    echo $i
}

$@ = everything

for VARIABLE in 1 2 3 4 5 .. N
do
    command1
    command2
    command3
done

i dont want to try installing already installed pkges
first check already installed or not
if installed skip it
if not installed install it

&>/dev/null = it doesnt give any output

cat /etc/passwd | awk -F ":" '{print $F}' # field seperator/fragmentation

USERS=$(cat /etc/passwd | awk -F ":" '{print $1F}')  # to store in vars
echo $USERS

cat /etc/passwd | awk -F ":" '{print $1F}' | head -n 1  # it'll print 1colounm 1string

#### return values in functions
output of functions --> return values

global var = nothing but outside of the function

1. how to delete log files more than 2 weeks and schedule the script
algorithm
first which folder to remove
.log
more than 2 weeks --> find
schedule

touch 2026-19-05.log

find /root/devops-interview-prep/shell-scripting/logs -name "*.log" -type f -mtime +14

while command
do
    statements to be exec if command is true
done <<< $input
     input 
IFS = internal field seperator

## CRONTAB ##
crontab -e   ## to set the cron jobs
*/1 * * * * /root/devops-interview-prep/shell-scripting/11-delete-old-logs.sh  > /dev/null
crontab -l  ## to list the cron jobs

