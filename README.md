# 🍞 Toaster 1.1.0

🐈 GraphQL API built ontop of a PostgreSQL schema combined with the power of Sequelize

### Meowries

```
profileByUserAccountId(userAccountId: Int!): [UserProfile]
allPosts: [Post]
postById(id: Int!): [Post]
postsByStoreId(storeId: Int!): [Post]
postsByUserAccountId(userAccountId: Int!): [Post]
allRewards: [Reward]
allStores: [Store]
storeById(id: Int!): [Store]
allUserAccounts: [UserAccount]
userAccountById(id: Int!): UserAccount
userAccountByUsername(username: String!): UserAccount
userLoginBy(socialType: String!socialId: String!): UserLogin
userProfileByUsername(username: String!): UserProfile
```

### Meowtations

```
addStore(
  name: String!): Store

addUser(
  username: String!
  display_name: String!
  email: String!
  profile_picture: String!
  social_id: String!
  social_type: String!): UserLogin
```

### Development Tools

* PostgreSQL 10
* JDK
* Git
* Babun
* Yarn
* Node 8.11.3
* Intellij
* DataGrip
* Android Studio
* Expo
* Genymotion
* Git Kraken

### How to assemble

* Install PostgreSQL
* Clone repository
* Create `.env` file in root
* Add dotenv configurations like such:

```
DATABASE_DIALECT = 'postgres'
DATABSE_HOST = 'localhost'
DATABASE_PORT = 5432
DATABASE_NAME = 'burntoast'
DATABASE_USERNAME = 'postgres'
DATABASE_PASSWORD = 'password'
```

* `psql -U postgres -f 'src/data/migrations/clean.sql'`
* `psql -U postgres -d burntoast -f 'src/data/migrations/export.sql'`

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
