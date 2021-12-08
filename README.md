# DRG portal jumpstart

All you need to start Intranet application portal in just a few minutes.

**Requires:**<br>
Ruby: Version >= 2.7 <br>
Ruby on Rails:  Version >= 6.1<br>
MongoDB: Version >= 4.0 installed locally (if not installed locally see instructions below)<br>
Git: <br>

You can read this short instructions https://www.drgcms.org/docs/drg-cms-documentation/installation-and-deployment/os-and-tools-instalation 
how to install required tools.


#### Creating a new app

```bash
rails new your_app_dir --skip-active-record --skip-action-cable --skip-turbolinks --skip-webpack-install -m https://raw.github.com/drgcms/drg-portal-jumpstart/master/template.rb/ -
```

Note: Remove underscore character at the beggining of the command.
The command will create new Ruby on Rails project in your_app_name directory, update 
necessary configuration files and prepare minimum application templates to start 
your own portal. Command may take few minutes to run. Most of the time is spent on 
installing gems required to run application.

Change directory to your_app_name.

```bash
cd your_app_name
```

**Note:** If your MongoDB is not installed localy, you must first update config/mongoid.yml 
file and set host name (perhaps also username and password) under development: section. 
Remote MongoDB setup requires an extra step, but default 
local installation doesn't need any administration at all. No login credentials is required
and MongoDB will create new databases and collections automatically when first used.
Since default installation allows connections only from localhost security is not in danger.

Start Ruby on Rails server locally 

```bash
rails server
```

Open Internet browser and point to "http://localhost:3000" address. You should be 
welcomed with page doesn't exist error. Which is OK since no data has yet 
been declared in portal database.

#### Initialize portal data

Change browser address to "http://localhost:3000/init". 
Enter portal superuser name and password and click on PROCESS, to seed initial
database data.

If everything went OK, change browser address to "http://localhost:3000",
click right top on LOGIN link, login with credentials defined in init step and 
be welcome in your portal application. 

#### Cleaning up

Press Ctrl+C to stop your Rails application server and then enter:

```bash
rails db:drop
cd ..
rm -rf your_app_name
```
