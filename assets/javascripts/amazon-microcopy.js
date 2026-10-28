export async function amazonMicrocopy () {
  const targets = document.querySelectorAll('.affiliate-action > .affiliate-link._for-amazon')
  if (targets.length >= 1) {
    console.log(`amazonMicrocopy: ${targets.length} affiliate link(s) found`)
    const endpoint = '/.netlify/functions/amazon-sale'
    const response = await fetch(endpoint)
    const data = await response.json()

    if (data.totalCount >= 1) {
      const content = data.contents[0]
      const microCopyElm = document.createElement('strong')
      microCopyElm.classList.add('affiliate-onsale')
      microCopyElm.textContent = content.copy

      targets.forEach(target => {
        const injectElm = microCopyElm.cloneNode(true)
        target.insertAdjacentElement('beforebegin', injectElm)
      })
    } else if (data.totalCount === -1) {
      console.log(`amazonMicrocopy: Some error occurred: ${data.error}`)
    } else {
      console.log('amazonMicrocopy: No sale found')
    }
  } else {
    console.log('amazonMicrocopy: No affiliate link found')
  }
}
