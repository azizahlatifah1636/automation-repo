import { test, expect } from '@playwright/test';

test.describe('Web UI Basic Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:8080');
  });

  test('should load homepage', async ({ page }) => {
    await expect(page).toHaveTitle(/Pipeline Automation/);
  });

  test('should display users list', async ({ page }) => {
    await page.click('[data-testid="users-link"]');
    await expect(page.locator('[data-testid="users-list"]')).toBeVisible();
  });

  test('should create new user', async ({ page }) => {
    await page.click('[data-testid="users-link"]');
    await page.click('[data-testid="add-user-btn"]');
    
    await page.fill('[data-testid="user-name"]', 'Test User');
    await page.fill('[data-testid="user-email"]', 'test@example.com');
    
    await page.click('[data-testid="submit-btn"]');
    
    await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
  });

  test('should validate form fields', async ({ page }) => {
    await page.click('[data-testid="users-link"]');
    await page.click('[data-testid="add-user-btn"]');
    
    await page.click('[data-testid="submit-btn"]');
    
    await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
  });
});

test.describe('API Integration Tests', () => {
  test('should fetch users from API', async ({ page }) => {
    // Mock API response
    await page.route('**/api/users', async route => {
      const json = [
        { id: 1, name: 'John Doe', email: 'john@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
      ];
      await route.fulfill({ json });
    });

    await page.goto('http://localhost:8080');
    await page.click('[data-testid="users-link"]');
    
    await expect(page.locator('[data-testid="user-item"]')).toHaveCount(2);
  });

  test('should handle API errors gracefully', async ({ page }) => {
    // Mock API error
    await page.route('**/api/users', async route => {
      await route.fulfill({ status: 500, json: { error: 'Server error' } });
    });

    await page.goto('http://localhost:8080');
    await page.click('[data-testid="users-link"]');
    
    await expect(page.locator('[data-testid="error-banner"]')).toBeVisible();
  });
});
