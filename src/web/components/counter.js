import { h } from 'hyperapp'
import { CounterButton } from './counter_button'

export const Counter = (state, actions) => (
  <main>
    <h1>{state.count}</h1>
    <CounterButton label={'+'} onclick={actions.up} />
    <CounterButton label={'-'} onclick={actions.down} />
  </main>
)