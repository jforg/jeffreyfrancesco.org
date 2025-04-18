import blankFontFile from '../fonts/JFBlank.woff2'

const blankFont = new FontFace('JFBlank', `url(${blankFontFile})`)
const initFontDetector = blankFont.load().then(
  (font) => {
    document.fonts.add(font)
    console.log(`Add blank font: ${font.family}`)
  
    const root = document.documentElement
    const detector = document.createElement('div')
    detector.textContent = 'JF'
    detector.style.position = 'fixed'
    detector.style.top = '-10em'
    document.body.insertAdjacentElement('afterbegin', detector)
  
    const check = (classString, fonts) => {
      detector.style.fontFamily = `${fonts}, JFBlank`
      const result = Boolean(detector.offsetWidth)
      const classPrefix = result ? '_has' : '_no'
      console.log(`checking "${fonts}" … ${result.toString()}`)
      root.classList.add(`${classPrefix}-${classString}`)
      return result
    }
    const destroy = () => {
      console.log('destroy called: Remove detector element')
      detector.remove()
    }
  
    return {
      check: check,
      destroy: destroy
    }
  }
)

export { initFontDetector }
