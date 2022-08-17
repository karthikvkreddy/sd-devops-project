const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');


require('dotenv').config();

console.log('environment    ', process.env.ENVIRONMENT);
console.log('PORT    ', process.env.PORT);
console.log('MONGO_CONNECTION_STRING    ', process.env.MONGO_CONNECTION_STRING);


const taskController = require('./controller/task.controller')

const app = express();
const port = 80;

app.use(express.static('../ui/dist/ui/'));
app.use(bodyParser.json());

app.get('/api/tasks', (req, res) => {
    taskController.getTasks().then(data => res.json(data));
});

app.post('/api/task', (req, res) => {
    console.log(req.body);
    taskController.createTask(req.body.task).then(data => res.json(data));
});

app.put('/api/task', (req, res) => {
    taskController.updateTask(req.body.task).then(data => res.json(data));
});

app.delete('/api/task/:id', (req, res) => {
    taskController.deleteTask(req.params.id).then(data => res.json(data));
});

app.get('/', (req, res) => {
    res.sendFile('../ui/dist/ui/index.html');
});



app.listen(port, () => {
    console.log(`Server listening on the port  ${port}`);
})