// Hide 'Request Call Back' module when it starts to overlap footer
(function(){
  var requestCall = document.getElementById('request-call-about');
  var requestCallFooter = document.getElementById('request-call-footer');
  var footer = document.querySelector('footer');

  if (requestCall && requestCallFooter) {
    var limit = requestCall.offsetTop + requestCall.offsetHeight + requestCallFooter.offsetHeight + footer.offsetHeight;

    document.addEventListener('scroll', function(){
      if (document.body.offsetHeight - document.body.scrollTop < limit) {
        requestCall.classList.add('dn')
      } else {
        requestCall.classList.remove('dn')
      }
    });
  }
}());
