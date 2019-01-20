### How to update version
* Update README.md
* Run `git tag 1.0.0`
* Run `git push origin 1.0.0`
* Run `git push upstream 1.0.0`


### How to deploy to Heroku
* Commit changes
* Run `heroku login`
* Run `yarn deploy-heroku`


### How to update Heroku database
* Ensure `export.sql` is up-to-date
* Run `heroku pg:reset DATABASE_URL --confirm burntoast`
* Run `heroku pg:psql < 'src/scripts/export.sql'`
* Ignore any errors labelled `ERROR:  must be member of role "postgres"`
* Check database


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
