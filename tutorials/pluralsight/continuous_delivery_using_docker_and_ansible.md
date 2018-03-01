
# Continuous Delivery Using Docker And Ansible

## 3. Creating the Sample Application

~~~
pip install django==1.9                     # install django
django-admin startproject todobackend       # create todobackend project 

# reorg generated code. move all in src
cd todobackend
mkdir src
mv manage.py src
mv todobackend/ src

git init
vi .gitignore # add vend = virtual env, *.pyc, *.sqlite3
git add -A
git commit -a -m "initial commit"

pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install pip --upgrade
pip install django
pip install djangorestframework==3.3
pip install django-cors-headers==1.1

# add application
cd src
python manage.py startapp todo
vi settings.py  # add todo to INSTALLED_APPS, same for 'rest_framework','corsheaders'


# create models

# create serializers

# create view

# run app
python manage.py runserver

~~~

## 4. Demo - Unit and Integration Testing

~~~
python manage.py test
~~~