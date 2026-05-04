const axios = require('axios');

async function loginAdmin() {
    try {
        const response = await axios.post('http://localhost:8080/api/auth/login', {
            username: 'admin',
            password: 'admin123'
        });
        console.log('Login response:', JSON.stringify(response.data, null, 2));
    } catch (error) {
        console.error('Error logging in:', error.response ? error.response.data : error.message);
    }
}

loginAdmin();
