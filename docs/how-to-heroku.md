### How to update Heroku database
* Ensure `export.sql` is up-to-date
* Run `heroku pg:reset DATABASE_URL --confirm burntoast`
* Run `heroku pg:psql < 'src/scripts/export.sql'`
* Ignore any errors labelled `ERROR:  must be member of role "postgres"`
* Check database


### How to release
* Update README.md
* Commit changes
* Run `git tag 1.0.0`
* Run `git push -f --all && git push upstream -f --all && git push -f --tags && git push upstream -f --tags`
* Run `heroku login`
* Run `yarn deploy-heroku`


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
