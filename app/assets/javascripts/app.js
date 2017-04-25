window.fbAsyncInit = function() {
  FB.init({
    appId      : AppConfig.Facebook.appId,
    xfbml      : true,
    version    : 'v2.7'
  });
  FB.AppEvents.logPageView();
  // FB.AppEvents.logEvent(AppConfig.Rails.controller + "|" + AppConfig.Rails.action);
};
(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/" + AppConfig.Facebook.locale + "/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

(function(d, s, id){
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.com/" + AppConfig.Facebook.locale + "/messenger.Extensions.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'Messenger'));

$(document).ready(function(){

  $('[data-fullpage]').fullpage({
	  verticalCentered: true,
    navigation: false
  });

});