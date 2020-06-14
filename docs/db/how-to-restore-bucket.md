# How to restore Burntoast bucket
1. Copy down the dir you want to use
1. Create a backup of the current bucket just in case
1. Open cmd
1. Run `gsutil -m cp -r gs://burntoast.appspot.com/* gs://burntoast-freezer/backup-2020-01-01--01-01-01-AEST/`
1. Run `gsutil -m cp -r gs://burntoast-freezer/2020-01-01--01-01-01-AEST/* gs://burntoast.appspot.com/`


# How to restore Butter bucket
1. Copy down the dir you want to use
1. Create a backup of the current bucket just in case
1. Open cmd
1. Run `gsutil -m cp -r gs://burntoast.appspot.com/* gs://butter-freezer/backup-2020-01-01--01-01-01-AEST/`
1. Run `gsutil -m cp -r gs://burtter-freezer/2020-01-01--01-01-01-AEST/* gs://burntoast.appspot.com/`
