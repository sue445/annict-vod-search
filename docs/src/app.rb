state = {
  count: 0,
}

actions = {
  increment: ->(state, value) {
    state[:count] += 1
  }
}

view = ->(state, actions) {
  eval DomParser.parse(<<~HTML)
    <div>
      <button onclick='{->(e) { actions[:increment].call(state, nil) } }'>Click me!</button>
      <p>{"Count is #{state[:count]}"}</p>
    </div>
  HTML
}

App.new(
  el: "#app",
  state:,
  view:,
  actions:
)
