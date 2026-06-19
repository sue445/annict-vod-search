begin
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

  state = {
    search_word: "",
    search_word_url_encoded: "",
  }

  methods = {
    update_search_word: -> (event, state) {
      value = event[:target][:value].to_s
      state[:search_word] = value.strip.gsub("　", " ")
      state[:search_word_url_encoded] = url(state[:search_word])
    },
  }

  template = <<~HTML
    <div>
      <div class="mb-3">
        <label for="search_word" class="form-label">検索ワード</label>
        <input type="text" class="form-control" id="search_word" placeholder="アニメのタイトル"
          @keyup="update_search_word"
        />
      </div>
      <div class="mb-3">
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger" href="https://annict.com/search?q={{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          Annictで「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-info" href="https://www.b-ch.com/search/text/?search_txt={{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          バンダイチャンネル(チャンネルID=107)で「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-dark" href="https://ch.nicovideo.jp/search/{{ search_word_url_encoded }}?type=channel&mode=s&sort=c&order=d">
          <i class="bi bi-search"></i>
          ニコニコチャンネル(チャンネルID=165)で「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-primary" href="https://animestore.docomo.ne.jp/animestore/sch_pc?vodTypeList=svod_tvod&searchKey={{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          dアニメストア(チャンネルID=241)で「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-warning" href="https://www.amazon.co.jp/s?i=instant-video&k={{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          Amazon プライム・ビデオ(チャンネルID=243)で「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger" href="https://www.netflix.com/search?q={{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          Netflix(チャンネルID=244)で「{{ search_word }}」を検索する(ログイン版)
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-danger" href="https://www.google.com/search?q=site%3Awww.netflix.com+{{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          Netflix(チャンネルID=244)で「{{ search_word }}」を検索する(未ログイン版)
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-success" href="https://abema.tv/search?q={{ search_word_url_encoded }}">
          <i class="bi bi-search"></i>
          Abema(チャンネルID=260)で「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
        <a role="button" target="_blank" rel="noopener" class="btn btn-dark" href="https://ch.nicovideo.jp/search/{{ search_word_url_encoded }}?channel_id=ch2632720&mode=s&sort=t&order=d&type=video">
          <i class="bi bi-search"></i>
          dアニメストア ニコニコ支店(チャンネルID=306)で「{{ search_word }}」を検索する
          <i class="bi bi-box-arrow-up-right"></i>
        </a>
      </div>
    </div>
  HTML

  RbWasmVdom.create_app(
    "#app",
    template: template,
    state: state,
    methods: methods,
  )

rescue Exception => e
  message = "#{e.class}: #{e.message}\n#{e.backtrace&.join("\n")}"
  JS.global[:console].error(message)
end
