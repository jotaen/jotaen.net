"use strict";

var add_sidebar_gloss = function(node, dest) {
  node.classList.add("post-gloss__in-sidebar");
  dest.insertBefore(node, dest.firstChild);
};

(function create_sidebar_gloss_from_footnote() {
  var refs = document.getElementsByClassName("footnote");
  [].forEach.call(refs, function(node, i) {
    var nr = i+1;
    var content = document.getElementById("fn:"+nr);
    var dest = document.getElementById("fnref:"+nr);
    var clone = content.cloneNode(true).firstElementChild;

    add_sidebar_gloss(clone, dest);
  });
}());
