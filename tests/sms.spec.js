const { test, expect } = require('@playwright/test');
const fs = require('fs');

const open = async (page) => { await page.goto(test.info().project.use.baseURL); };
const rowCount = (page) => page.locator('#studentTableBody tr').count();
const addStudent = async (page, s) => {
  await page.fill('#name', s.name); await page.fill('#rollNo', s.rollNo);
  await page.fill('#email', s.email); await page.fill('#course', s.course);
  await page.fill('#grade', String(s.grade)); await page.selectOption('#status', s.status);
  await page.click('#submitBtn');
};
const exportXls = async (page) => {
  const [dl] = await Promise.all([page.waitForEvent('download'), page.click('#exportXlsBtn')]);
  const html = fs.readFileSync(await dl.path(), 'utf8');
  return { name: dl.suggestedFilename(), html };
};
const rowsOf = (html) => [...html.matchAll(/<tr>(.*?)<\/tr>/g)].map(m => [...m[1].matchAll(/<t[hd][^>]*>(.*?)<\/t[hd]>/g)].map(c => c[1]));

test.describe('KAN-53 Export XLS', () => {
  test('exports visible rows with required columns and timestamped filename', async ({ page }) => {
    await open(page);
    await expect(page.locator('#exportXlsBtn')).toBeEnabled();
    const { name, html } = await exportXls(page);
    expect(name).toMatch(/^students_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}\.xls$/);
    const rows = rowsOf(html);
    expect(rows[0]).toEqual(['Roll No', 'Name', 'Email', 'Course', 'Grade (%)', 'Status']);
    expect(rows.length - 1).toBe(await rowCount(page));
  });

  test('respects the Status filter', async ({ page }) => {
    await open(page);
    await page.selectOption('#statusFilter', 'active');
    const { html } = await exportXls(page);
    const data = rowsOf(html).slice(1);
    expect(data.length).toBe(2);
    expect(data.every(r => r[5] === 'Active')).toBe(true);
  });

  test('respects the search filter combined with status', async ({ page }) => {
    await open(page);
    await page.fill('#searchInput', 'alice');
    const { html } = await exportXls(page);
    const data = rowsOf(html).slice(1);
    expect(data).toHaveLength(1);
    expect(data[0][1]).toBe('Alice Johnson');
  });

  test('button disabled when no rows are visible and re-enabled after clearing', async ({ page }) => {
    await open(page);
    await page.fill('#searchInput', 'zzz-no-match');
    await expect(page.locator('#exportXlsBtn')).toBeDisabled();
    await page.fill('#searchInput', '');
    await expect(page.locator('#exportXlsBtn')).toBeEnabled();
  });

  test('escapes special characters and neutralises formulas', async ({ page }) => {
    await open(page);
    await addStudent(page, { name: '<b>José</b> & O’Connor', rollNo: 'S-9', email: 'dev+x@test.io', course: '=SUM(A1)', grade: 97, status: 'active' });
    await page.fill('#searchInput', 'S-9');
    const { html } = await exportXls(page);
    expect(html).not.toContain('<b>José</b>');
    expect(html).toContain('&lt;b&gt;José&lt;/b&gt; &amp; O’Connor');
    expect(html).toContain('mso-number-format');
    expect(html).toContain('dev+x@test.io');
  });
});

test.describe('KAN-54 Theme toggle', () => {
  const theme = (page) => page.evaluate(() => document.documentElement.dataset.theme);

  test('default is Light for first-time visitors', async ({ page }) => {
    await open(page);
    expect(await theme(page)).toBe('light');
    await expect(page.locator('#themeToggleBtn')).toHaveText(/Dark mode/);
    await expect(page.locator('#themeToggleBtn')).toHaveAttribute('aria-pressed', 'false');
  });

  test('toggles to Dark and restyles the page', async ({ page }) => {
    await open(page);
    const bg = () => page.evaluate(() => getComputedStyle(document.body).backgroundColor);
    const lightBg = await bg();
    await page.click('#themeToggleBtn');
    expect(await theme(page)).toBe('dark');
    expect(await bg()).not.toBe(lightBg);
    await expect(page.locator('#themeToggleBtn')).toHaveText(/Light mode/);
    const color = (sel) => page.evaluate((s) => getComputedStyle(document.querySelector(s)).backgroundColor, sel);
    for (const sel of ['.card', 'input#name', 'select#status', 'thead th']) expect(await color(sel)).not.toBe('rgb(255, 255, 255)');
  });

  test('persists across refresh with no flash of wrong theme', async ({ page }) => {
    await open(page);
    await page.click('#themeToggleBtn');
    expect(await page.evaluate(() => localStorage.getItem('sms_theme'))).toBe('dark');
    await page.reload();
    expect(await theme(page)).toBe('dark');
  });

  test('toggles back to Light', async ({ page }) => {
    await open(page);
    await page.click('#themeToggleBtn');
    await page.click('#themeToggleBtn');
    expect(await theme(page)).toBe('light');
    expect(await page.evaluate(() => localStorage.getItem('sms_theme'))).toBe('light');
  });

  test('is keyboard operable', async ({ page }) => {
    await open(page);
    await page.focus('#themeToggleBtn');
    await page.keyboard.press('Enter');
    expect(await theme(page)).toBe('dark');
    await page.keyboard.press('Space');
    expect(await theme(page)).toBe('light');
  });
});
