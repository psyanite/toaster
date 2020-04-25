# 1. Install database
- Install PostgreSQL
- Set database in the 'How to database' section

# 2. Add .env file
- Create `.env` file in root for dotenv configs:
```
DATABASE_DIALECT = 'postgres'
DATABASE_HOST = 'localhost'
DATABASE_PORT = 5432
DATABASE_NAME = 'burntoast'
DATABASE_USERNAME = 'postgres'
DATABASE_PASSWORD = '???'
BEARER = '???'

# Cloud SQL
#DATABASE_DIALECT = 'postgres'
#DATABASE_HOST = '???'
#DATABASE_PORT = 5432
#DATABASE_NAME = '???'
#DATABASE_USERNAME = '???'
#DATABASE_PASSWORD = '???'
#BEARER = '???'
```

# 3. Add app.yaml
- Create `app.yaml` file for GCP deployment configs:

```
runtime: nodejs10

instance_class: F1

env_variables:
  NODE_ENV: "production"
  DATABASE_DIALECT: "postgres"
  DATABASE_HOST: "/cloudsql/???"
  DATABASE_PORT: 5432
  DATABASE_NAME: "???"
  DATABASE_USERNAME: "???"
  DATABASE_PASSWORD: "???"
  BEARER: "???"
```

# 4. Add secrets
- Create `/secrets` dir in root
- Copy `firebase-admin-burntoast.json` file into dir
- Copy `firebase-admin-butter.json` file into dir

# 5. Turn it on
- `yarn install`
- `yarn start`
- Go to `http://localhost:3000/graphql`
- Install Chrome extension Modheader
- Don't stick your knife in there