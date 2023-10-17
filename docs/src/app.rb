state = {
  search_word: "",
}

actions = {
  update_search_word: -> (state, value) {
    state[:search_word] = value
  },
}

view = ->(state, actions) {
  eval DomParser.parse(<<~HTML)
    <div>
      <div class="mb-3">
        <label for="search_word" class="form-label">検索ワード</label>
        <input type="text" class="form-control" id="search_word" placeholder="検索ワード"
          onchange="{->(e) { actions[:update_search_word].call(state, e[:target][:value].to_s) } }"
        />
      </div>

      <div class="btn-group">
        <a class="btn btn-primary" role="button" target="_blank" href="https://animestore.docomo.ne.jp/animestore/sch_pc?searchKey=#{state[:search_word]}&vodTypeList=svod_tvod">dアニメストアで検索する<i class="bi bi-box-arrow-up-right"></i></a>
      </div>
    </div>
  HTML
}

App.new(
  el: "#app",
  state:,
  view:,
  actions:
)
