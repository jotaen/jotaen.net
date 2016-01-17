"use strict";

// Add a gloss (sidenote) into the sidebar
// - node: the gloss DOM node
// - dest: the
var add_inline_gloss = function(node, dest) {
  node.classList.add("post-gloss__in-sidebar");
  dest.insertBefore(node, dest.firstChild);
};

(function create_sidebar_glosses_from_footnotes(document) {
  var footnotes = document.getElementsByClassName("footnote");
  [].forEach.call(footnotes, function(_, i) {
    var nr = i+1;
    var content = document.getElementById("fn:"+nr);
    var dest = document.getElementById("fnref:"+nr);
    var clone = content.cloneNode(true);

    add_inline_gloss(clone.firstElementChild, dest);
  });
}(document));

var show_label = function() {
  var label = this.getElementsByClassName("icon__label")[0];
  label.style.display = "block";
};

var hide_label = function() {
  var label = this.getElementsByClassName("icon__label")[0];
  label.style.display = "none";
};

(function add_event_listeners_to_menu_icons(document) {
  var icons = document.getElementsByClassName("icon--navi");
  [].forEach.call(icons, function(icon, i) {
    icon.addEventListener("mouseover", show_label);
    icon.addEventListener("mouseout",  hide_label);
  });
}(document));

(function reveal_email(document, window) {
  var links = document.getElementsByTagName('a');
  var popup = function() {
    window.open("http://www.google.com/recaptcha/mailhide/d?k=01AxKftslD25l2Xrd7GQrq3A==&c=yzyOzUPufidKpnaMgGVxAw==", "", "toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=500,height=300");
    return false;
  };
  [].forEach.call(links, function(link) {
    if (link.getAttribute("href") == "mailto:j...@jotaen.net") {
      link.setAttribute("href", "http://www.google.com/recaptcha/mailhide/d?k=01AxKftslD25l2Xrd7GQrq3A==&c=yzyOzUPufidKpnaMgGVxAw==");
      link.setAttribute("title", "I’m so sorry for that captcha hassle, but you know how it is :(");
      link.onclick = popup;
    }
  });
}(document, window));
