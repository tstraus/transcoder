const express = require('express')
const hbjs = require('handbrake-js')

const app = express()
const port = 3000

app.get('/', (req, res) => res.send('Transcoder'))

app.listen(port, () => console.log(`Transcoder listening on port ${port}`))

hbjs.spawn({
        'input': 'veep.mkv',
        'output': 'output.mp4',
        'encoder': 'x265_10bit',
        'encoder-preset': 'fast',
        'encoder-profile': 'auto',
        'quality': 18.0,
        'aencoder': 'copy'
    })
    .on('error', err => {
        // invalid user input, no video found etc
        console.log('ERROR: ' + err)
    })
    .on('eError', err => {
        // encoding error
        console.log('ENCODING ERROR: ' + err)
    })
    .on('progress', progress => {
        console.log(
            'Percent complete: %s, ETA: %s',
            progress.percentComplete,
            progress.eta
        )
    })

