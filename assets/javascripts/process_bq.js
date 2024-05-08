export function processBq() {
  const blockquotes = document.querySelectorAll('blockquote[title], blockquote[cite]');
  blockquotes.forEach(elm => {
    const footer = document.createElement('footer');
    const title = document.createTextNode(elm.title || elm.cite);
    if (elm.cite) {
      const anchor = document.createElement('a');
      anchor.href = elm.cite;
      anchor.appendChild(title);
      footer.appendChild(anchor);
    } else {
      footer.appendChild(title);
    }
    elm.appendChild(footer);
  })
}
