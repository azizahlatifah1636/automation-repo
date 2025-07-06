const request = require('supertest');
const app = require('../../src/app');

describe('Integration Tests - API Endpoints', () => {
  
  describe('Health Check Integration', () => {
    test('should return health status with uptime', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);
      
      expect(response.body).toHaveProperty('status', 'ok');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('uptime');
      expect(typeof response.body.uptime).toBe('number');
    });
  });

  describe('Users API Integration', () => {
    test('should handle full user workflow', async () => {
      // 1. Get initial users
      const initialResponse = await request(app)
        .get('/api/users')
        .expect(200);
      
      const initialCount = initialResponse.body.length;
      
      // 2. Create new user
      const newUser = {
        name: 'Integration Test User',
        email: 'integration@test.com'
      };
      
      const createResponse = await request(app)
        .post('/api/users')
        .send(newUser)
        .expect(201);
      
      expect(createResponse.body).toHaveProperty('id');
      expect(createResponse.body.name).toBe(newUser.name);
      expect(createResponse.body.email).toBe(newUser.email);
      
      const userId = createResponse.body.id;
      
      // 3. Get user by ID
      const getUserResponse = await request(app)
        .get(`/api/users/${userId}`)
        .expect(200);
      
      expect(getUserResponse.body.id).toBe(userId);
      expect(getUserResponse.body.name).toBe(newUser.name);
      
      // 4. Update user
      const updateData = {
        name: 'Updated Integration User'
      };
      
      const updateResponse = await request(app)
        .put(`/api/users/${userId}`)
        .send(updateData)
        .expect(200);
      
      expect(updateResponse.body.name).toBe(updateData.name);
      expect(updateResponse.body.email).toBe(newUser.email);
      
      // 5. Verify updated user count
      const afterCreateResponse = await request(app)
        .get('/api/users')
        .expect(200);
      
      expect(afterCreateResponse.body.length).toBe(initialCount + 1);
      
      // 6. Delete user
      await request(app)
        .delete(`/api/users/${userId}`)
        .expect(204);
      
      // 7. Verify user is deleted
      await request(app)
        .get(`/api/users/${userId}`)
        .expect(404);
      
      // 8. Verify final user count
      const finalResponse = await request(app)
        .get('/api/users')
        .expect(200);
      
      expect(finalResponse.body.length).toBe(initialCount);
    });
    
    test('should validate user data constraints', async () => {
      // Test missing name
      await request(app)
        .post('/api/users')
        .send({ email: 'test@example.com' })
        .expect(400);
      
      // Test missing email
      await request(app)
        .post('/api/users')
        .send({ name: 'Test User' })
        .expect(400);
      
      // Test empty payload
      await request(app)
        .post('/api/users')
        .send({})
        .expect(400);
    });
    
    test('should handle non-existent user operations', async () => {
      const nonExistentId = 99999;
      
      // Get non-existent user
      await request(app)
        .get(`/api/users/${nonExistentId}`)
        .expect(404);
      
      // Update non-existent user
      await request(app)
        .put(`/api/users/${nonExistentId}`)
        .send({ name: 'Updated' })
        .expect(404);
      
      // Delete non-existent user
      await request(app)
        .delete(`/api/users/${nonExistentId}`)
        .expect(404);
    });
  });
  
  describe('Error Handling Integration', () => {
    test('should handle malformed requests', async () => {
      // Test invalid JSON
      const response = await request(app)
        .post('/api/users')
        .set('Content-Type', 'application/json')
        .send('invalid json')
        .expect(400);
    });
    
    test('should handle unsupported routes', async () => {
      await request(app)
        .get('/api/nonexistent')
        .expect(404);
      
      await request(app)
        .post('/api/nonexistent')
        .expect(404);
    });
  });
});
