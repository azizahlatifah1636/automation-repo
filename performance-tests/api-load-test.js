import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Custom metrics
export let errorRate = new Rate('errors');

// Test configuration
export let options = {
  stages: [
    { duration: '2m', target: 10 }, // Ramp up to 10 users
    { duration: '5m', target: 10 }, // Stay at 10 users
    { duration: '2m', target: 20 }, // Ramp up to 20 users
    { duration: '5m', target: 20 }, // Stay at 20 users
    { duration: '2m', target: 0 },  // Ramp down to 0 users
  ],
  thresholds: {
    'http_req_duration': ['p(95)<500'], // 95% of requests must be below 500ms
    'http_req_failed': ['rate<0.05'],   // Error rate must be below 5%
    'errors': ['rate<0.1'],             // Custom error rate below 10%
  },
};

// Test scenarios
export default function() {
  // Test API endpoints
  let response;
  
  // Health check endpoint
  response = http.get(`${__ENV.API_BASE_URL || 'http://localhost:3000'}/health`);
  check(response, {
    'Health check status is 200': (r) => r.status === 200,
    'Health check response time < 200ms': (r) => r.timings.duration < 200,
  }) || errorRate.add(1);
  
  sleep(1);
  
  // API endpoints testing
  response = http.get(`${__ENV.API_BASE_URL || 'http://localhost:3000'}/api/users`);
  check(response, {
    'Get users status is 200': (r) => r.status === 200,
    'Get users response time < 500ms': (r) => r.timings.duration < 500,
    'Response has users data': (r) => r.json().length > 0,
  }) || errorRate.add(1);
  
  sleep(1);
  
  // POST request test
  let payload = JSON.stringify({
    name: 'Test User',
    email: `test${Math.random()}@example.com`,
  });
  
  let params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  
  response = http.post(`${__ENV.API_BASE_URL || 'http://localhost:3000'}/api/users`, payload, params);
  check(response, {
    'Create user status is 201': (r) => r.status === 201,
    'Create user response time < 1000ms': (r) => r.timings.duration < 1000,
  }) || errorRate.add(1);
  
  sleep(2);
}
