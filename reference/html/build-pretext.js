// Build Pretext ESM → IIFE bundle for <script> usage
// Exposes window.Pretext = { prepare, layout }
const esbuild = require('esbuild');

esbuild.buildSync({
  entryPoints: ['pretext-entry.js'],
  bundle: true,
  format: 'iife',
  globalName: 'Pretext',
  outfile: 'js/pretext.bundle.js',
  platform: 'browser',
});

console.log('Built js/pretext.bundle.js');
