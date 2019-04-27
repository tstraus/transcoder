const express = require('express')
const hbjs = require('handbrake-js')

const app = express()
const port = 3000

var count = 0

app.use(express.json())
app.use('/', express.static('public'))

app.post("/encode", (request, response) => {
    console.log(request.body)

    count += 1

    hbjs.spawn({
            'input': request.body.file,
            'output': './samples/out' + count + '.mp4',
            //'encoder': 'x265_10bit',
            'encoder': 'x264',
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

    response.json({
        state: 'started'
    })
})

app.listen(port, () => console.log(`Transcoder listening on port ${port}`))

