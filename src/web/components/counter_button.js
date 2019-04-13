import { h } from 'hyperapp'

export const CounterButton = ({ label, onclick }) => (
  <button onclick={onclick}>{label}</button>
)