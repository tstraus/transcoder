const express = require('express')
const hbjs = require('handbrake-js')

const app = express()
const port = 3000

app.get('/', (req, res) => res.send('Transcoder'))

app.listen(port, () => console.log('Transcoder listening on port ${port}'))

hbjs.spawn({ input: 'something.avi', output: 'something.m4v' })
    .on('error', err => {
        // invalid user input, no video found etc
        console.log('ERROR: ' + err)
    })
    .on('progress', progress => {
        console.log(
            'Percent complete: %s, ETA: %s',
            progress.percentComplete,
            progress.eta
        )
    })

