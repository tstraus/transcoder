import { app } from 'hyperapp'
import { Counter } from './components/counter'
import { actions } from './actions'

const state = {
  count: 0
}

export const main = app(state, actions, Counter, document.body)
