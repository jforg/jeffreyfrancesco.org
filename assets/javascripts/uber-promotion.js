export async function uberPromotion () {
  const formatter = new Intl.DateTimeFormat('ja-JP', {
    dateStyle: 'long',
    timeZone: 'Asia/Tokyo'
  })
  const targets = document.querySelectorAll('[data-uberpromo]')
  if (targets.length >= 1) {
    console.log(`uberPromotion: ${targets.length} affiliate link(s) found`)
    const endpoint = '/.netlify/functions/uber-promo'
    const response = await fetch(endpoint)
    const data = await response.json()

    if (data.totalCount >= 1) {
      const content = data.contents[0]
      // プロモコード
      const promoCode = content.code
      // リード文
      const promoText = content.text || '最初の4回の注文が50%OFF! 初回登録限定プロモーションコードはこちら：'
      // 詳細テキスト
      // 取得データが空だった時の登録期限を終了日時から設定
      const promoEndDate = new Date(content.to)
      promoEndDate.setDate(promoEndDate.getDate() - 1)
      const formattedDate = formatter.format(promoEndDate)
      const promoNote = content.note || `登録期限${formattedDate}、全体使用上限回数1,500回。最低注文金額1,500円・各注文につき最大1,500円割引など、利用条件があります。`

      targets.forEach(target => {
        const promoTextElm = target.querySelector('[data-uberpromo-text]')
        const promoCodeElm = target.querySelector('[data-uberpromo-code]')
        const promoNoteElm = target.querySelector('[data-uberpromo-note]')

        promoTextElm.textContent = promoText
        promoCodeElm.textContent = promoCode
        promoNoteElm.textContent = promoNote
      })
    } else if (data.totalCount === -1) {
      console.log(`uberPromotion: Some error occurred: ${data.error}`)
    } else {
      console.log('uberPromotion: No sale found')
    }
  } else {
    console.log('uberPromotion: No affiliate link found')
  }
}
