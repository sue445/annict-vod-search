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

      <a class="btn btn-info" role="button" target="_blank" href="https://www.b-ch.com/search/text/?search_txt=#{state[:search_word]}">バンダイチャンネルで検索する<i class="bi bi-box-arrow-up-right"></i></a>
      <a class="btn btn-dark" role="button" target="_blank" href="https://ch.nicovideo.jp/search/#{state[:search_word]}?type=channel&mode=s&sort=c&order=d">ニコニコチャンネルで検索する<i class="bi bi-box-arrow-up-right"></i></a>
      <a class="btn btn-primary" role="button" target="_blank" href="https://animestore.docomo.ne.jp/animestore/sch_pc?vodTypeList=svod_tvod&searchKey=#{state[:search_word]}">dアニメストアで検索する<i class="bi bi-box-arrow-up-right"></i></a>
      <a class="btn btn-warning" role="button" target="_blank" href="https://www.amazon.co.jp/s?i=instant-video&k=#{state[:search_word]}">Amazon プライム・ビデオで検索する<i class="bi bi-box-arrow-up-right"></i></a>
      <a class="btn btn-danger" role="button" target="_blank" href="https://www.google.com/search?q=site%3Awww.netflix.com+#{state[:search_word]}">Netflixで検索する<i class="bi bi-box-arrow-up-right"></i></a>
      <a class="btn btn-success" role="button" target="_blank" href="https://abema.tv/search?q=#{state[:search_word]}">Abemaで検索する<i class="bi bi-box-arrow-up-right"></i></a>
    </div>
  HTML
}

App.new(
  el: "#app",
  state:,
  view:,
  actions:
)
