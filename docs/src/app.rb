require "cgi"

# URL encode
def u(value)
  CGI.escape(value)
end

# HTML encode
def e(value)
  CGI.escapeHTML(value)
end

state = {
  search_word: "",
}

actions = {
  update_search_word: -> (state, value) {
    state[:search_word] = value.strip
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
        <a role="button" target="_blank" rel="noopener" class="btn btn-info"    href="https://www.b-ch.com/search/text/?search_txt=#{u(state[:search_word])}"><i class="bi bi-search"></i>バンダイチャンネルで「#{e(state[:search_word])}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-dark"    href="https://ch.nicovideo.jp/search/#{u(state[:search_word])}?type=channel&mode=s&sort=c&order=d"><i class="bi bi-search"></i>ニコニコチャンネルで「#{e(state[:search_word])}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-primary" href="https://animestore.docomo.ne.jp/animestore/sch_pc?vodTypeList=svod_tvod&searchKey=#{u(state[:search_word])}"><i class="bi bi-search"></i>dアニメストアで「#{e(state[:search_word])}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-warning" href="https://www.amazon.co.jp/s?i=instant-video&k=#{u(state[:search_word])}"><i class="bi bi-search"></i>Amazon プライム・ビデオで「#{e(state[:search_word])}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger"  href="https://www.google.com/search?q=site%3Awww.netflix.com+#{u(state[:search_word])}"><i class="bi bi-search"></i>Netflixで「#{e(state[:search_word])}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-success" href="https://abema.tv/search?q=#{u(state[:search_word])}"><i class="bi bi-search"></i>Abemaで「#{e(state[:search_word])}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
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
