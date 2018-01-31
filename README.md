# 🍞 Toaster 0.2.0

🐈 GraphQL API built ontop of a PostgreSQL schema combined with the power of Sequelize

### Queries

```
allStores: [Store]
storeById(id: Int!): [Store]

allUserAccounts: [UserAccount]
userAccountById(id: Int!): [UserAccount]

allPosts: [Post]
postById(id: Int!): [Post]
postsByStoreId(storeId: Int!): [Post]
postsByUserAccountId(userAccountId: Int!): [Post]
```

### Meowtations

```
addStore(name: String!): Store
```

### Development Tools

* PostgreSQL 10
* WebStorm
* DataGrip
* Git Bash
* Git Kraken

### How to assemble

* Install PostgreSQL
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
* psql -U postgres -f 'src/data/migrations/export.sql'
* Other helpful scripts can be find in the same directory

### How to start the frakkin toaster

* yarn install
* yarn start
* https://localhost:3000/graphql
* Don't stick your knife in there
