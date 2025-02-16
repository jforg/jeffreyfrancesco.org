export function processBq() {
  const blockquotes = document.querySelectorAll(':not(figure) > blockquote:not(.no-process)')
  blockquotes.forEach(elm => {
    const figure = document.createElement('figure')
    const caption = document.createElement('figcaption')
    const titleText = elm.title || elm.cite
    if (titleText) {
      const cite = document.createElement('cite')
      if (elm.cite) {
        const anchor = document.createElement('a')
        anchor.href = elm.cite
        anchor.textContent = titleText
        cite.appendChild(anchor)
      } else {
        cite.textContent = titleText
      }
      figure.appendChild(caption).appendChild(cite)
    }
    elm.parentNode.insertBefore(figure, elm)
    figure.insertAdjacentElement('afterbegin', elm)
    figure.classList.add('quote')
  })
}
