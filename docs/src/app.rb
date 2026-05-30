# URL encode helper
def url(value)
  result = ""
  value.to_s.each_byte do |byte|
    c = byte.chr
    # Unreserved characters: alphanumeric and special characters (- _ . ~) remain unchanged
    if (byte >= 97 && byte <= 122) || # a-z
       (byte >= 65 && byte <= 90)  || # A-Z
       (byte >= 48 && byte <= 57)  || # 0-9
       c == '-' || c == '_' || c == '.' || c == '~'
      result << c
      # Space is converted to '+'
    elsif c == ' '
      result << '+'
      # Other characters are encoded to percent-encoding (%XX format)
    else
      hex = byte.to_s(16).upcase
      hex = "0#{hex}" if hex.length == 1
      result << "%#{hex}"
    end
  end
  result
end

# HTML encode helper
def html(value)
  # FIXME: Workaround for syntax error
  value = value.gsub("'", "\\\\'")

  value.to_s
     .gsub('&', '&amp;')
     .gsub('<', '&lt;')
     .gsub('>', '&gt;')
     .gsub('"', '&quot;')
     .gsub("'", '&#39;')
end

state = {
  search_word: "",
}

actions = {
  update_search_word: -> (state, value) {
    state[:search_word] = value.strip.gsub("　", " ")
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
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
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
        <a role="button" target="_blank" rel="noopener" class="btn btn-dark" href="https://ch.nicovideo.jp/search/#{url(state[:search_word])}?channel_id=ch2632720&mode=s&sort=t&order=d&type=video">
          <i class="bi bi-search"></i>
          dアニメストア ニコニコ支店(チャンネルID=306)で「#{html(state[:search_word])}」を検索する
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
