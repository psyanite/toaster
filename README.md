# 🍞 Toaster

✨ GraphQL API built ontop of a PostgreSQL schema combined with the power of Sequelize

🔥 Check it out now! https://burntoast.herokuapp.com/graphql

Toaster is a pure GraphQL API delivering Sequelized data from a PostgreSQL database on the fly. One of the many amazing features of Toaster, is the search endpoint.

<div align="center">
  <img src="https://github.com/psyanite/toaster/blob/master/docs/images/allstores-query.png" width="600px"/>
</div>

### Development Tools

* PostgreSQL 10
* JDK
* Git
* Yarn 1.12.1
* Node 8.13.0
* Intellij
* DataGrip
* Android Studio
* Git Kraken

### How to assemble
* Install PostgreSQL
* Clone repository
* Create `.env` file in root
* Add dotenv configurations like such:
```
DATABASE_DIALECT = 'postgres'
DATABASE_HOST = 'localhost'
DATABASE_PORT = 5432
DATABASE_NAME = 'burntoast'
DATABASE_USERNAME = 'postgres'
DATABASE_PASSWORD = '???'
BEARER = '???'
```
* `psql -U postgres -f 'src/scripts/clean.sql'`
* `psql -U postgres -d burntoast -f 'src/scripts/export.sql'`

### How to start the frakkin toaster
* `yarn install`
* `yarn start`
* https://localhost:3000/graphql
* Don't stick your knife in there

### More docos
* [How to database](./docs/how-to-database.md)
* [How to Heroku](./docs/how-to-heroku.md)
* [How to postgres full text search](http://rachbelaid.com/postgres-full-text-search-is-good-enough/)
* [How to sequelize full text search](https://medium.com/riipen-engineering/full-text-search-with-sequelize-and-postgresql-3572cb3093e7)
* [Test Plan](./docs/test-plan.md)
