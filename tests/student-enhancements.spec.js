// Run: npm i -D @playwright/test && npx playwright install chromium && npx playwright test tests
const { test, expect } = require('@playwright/test');
const path = require('path');
const url = 'file://' + path.resolve(__dirname, '..', 'index.html');

test('defaults to Light Mode', async ({ page }) => {
  await page.goto(url);
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'light');
  await expect(page.locator('#themeToggle')).toHaveText(/Dark Mode/);
});

test('toggles and persists theme', async ({ page }) => {
  await page.goto(url);
  await page.click('#themeToggle');
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
  await page.reload();
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
  await page.click('#themeToggle');
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'light');
  await expect(page.locator('#statTotal')).toHaveText('3');
});

test('exports filtered records as timestamped .xls', async ({ page }) => {
  await page.goto(url);
  await page.selectOption('#statusFilter', 'inactive');
  const [download] = await Promise.all([page.waitForEvent('download'), page.click('#exportXlsBtn')]);
  expect(download.suggestedFilename()).toMatch(/^students_\d{4}-\d{2}-\d{2}_\d{4}\.xls$/);
  const text = require('fs').readFileSync(await download.path(), 'utf8');
  expect(text).toContain('Carol White');
  expect(text).not.toContain('Alice Johnson');
});

test('empty export shows message and no download', async ({ page }) => {
  await page.goto(url);
  await page.fill('#searchInput', 'zzzz-no-match');
  let downloaded = false;
  page.on('download', () => (downloaded = true));
  const dialog = page.waitForEvent('dialog');
  await page.click('#exportXlsBtn');
  expect((await dialog).message()).toBe('No data to export.');
  expect(downloaded).toBe(false);
});
