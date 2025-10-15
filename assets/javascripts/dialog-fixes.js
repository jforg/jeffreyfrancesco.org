export function dialogFixes () {
  // スクリプトを抜ける判断に使う
  let invokerCommandsSupportFlag = 0

  const dialogs = document.querySelectorAll('dialog')
  // break で抜け出せるように `for..of` を使用する
  for (const dialog of dialogs) {
    // 1. Invoker Comannds API のフォールバック
    const id = dialog.id
    const buttons = document.querySelectorAll(`[commandfor="${id}"]`)
    // ここも同様
    for (const button of buttons) {
      if (typeof button.command !== 'undefined') {
        invokerCommandsSupportFlag = 1
        console.log('JS binding is skipped: this browser supports Invoker Commands API')
        break
      }
      console.log('Binding JS for button.command …')
      const command = button.getAttribute('command')
      switch (command) {
        case 'show-modal':
          button.addEventListener('click', () => dialog.showModal())
          console.log('command is "show-modal"')
          break
        case 'close':
          button.addEventListener('click', () => dialog.close())
          console.log('command is "close"')
          break
        // 今んとこ他は使わないので、とりあえずあとは無視で…
        default:
          console.log(`Sorry, command "${command}" is not supported by this script.`)
      }
    }

    // 2. dialog.closedBy のフォールバック
    if (typeof dialog.closedBy !== 'undefined') {
      console.log('JS binding is skipped: This browser supports closedBy property on <dialog> element.')
      if (invokerCommandsSupportFlag) {
        // 両方サポートしていたらこのスクリプトは無駄なので終了
        console.log('This browser is full supported for <dialog> element!')
        return
      } else {
        // Invoker Command に非対応だったら
        // ダイアログ分は 1. を繰り返さないといけない
        // break だとループが終わってしまうのでダメ
        continue
      }
    }
    console.log('Binding JS for dialog.closedBy …')
    const action = dialog.getAttribute('closedby')
    switch (action) {
      case 'any':
        dialog.addEventListener('click', e => {
          // dialog 要素のボックス範囲外だったら閉じるための変数
          // ちなみに `e.target.closest` を探す方法を使わないのは
          // dialog 直下にラッパー的な要素を加える必要があるのと
          // その関係上どうしてもスタイリングに制限がかかるため…
          const range = dialog.getBoundingClientRect()
          const inRange = (
            range.left <= e.clientX &&
                          e.clientX <= range.right &&
            range.top  <= e.clientY &&
                          e.clientY <= range.bottom
          )
          if (!inRange) dialog.close()
        })
        console.log('closedBy is "any"')
        break
      case 'none':
        dialog.addEventListener('cancel', e => e.preventDefault())
        console.log('closedBy is "none"')
        break
      case 'closerequest':
        console.log('closedBy is "closerequest"')
        break
      default:
        console.log(`Warning: Invalid attribute "${action}" specified. Treating as browser’s default.`)
    }
  }
}
