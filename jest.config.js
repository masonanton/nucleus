module.exports = {
  testEnvironment: 'node',
  globalSetup:    '<rootDir>/scripts/test-setup.js',
  globalTeardown: '<rootDir>/scripts/test-teardown.js',
  setupFiles: ['dotenv/config'],  
  testTimeout: 30000            
};
