state = {
  search_word: "",
  encoded_search_word: "",
}

actions = {
  update_search_word: -> (state, value) {
    state[:search_word] = value
    state[:encoded_search_word] = encode_uri(value)
  },
}

# FIXME: ruby.wasmでURI.encodeが使えないため自前で実装している
def encode_uri(str)
  return "" unless str

  # URLエンコードする文字を指定
  special_characters = /[^A-Za-z0-9\-._~]/

  str.gsub(special_characters) do |match|
    "%" + match.unpack("H2" * match.bytesize).join("%").upcase
  end
end

view = ->(state, actions) {
  eval DomParser.parse(<<~HTML)
    <div>
      <div class="mb-3">
        <label for="search_word" class="form-label">検索ワード</label>
        <input type="text" class="form-control" id="search_word" placeholder="検索ワード"
          onchange="{->(e) { actions[:update_search_word].call(state, e[:target][:value].to_s) } }"
        />
      </div>
      <div class="mb-3">
        <a class="btn btn-info" role="button" target="_blank" rel="noopener" href="https://www.b-ch.com/search/text/?search_txt=#{state[:encoded_search_word]}">バンダイチャンネルで「#{state[:search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a class="btn btn-dark" role="button" target="_blank" rel="noopener" href="https://ch.nicovideo.jp/search/#{state[:encoded_search_word]}?type=channel&mode=s&sort=c&order=d">ニコニコチャンネルで「#{state[:search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a class="btn btn-primary" role="button" target="_blank" rel="noopener" href="https://animestore.docomo.ne.jp/animestore/sch_pc?vodTypeList=svod_tvod&searchKey=#{state[:encoded_search_word]}">dアニメストアで「#{state[:search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a class="btn btn-warning" role="button" target="_blank" rel="noopener" href="https://www.amazon.co.jp/s?i=instant-video&k=#{state[:encoded_search_word]}">Amazon プライム・ビデオで「#{state[:search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a class="btn btn-danger" role="button" target="_blank" rel="noopener" href="https://www.google.com/search?q=site%3Awww.netflix.com+#{state[:encoded_search_word]}">Netflixで「#{state[:search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
        <a class="btn btn-success" role="button" target="_blank" rel="noopener" href="https://abema.tv/search?q=#{state[:encoded_search_word]}">Abemaで「#{state[:search_word]}」を検索する<i class="bi bi-box-arrow-up-right"></i></a>
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
