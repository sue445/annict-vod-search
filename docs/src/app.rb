require "cgi"

state = {
  search_word: "",
  encoded_search_word: "",
  escaped_search_word: "",
}

actions = {
  update_search_word: -> (state, value) {
    value = value.strip
    state[:search_word] = value
    state[:encoded_search_word] = CGI.escape(value)
    state[:escaped_search_word] = CGI.escapeHTML(value)
  },
}

view = ->(state, actions) {
  eval DomParser.parse(<<~HTML)
    <div>
      <div class="mb-3">
        <label for="search_word" class="form-label">検索ワード</label>
        <input type="text" class="form-control" id="search_word" placeholder="検索ワード"
          onchange="{->(e) { actions[:update_search_word].call(state, e[:target][:value].to_s) } }"
          oninput="{->(e) { actions[:update_search_word].call(state, e[:target][:value].to_s) } }"
        />
      </div>
      <div class="mb-3">
        <a role="button" target="_blank" rel="noopener" class="btn btn-info"    href="https://www.b-ch.com/search/text/?search_txt=#{state[:encoded_search_word]}"><i class="bi bi-search"></i>バンダイチャンネルで「#{state[:escaped_search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-dark"    href="https://ch.nicovideo.jp/search/#{state[:encoded_search_word]}?type=channel&mode=s&sort=c&order=d"><i class="bi bi-search"></i>ニコニコチャンネルで「#{state[:escaped_search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-primary" href="https://animestore.docomo.ne.jp/animestore/sch_pc?vodTypeList=svod_tvod&searchKey=#{state[:encoded_search_word]}"><i class="bi bi-search"></i>dアニメストアで「#{state[:escaped_search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-warning" href="https://www.amazon.co.jp/s?i=instant-video&k=#{state[:encoded_search_word]}"><i class="bi bi-search"></i>Amazon プライム・ビデオで「#{state[:escaped_search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger"  href="https://www.google.com/search?q=site%3Awww.netflix.com+#{state[:encoded_search_word]}"><i class="bi bi-search"></i>Netflixで「#{state[:escaped_search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-success" href="https://abema.tv/search?q=#{state[:encoded_search_word]}"><i class="bi bi-search"></i>Abemaで「#{state[:escaped_search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
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
