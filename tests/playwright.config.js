const { defineConfig } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');
module.exports = defineConfig({
  testDir: '.',
  testMatch: '*.spec.js',
  reporter: [['list'], ['json', { outputFile: 'report/results.json' }], ['html', { outputFolder: 'report/html', open: 'never' }]],
  use: { baseURL: process.env.BASE_URL || pathToFileURL(path.resolve(__dirname, '..', 'index.html')).href, acceptDownloads: true },
});
