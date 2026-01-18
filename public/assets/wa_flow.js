(function(){
  function qs(k){ return new URLSearchParams(location.search).get(k) || ""; }
  var wa = "8618857277313";
  var country = (qs("country") || (location.pathname.split("/")[1] || "global")).toUpperCase();
  var persona = qs("persona") || "buyer";
  var need = qs("need") || "quote";
  var msg = [
    "Hi LEISA, I'm contacting from " + country + ".",
    "I need: " + need + ".",
    "Persona: " + persona + ".",
    "Please send: MOQ + lead time + best-sellers + certifications + price tiers."
  ].join("%0A");
  var link = "https://wa.me/" + wa + "?text=" + msg;

  var btn = document.getElementById("btn-wa-quote");
  if(btn){ btn.setAttribute("href", link); }

  // Optional: track click (no cookies; simple beacon)
  try{
    document.addEventListener("click", function(e){
      var t = e.target;
      if(t && t.id === "btn-wa-quote"){
        navigator.sendBeacon && navigator.sendBeacon("/api/track", JSON.stringify({event:"wa_quote_click", country:country, ts:Date.now()}));
      }
    });
  }catch(_){}
})();
