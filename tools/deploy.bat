call babel-node tools/run deploy
cd build
call gcloud app deploy --promote --stop-previous-version
call gcloud app browse