import { makeDir } from './lib/fs';
import run from './run';


async function deploy() {
  await makeDir('build');
  process.argv.push('--release');
  await run(require('./build').default);
}

export default deploy;
