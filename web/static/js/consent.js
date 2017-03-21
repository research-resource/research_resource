module.exports = (function() {
  var noConsent = document.querySelectorAll(".no-consent");
  var yesConsent = document.querySelectorAll(".yes-consent");

  noConsent.forEach(function(el){
    el.addEventListener("click", function (e) {
      var index = e.target.id[e.target.id.length - 1];
      document.getElementById("error-consent-" + index).classList.remove("dn");
      checkAllAnswered();
    });
  });

  yesConsent.forEach(function(el, i, a){
    el.addEventListener("click", function (e) {
      var index = e.target.id[e.target.id.length - 1];
      document.getElementById("error-consent-" + index).classList.add("dn");
      checkAllAnswered();
    });
  });
})();

function checkAllAnswered() {
  var checked = document.querySelectorAll("input.yes-consent[type=radio]:checked");
  var count = document.querySelectorAll(".yes-consent");

  if (checked.length === count.length) {
    nextButton('active');
  } else {
    nextButton('inactive')
  }
}

function nextButton (state) {
  var nextActive = document.querySelector("#next-active");
  var nextInactive = document.querySelector("#next-inactive");

  if (state === 'active') {
    nextActive.classList.remove('dn');
    nextActive.classList.add('dib');
    nextInactive.classList.remove('dib');
    nextInactive.classList.add('dn');
  } else if (state === 'inactive') {
    nextInactive.classList.remove('dn');
    nextInactive.classList.add('dib');
    nextActive.classList.remove('dib');
    nextActive.classList.add('dn');
  }
}
