layout: post
date:   2018-11-30 13:00:00
categories: tutorial
---
* will be replace by toc
{:toc}

# Git fundamentals

## Initial configuration

~~~
git config --global branch.autosetuprebase always
git config --global color.ui auto
git config --global user.name "AP"
git config --global user.email "predoiu.seli@gmail.com"
git config --edit --global
git config core.editor "vi"
git config --global -l                # list
~~~

## demo

~~~
git init test1     # create an empty repo in test1 folder
cd test1
git status         
vi README.md
# remote
git remote -v                       # check remote. one for push one for fetch
git remote add orighin https://...
git push -u origin master           # -u create tracking relation
~~~

## special files

README
    in root, .github or docs folder
LICENSE
CONTRIBUTING or CONTRIBUTORS
CHANGELOG
SUPPORT
CODE_OF_CONDUCT

## other

pull = fetch + merge
archiving = put repo in a read only mode

~~~
git add .                # add all untracked files
git commit - m "mess"
git push origin master
git fetch                 # non destructive
git pull                  # if OK -> fast forward merge
~~~

tag
~~~
git tag -a v0.1 -m "0.1 release" a6xxxx
git tag -a v0.2 -m "0.2 release" b4xxxx
git tag
git push --tags
git tag -d "v0.2"                      # delete a local tag
git push origin :v0.2                  # delete remote tag
~~~

nice
~~~
git config --global branch.autosetuprebase always
git log --oneline --graph --decorate --all
~~~