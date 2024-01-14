require "cgi"

# URL encode helper
def url(value)
  CGI.escape(value)
end

# HTML encode helper
def html(value)
  # FIXME: Workaround for syntax error
  value = value.gsub("'", "\\\\'")

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
  eval RubyWasmVdom::DomParser.parse(<<~HTML)
    <div>
      <div class="mb-3">
        <label for="search_word" class="form-label">検索ワード</label>
        <input type="text" class="form-control" id="search_word" placeholder="アニメのタイトル"
          onchange="{->(e) { actions[:update_search_word].call(state, e[:target][:value].to_s) } }"
          oninput="{->(e) { actions[:update_search_word].call(state, e[:target][:value].to_s) } }"
        />
      </div>
      <div class="mb-3">
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger" href="https://annict.com/search?q=#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          Annictで「#{html(state[:search_word])}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-info" href="https://www.b-ch.com/search/text/?search_txt=#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          バンダイチャンネル(チャンネルID=107)で「#{html(state[:search_word])}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-dark" href="https://ch.nicovideo.jp/search/#{url(state[:search_word])}?type=channel&mode=s&sort=c&order=d">
          <i class="bi bi-search"></i>
          ニコニコチャンネル(チャンネルID=165)で「#{html(state[:search_word])}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-primary" href="https://animestore.docomo.ne.jp/animestore/sch_pc?vodTypeList=svod_tvod&searchKey=#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          dアニメストア(チャンネルID=241)で「#{html(state[:search_word])}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-warning" href="https://www.amazon.co.jp/s?i=instant-video&k=#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          Amazon プライム・ビデオ(チャンネルID=243)で「#{html(state[:search_word])}」を検索する
          <i class="bi bi-box-arrow-up-right"></i></a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger" href="https://www.netflix.com/search?q=#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          Netflix(チャンネルID=244)で「#{html(state[:search_word])}」を検索する(ログイン版)
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger" href="https://www.google.com/search?q=site%3Awww.netflix.com+#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          Netflix(チャンネルID=244)で「#{html(state[:search_word])}」を検索する(未ログイン版)
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-success" href="https://abema.tv/search?q=#{url(state[:search_word])}">
          <i class="bi bi-search"></i>
          Abema(チャンネルID=260)で「#{html(state[:search_word])}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
      </div>
    </div>
  HTML
}

RubyWasmVdom::App.new(
  el: "#app",
  state:,
  view:,
  actions:
)
