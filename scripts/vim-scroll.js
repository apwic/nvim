document.addEventListener('keydown', function(e) {
  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.isContentEditable) return;

  var scrollAmount = 40;
  var pageAmount = window.innerHeight / 2;

  switch (true) {
    case e.key === 'j' && !e.ctrlKey: window.scrollBy(0, scrollAmount); break;
    case e.key === 'k' && !e.ctrlKey: window.scrollBy(0, -scrollAmount); break;
    case e.key === 'h' && !e.ctrlKey: window.scrollBy(-scrollAmount, 0); break;
    case e.key === 'l' && !e.ctrlKey: window.scrollBy(scrollAmount, 0); break;
    case e.key === 'd' && e.ctrlKey: e.preventDefault(); window.scrollBy(0, pageAmount); break;
    case e.key === 'u' && e.ctrlKey: e.preventDefault(); window.scrollBy(0, -pageAmount); break;
    case e.key === 'g' && !e.ctrlKey: window.scrollTo(0, 0); break;
    case e.key === 'G' && !e.ctrlKey: window.scrollTo(0, document.body.scrollHeight); break;
    default: return;
  }
});
