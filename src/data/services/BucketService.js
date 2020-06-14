import { burntoastAdmin, butterAdmin } from './FirebaseAdminService';
import Utils from '../../utils/Utils';
import CoffeeCat, { Emoji } from '../../utils/CoffeeCat';

const burntoastStorage = burntoastAdmin.storage();
const butterStorage = butterAdmin.storage();


async function run(taskName, sourceBucket, destBucket) {

  function log(str) {
    console.log(`${taskName} - ${str}`);
  }

  async function listFiles(bucket) {
    const [files] = await bucket.getFiles();
    const filenames = files.map(f => f.name);
    log(`Bucket ${bucket.name} has ${filenames.length} files`);
    return filenames;
  }

  log('Started');
  const start = new Date();

  const sourceFiles = await listFiles(sourceBucket);
  const destFiles = await listFiles(destBucket);

  const diff = sourceFiles.filter(f => !destFiles.includes(f));
  const count = diff.length;

  const startMsg = `Preparing to copy ${count} files to ${destBucket.name}, ` +
    `${sourceBucket.name}:${sourceFiles.length}, ` +
        `${destBucket.name}:${destFiles.length}`;
  CoffeeCat.msgAlert(Emoji.Info, taskName, startMsg);

  let errorCount = 0;
  let successCount = 0;

  const copyPromises = diff.map((filename) => {
    return new Promise(resolve => {
      const copyCallback = (err, file, apiResponse) => {
        if (err != null || !apiResponse?.resource?.name.startsWith(file.name)) {
          log(`Error, ${err}`);
          errorCount++;
        } else {
          successCount++;
        }
        resolve(true);
      };

      sourceBucket
        .file(filename)
        .copy(destBucket.file(filename), copyCallback);
    });
  });

  const chunked = Utils.chunkArray(copyPromises, 1000)

  let promiseCount = 0;
  await Promise.all(
    chunked.map(async chunk => {
      await Promise.all(chunk)
      promiseCount += chunk.length;
      log(`Processed ${promiseCount} / ${count} files`)
    }));

  const dur = new Date() - start;
  const msg = `total: ${count}, success: ${successCount}, errors: ${errorCount} - ${dur}ms`;
  if (errorCount > 0) {
    CoffeeCat.msgAlert(Emoji.Error, taskName, `Failed to complete backup - ${msg}`)
  } else {
    CoffeeCat.msgAlert(Emoji.Success, taskName, `Success, backup completed - ${msg}`)
  }

  log('Goodbye');
}


export default class BucketService {

  static async backupBurntoastBucket() {
    const sourceBucket = burntoastStorage.bucket('burntoast.appspot.com');
    const destBucket = burntoastStorage.bucket('burntoast-freezer');
    await run('BackupBurntoastBucket', sourceBucket, destBucket);
  }

  static async backupButterBucket() {
    const sourceBucket = butterStorage.bucket('burntbutter-inc.appspot.com');
    const destBucket = butterStorage.bucket('burntbutter-freezer');
    await run('BackupButterBucket', sourceBucket, destBucket);
  }

}
