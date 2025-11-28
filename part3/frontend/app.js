const express = require('express');
const path = require('path');
const fetch = (...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args));
const bodyParser = require('body-parser');
const session = require('express-session');
const flash = require('connect-flash');
const moment = require('moment');

const app = express();
const PORT = 3000;
const BACKEND_URL = process.env.BACKEND_URL || "http://0.0.0.0:8000";

// Set view engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(session({ secret: 'secret123', resave: false, saveUninitialized: true }));
app.use(flash());

// Routes
app.get('/', (req, res) => {
  const day = moment().format('dddd');
  const time = moment().format('HH:mm:ss');
  const messages = req.flash('error');
  res.render('index', { day_of_the_week: day, time, messages });
});

app.post('/submit', async (req, res) => {
  const formData = {
    name: req.body.name,
    email: req.body.email,
    password: req.body.password,
    confirm_password: req.body.confirm_password,
  };

  try {
    const response = await fetch(`${BACKEND_URL}/submit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(formData),
    });

    if (response.ok) {
      return res.redirect('/success');
    } else {
      const errorData = await response.json();
      req.flash('error', `Error: ${errorData.error || 'Unknown error'}`);
      return res.redirect('/');
    }
  } catch (err) {
    req.flash('error', `Error connecting to backend: ${err.message}`);
    return res.redirect('/');
  }
});

app.get('/success', (req, res) => {
  res.render('success');
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Frontend server running on http://0.0.0.0:${PORT}`);
});
