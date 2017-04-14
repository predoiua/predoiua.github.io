layout: post
date:   2017-04-14 13:00:00
categories: tutorial
---
* will be replace by toc
{:toc}

# Git statistics

~~~
git rev-list HEAD
git log -1
git rev-list --reverse HEAD

git rev-list --reverse HEAD | while read rev; do git log -1 $rev; done
git rev-list --reverse HEAD | while read rev; do git ls-tree $rev; done
git show blob_id
echo '1
2
3' | xargs
git rev-list --reverse HEAD | while read rev; do echo; echo REV $rev; git ls-tree -r $rev | awk '{print $3}' | xargs git show | cat; done | view -
# halt on error
set -e 
:map ,t :w\|:!./stats.sh<cr>
~~~

Bash valid function definitions

~~~
function name1 () {
    echo "hei name 1"
}

name2 () {
    echo "hei name 2"
}

function name3 {
    echo "hei name 3"
}
name1 && name2 && name3
~~~

~~~
#!/bin/bash

set -e
file_pattern=$1

function main {
    for rev in $(revisions); do
        echo "$(numbers_of_lines) $(commit_description)"
    done
}

function revisions {
    git rev-list --reverse HEAD
}

function commit_description {
    git log --oneline -1 $rev
}

function numbers_of_lines {
    git ls-tree -r $rev |
    grep "$file_pattern" |
    awk '{print $3}' |
    xargs git show |
    wc -l
}

main
~~~