import { h } from 'hyperapp'
import { EncodeButton } from './encode_button'

export const Encode = (state, requests) => (
    <main oncreate={requests.open}>
        <EncodeButton label={'encode'} onclick={requests.encode} />
    </main>
)
