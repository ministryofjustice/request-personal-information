import { initAll } from "govuk-frontend";

initAll();

// Hide cookie banner
var cookieBanners = document.getElementsByClassName("govuk-cookie-banner");
if (cookieBannerElements.length) {
  var cookieBanner = cookieBanners[0];
  var hideButtons = cookieBanner.getElementsByClassName('cookie-hide-button');

  if (hideButtons.length) {
    var hideButton = hideButtons[0];
    hideButton.addEventListener("click", function(e) {
      e.preventDefault();
      cookieBanner.style.display = 'none';
    });
  }
}
