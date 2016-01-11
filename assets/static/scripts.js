"use strict";

var add_sidebar_gloss = function(node, dest) {
  node.classList.add("post-gloss__in-sidebar");
  dest.insertBefore(node, dest.firstChild);
};

(function create_sidebar_glosses_from_footnotes() {
  var footnotes = document.getElementsByClassName("footnote");
  [].forEach.call(footnotes, function(_, i) {
    var nr = i+1;
    var content = document.getElementById("fn:"+nr);
    var dest = document.getElementById("fnref:"+nr);
    var clone = content.cloneNode(true);

    add_sidebar_gloss(clone.firstElementChild, dest);
  });
}());

var show_label = function() {
  var label = this.getElementsByClassName("icon__label")[0];
  label.style.display = "block";
};

var hide_label = function() {
  var label = this.getElementsByClassName("icon__label")[0];
  label.style.display = "none";
};

(function add_event_listeners_to_menu_icons() {
  var icons = document.getElementsByClassName("icon--navi");
  [].forEach.call(icons, function(icon, i) {
    icon.addEventListener("mouseover", show_label);
    icon.addEventListener("mouseout",  hide_label);
  });
}());
