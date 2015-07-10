$(document).ready(function () {
var headroom = new Headroom(document.querySelector("header"), {
  "tolerance": 5,
  "offset": 205,
  "classes": {
    "initial": "animated",
    "pinned": "swingInX",
    "unpinned": "swingOutX"
  }
});
headroom.init();
});

function login () {
	$("#nav-item-show ul li a").eq(0).text("tanshuai");
	$("#login-form").modal("hide");
}
