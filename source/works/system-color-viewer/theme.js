// 色々な関数
// 要素の背景色を返す
function getCurrentColor(element) {
  return getComputedStyle(element).backgroundColor
}
// 色の値をセット / 変更する
function setCurrentColor(element) {
  if (element.previousElementSibling === null) {
    const code = document.createElement('code')
    code.classList.add('color-code')
    element.insertAdjacentElement('beforebegin', code)
  }
  const target = element.previousElementSibling
  target.textContent = getCurrentColor(element)
}
// 前準備色々
const root = document.documentElement
// カラーチップのリスト
const colorChips = document.querySelectorAll('.color-chip')
colorChips.forEach(element => setCurrentColor(element))
// ラジオボタンが変更されたら
const myForm = document.querySelector('.selector')
myForm.addEventListener('change', (e) => {
  const mode = e.target.value
  // カラースキームを切り替えて
  if (mode === 'system') {
    delete root.dataset.userTheme
  } else {
    root.dataset.userTheme = mode
  }
  // カラーコードをアップデート
  colorChips.forEach(element => setCurrentColor(element))
})
