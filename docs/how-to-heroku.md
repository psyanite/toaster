### How to update Heroku database
* Ensure `export.sql` is up-to-date
* Run `heroku pg:reset DATABASE_URL --confirm burntoast -a burntoast`
* Run `heroku pg:psql < 'src/scripts/export.sql'`
* Ignore any errors labelled `ERROR:  must be member of role "postgres"`
* Check database


### How to release
* Run `git push -f --all && git push upstream -f --all`
* Open CMD
* Run `heroku login`
* Run `yarn deploy-heroku`
* This command may seem to get stuck but should take 15 minutes


### How Heroku was setup
* cd to project root directory
* Run `heroku create`
* Run `heroku addons:create heroku-postgresql:hobby-dev`
* Run `heroku config`
* Ensure `DATABASE_URL` is set and `NODE_ENV` is set to `production`
* Update `sequelize.js` to enable ssl for production builds
* Comment out remote for GitHub Pages and uncomment Heroku instead in `tools/deploy.js`
* Replace <app> with your app name
* Create `Procfile` in root directory and add `web: node start`
* Commit changes
* Run `yarn run build -- --release`
* Run `yarn run deploy`
* Run `heroku open`

```
Creating OAuth Authorization... done
Client:      <none>
ID:          fbdba1d9-0896-4623-8752-b7a08b38e6a2
Description: Bitbucket Pipeline
Scope:       global
Token:       c26b5978-c53d-486f-b679-3707a080b8ef
Updated at:  Sat Apr 06 2019 11:09:15 GMT+1100 (Australian Eastern Daylight Time) (less than a minute ago)
```
