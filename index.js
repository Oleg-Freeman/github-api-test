require('dotenv').config();
const axios = require('axios');

const {
    GITHUB_API_KEY,
    BASE_URL,
    REPOSITORY_OWNER_NAME,
    REPOSITORY_NAME
} = process.env;

(async () => {
    try {
        const path = 'schema.json';
        const requestURL = `${BASE_URL}/repos/${REPOSITORY_OWNER_NAME}/${REPOSITORY_NAME}/contents/${path}`;
        const options = {
            headers: {
                Authorization: `Bearer ${GITHUB_API_KEY}`
            }
        };
        const { data } = await axios.get(
            requestURL,
            options
        );
        const buffer = Buffer.from(data.content, 'base64');
        const originalSchema = JSON.parse(buffer.toString('utf8'));

        // console.log(originalSchema);

        originalSchema['testField'] = `testValue ${Math.random()}`;

        const commitData = {
            message: 'Update schema.json',
            content: Buffer.from(JSON.stringify(originalSchema)).toString('base64'),
            sha: data.sha
        };

        await axios.put(
            requestURL,
            commitData,
            options
        );
    } catch (error) {
        console.error(error.message);
        console.error(error.response.data.message);
    }
})();
