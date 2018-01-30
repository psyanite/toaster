# 🍞 Frakkin Toasters #

🐈 Meow, meow-meow-meow, meow-meow, meow.

### Development Tools ###
* PostgreSQL 10
* WebStorm
* DataGrip
* Git Bash
* Git Kraken

### How to database ###
* Install PostgreSQL 10
* Clone repository
* Create .env file in root
* Add configurations like such:
```
DATABASE_DIALECT = 'postgres'
DATABSE_HOST = 'localhost'
DATABASE_PORT = 5432
DATABASE_NAME = 'burntoast'
DATABASE_USERNAME = 'postgres'
DATABASE_PASSWORD = 'password'
```
* More information available at [dotenv Github repository](https://github.com/motdotla/dotenv)
* cd src/data/migrations
* psql -U postgres -f 'export.sql'

### How to start the frakkin toaster ###
* yarn install
* yarn start
* https://localhost:3000/graphql
* Don't stick your knife in there

### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact
