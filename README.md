# 🍞 Toaster

✨ GraphQL API built ontop of a PostgreSQL schema combined with the power of Sequelize

🔥 Check it out now! https://burntoast.herokuapp.com/graphql

Toaster is a pure GraphQL API delivering Sequelized data from a PostgreSQL database on the fly. One of the many amazing features of Toaster, is the search endpoint.

<div align="center">
  <img src="https://github.com/psyanite/toaster/blob/master/docs/images/allstores-query.png" width="600px"/>
</div>

### Development Tools

- PostgreSQL 10
- JDK
- Git
- Yarn 1.21.1
- Node 10.19.0
- Intellij
- DataGrip
- Android Studio
- Git Kraken

### IntelliJ JavaScript Libraries

- @types/express
- @types/node
- @types/webpack
- @types/webpack-env
- clean/node_modules
- HTML
- Node.js Core

### How to start the frakkin toaster
- See [here](./docs/how-to-assemble.md)

### More docos

- [How to database](./docs/how-to-database.md)
- [How to Heroku](./docs/how-to-heroku.md)
- [How to postgres full text search](http://rachbelaid.com/postgres-full-text-search-is-good-enough/)
- [How to sequelize full text search](https://medium.com/riipen-engineering/full-text-search-with-sequelize-and-postgresql-3572cb3093e7)
- [Test Plan](./docs/test-plan.md)

```
for i in $(cat 1.txt) ; do curl -O $(echo $i | tr '\r' ' ' |  sed 's/\?.*//' ) ; done
```