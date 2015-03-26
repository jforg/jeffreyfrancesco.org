// Search query append to title and heading, and set value attr on textfield
(function(w,d){
  var
    s = '',
    m = d.getElementById('search-keyword'),
    t = d.head.getElementsByTagName('title').item(0),
    i = d.getElementById('cse-search-query'),
    q = w.location.search.match(/[?&]q=(.*?)(?:[&]|$)/)[1].replace(/\+/g,' ');
  try {
    s = decodeURIComponent(q);
  } catch(e) {
    s = '(???)';
  }
  var a = d.createTextNode(s + ' の'),
      b = d.createTextNode(s)
  t.insertBefore(a,t.firstChild);
  m.appendChild(b);
  i.value = s !== '(???)' ? s : ''
})(window, document);

// Google search script
(function() {
  var cx = 'partner-pub-8470388415032156:7363443192';
  var gcse = document.createElement('script');
  gcse.type = 'text/javascript';
  gcse.async = true;
  gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
      '//www.google.com/cse/cse.js?cx=' + cx;
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(gcse, s);
})();
