// Hide 'Request Call Back' module when it starts to overlap footer
(function(){
  var requestCall = document.getElementById('request-call-about');
  var requestCallFooter = document.getElementById('request-call-footer');
  var footer = document.querySelector('footer');
  var signUpFooter = document.getElementById('about-signup');

  if (requestCall && requestCallFooter) {
    var limit = requestCall.offsetTop + requestCall.offsetHeight +
    requestCallFooter.offsetHeight + footer.offsetHeight + (signUpFooter && signUpFooter.offsetHeight);

    document.addEventListener('scroll', function(){
      if (document.body.offsetHeight - document.body.scrollTop < limit) {
        requestCall.classList.remove('db-ns')
        requestCall.classList.add('dn-ns')
      } else {
        requestCall.classList.add('db-ns')
        requestCall.classList.remove('dn-ns')
      }
    });
  }
}());
