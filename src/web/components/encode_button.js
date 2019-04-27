import { h } from 'hyperapp'

export const EncodeButton = ({ label, onclick }) => (
    <button onclick={onclick}>{label}</button>
)
