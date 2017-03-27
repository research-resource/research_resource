var noConsent = document.querySelectorAll(".no-consent");
var yesConsent = document.querySelectorAll(".yes-consent");

[].forEach.call(noConsent, function(el){
  el.addEventListener("click", function (e) {
    if(e.target.name[e.target.name.length - 2] === "y") {
      var index = e.target.id[e.target.id.length - 1];
      document.getElementById("error-consent-" + index).classList.remove("dn");
    }
    checkAllAnswered();
  });
});

[].forEach.call(yesConsent, function(el, i, a){
  el.addEventListener("click", function (e) {
    var index = e.target.id[e.target.id.length - 1];
    document.getElementById("error-consent-" + index).classList.add("dn");
    checkAllAnswered();
  });
});

function checkAllAnswered() {
  var checked = document.querySelectorAll("input[type=radio]:checked");
  var count = document.querySelectorAll(".yes-consent");

  if (checkRequired() && checked.length === count.length) {
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

function checkRequired() {
  var allButtons = document.querySelectorAll("input.yes-consent[type=radio]");

  var required = [].filter.call(allButtons, function(el) {
    return el.name[el.name.length - 2] === "y";
  });

  var requiredChecked = [].filter.call(required, function(el) {
    return el.checked;
  });

  return requiredChecked.length === required.length;
}
