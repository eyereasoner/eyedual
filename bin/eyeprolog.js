#!/usr/bin/env node
import { main } from '../src/cli.js';

await main(process.argv.slice(2)).catch((error) => {
  console.error(`eyeprolog: ${error && error.message ? error.message : String(error)}`);
  process.exitCode = 1;
});
