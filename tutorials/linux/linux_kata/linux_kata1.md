---
layout: post
date:   2015-08-01 13:00:00
categories: linux training
---
* toc
{:toc}

# Linux warmup

## Launch Docker VM

~~~ bash
docker run -it --rm ubuntu:latest /bin/bash
~~~

## Record commands and check term capabilities

~~~ bash
script

file `which diff`
tput colors
echo $TERM
export TERM=xterm-256color
exit #script
vi typescript
~~~

## Manage users and group

Obs: useradd obsolate
Use ADDUSER/DELUSER instead

~~~ bash
tail /etc/passwd
# useradd -D #lowlevel
# useradd bi
adduser bi
mkdir -p /home/sylvain
chown sylvain:sylvain /home/sylvain
passwd bi
groupadd big1
groupadd big2
#add user bi in 2 groupus
usermod -a -G big1,big2 bi
#set default group. in our case no changes
usermod -g bi bi
id bi
su - bi

touch s.sh
chmod 0766 s.sh

exit

usermod --shell /bin/false bi
usermod --shell /bin/bash bi

#userdel -r bi
~~~

## Bash function

~~~ bash
bind -p
~~~

## Scripting

All the following tests are evaluated to 0 == true.
We can't compare for "<=", use "! >" instead.

Valid form :

- if [[ 1 < ${var2} ]]; then
- if [[ 1 <${var2} ]]; then
- if [[ 1 < ${var2} ]];then

Invallid form:

- if[[ 1 < ${var2} ]]; then
- if [[ 1< ${var2} ]]; then
- if [[ 1 < ${var2}]]; then

~~~ bash
[ ! "abc" = "def" ]; echo $?
test ! "abc" \> "abc" ; echo $?
# ( cmd ) is run in a sub-shell, so we escape it
[ \( "a" = "$HOME" -o 3 -lt 4 \) ]; echo $?

[[ "a" < "b" ]]; echo $?
[[ "a" > "b" || 1 -lt 10 ]]; echo $?
var2=2 # !! no space before or after = 
if [[ 1 < ${var2} ]]; then
	echo "true"
fi
~~~

~~~ bash
function err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}
function test() {
    local var1="var1"
    local var2
    var2="var2"
    err var1 ${var1} var2 ${var2} $1
}

test "just a param"
#return a string
fct1(){
    echo "return1 $1"
}
val1=$( fct1 param )
err ${val1} $?
~~~

## Funny

~~~sh
> -f
rm ./-f
~~~
