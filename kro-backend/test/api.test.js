// api.test.js
const request = require('supertest');
const app = require('../server'); // Replace this with the path to your Express app file

describe('GET /getAllSubjects', () => {
    it('responds with JSON containing all subjects', async () => {
        const response = await request(app).get('/getAllSubjects');
        expect(response.statusCode).toBe(response.statusCode);
    });
});

describe('GET /getSubjects/:subjectId', () => {
    it('responds with JSON containing subject data for given ID', async () => {
        const response = await request(app).get('/getSubjects/14jMRogrxlCCUOqtOwHv');
        expect(response.statusCode).toBe(201);
      
    });
});

describe('POST /addSubject', () => {
    it('adds subjects to the database', async () => {
        const response = await request(app).post('/addSubject');
        expect(response.statusCode).toBe(201);
     
    });
});

describe('POST /addASubject', () => {
    it('adds a subject to the database', async () => {
        const response = await request(app).post('/addASubject');
        expect(response.statusCode).toBe(201);
      
    });
});

describe('DELETE /removeAllSubject', () => {
    it('removes all subjects from the database', async () => {
        const response = await request(app).delete('/removeAllSubject');
        expect(response.statusCode).toBe(201);
       
    });
});
