import { app } from 'hyperapp'
import { Encode } from './components/encode'
import { requests } from './requests'

const state = {
    file: './samples/in.mp4',
    transcodes : {1:0}
}

export const main = app(state, requests, Encode, document.body)
