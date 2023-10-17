state = {
  count: 0,
}

actions = {
  increment: ->(state, value) {
    state[:count] += 1
  }
}

view = ->(state, actions) {
  h(:div, {}, [
    h(:button, { onclick: ->(e) { actions[:increment].call(state, nil) } }, ['Click me!']),
    h(:p, {}, ["Count is #{state[:count]}"])
  ])
}

App.new(
  el: "#app",
  state:,
  view:,
  actions:
)
