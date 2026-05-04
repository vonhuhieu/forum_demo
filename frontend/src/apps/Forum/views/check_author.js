const axios = require('axios');

async function checkThreads() {
    try {
        const response = await axios.get('http://localhost:8080/api/threads/latest');
        const threads = response.data.data;
        if (threads && threads.length > 0) {
            const adminThread = threads.find(t => t.author && t.author.username === 'admin');
            if (adminThread) {
                console.log('Admin author data:', JSON.stringify(adminThread.author, null, 2));
            } else {
                console.log('No admin thread found. First thread author:', JSON.stringify(threads[0].author, null, 2));
            }
        } else {
            console.log('No threads found.');
        }
    } catch (error) {
        console.error('Error fetching threads:', error.message);
    }
}

checkThreads();
