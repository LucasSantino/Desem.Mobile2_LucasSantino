const express = require('express');
const cors = require('cors');
const app = express();

// Libera CORS para todas as origens
app.use(cors());

// Permite envio de JSON
app.use(express.json());



// Inicializa o servidor
app.listen(3000, '0.0.0.0', () => {
  console.log('http://10.0.2.2:3000/usuarios');
});
