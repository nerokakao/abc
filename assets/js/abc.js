$(document).ready(function () {
	init();
	news_info_more();
});

function init () {
	$("#hd-news-id").val("0");
}

function datestringformat (string) {
	return string.substring(0, 4) 
		+ "-"
		+ string.substring(4, 6)
		+ "-"
		+ string.substring(6, 8)
		+ " "
		+ string.substring(8, 10)
		+ ":"
		+ string.substring(10, 12)
		+ ":"
		+ string.substring(12, 14)
}

function login () {
	//$("#nav-item-show ul li a").eq(1).text("tanshuai");
	//$("#login-form").modal("hide");
	var username = $("#username").val().trim();
	var password = $("#password").val().trim();

	if (username.length == 0 || password.length == 0) {
		___alert("username/password is nil");
		return;
	}

	$.ajax({
		type: "POST",
		url: "/login",
		data: {
			username: username,
			password: password
		},
		error: function (xmlhttprequest, errorinfo) {
			___alert("error: " + errorinfo);
		},
		success: function (json) {
			if (json.code == "0") {
				___alert(json.msg);
				$("#login-form").modal("hide");
			} else {
				___alert(json.msg);
			}
		},
		complete: function (xhr, ts) {

		}
	});
}

function logout () {
	$.ajax({
		type: "DELETE",
		url: "/logout",
		error: function (xmlhttprequest, errorinfo) {
			alert("error: " + errorinfo);
		},
		success: function (json) {
			console.log(json.msg);
		},
		complete: function (xhr, ts) {

		}
	});
}

function news_info_more () {
	var news_id = $("#hd-news-id").val();
	var url = "/next-ten-news/";

	$.ajax({
		type: "GET",
		url: url + news_id,
		error: function (xmlhttprequest, errorinfo) {
			alert("error: " + errorinfo);
		},
		success: function (json) {
			var last_news_id = create_news_info_list(json);
			$("#hd-news-id").val(last_news_id);
		},
		complete: function (xhr, ts) {

		}
	});
}

function create_news_info_list (json) {
	var parent_id_name = "news-list";
	var child_prefix_id_name = "news-content-";

	//create DOM elements, show in the page with bootstrap
	for (var i = 0; i < json.size; i++) {
		var cs = json.contents[i];

		var d = $(''
		+ ' <div class="panel panel-default">                                                                                                    '
		+ ' 	<div class="panel-heading">                                                                                                      '
		+ ' 		<div class="row">                                                                                                        '
		+ ' 			<div class="col-md-12 text-center">                                                                              '
		+ ' 				<h2>' + cs[2] + '</h2>                                                                        '
		+ ' 			</div>                                                                                                           '
		+ ' 			<div class="col-md-12 text-right">                                                                               '
		+ ' 				<a href="javascript:void(0);" data-toggle="collapse" data-parent="#' + parent_id_name + '" data-target="#' + child_prefix_id_name + cs[0] + '"> '
		+ ' 					<span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span>                      '
		+ ' 					<span>内容</span>                                                                             '
		+ ' 				</a>                                                                                                     '
		+ ' 			</div>                                                                                                           '
		+ ' 		</div>                                                                                                                   '
		+ ' 	</div>                                                                                                                           '
		+ ' 	<div id="' + child_prefix_id_name + cs[0] + '" class="panel-collapse collapse">                                                                            '
		+ ' 		<div class="panel-body">                                                                            '
		+ ' 			' + marked(cs[4]) + '                                                                                                            '
		+ ' 		</div>                                                                                                                   '
		+ ' 	</div>                                                                                                                           '
		+ ' 	<div class="panel-heading">                                                                                                      '
		+ ' 		<div class="row">                                                                                                        '
		+ ' 			<div class="col-md-2">                                                                                           '
		+ ' 				<span class="glyphicon glyphicon-user" aria-hidden="true"></span>                                        '
		+ ' 				<span>' + cs[1] + '</span>                                                                                      '
		+ ' 			</div>                                                                                                           '
		+ ' 			<div class="col-md-3">                                                                                           '
		+ ' 				<span class="glyphicon glyphicon-time" aria-hidden="true"></span>                                        '
		+ ' 				<span>' + datestringformat(cs[5]) + '</span>                                                                         '
		+ ' 			</div>                                                                                                           '
		+ ' 			<div class="col-md-3">                                                                                           '
		+ ' 				<span class="glyphicon glyphicon-tag" aria-hidden="true"></span>                                         '
		+ ' 				<span>' + (cs[3] == ""? "--/--": cs[3]) + '</span>                                                                    '
		+ ' 			</div>                                                                                                           '
		+ ' 			<div class="col-md-2">                                                                                           '
		+ ' 			<!-- heart-empty -->                                                                                             '
		+ ' 				<span class="glyphicon glyphicon-heart" aria-hidden="true"></span>                                       '
		+ ' 				<span>' + cs[6] + '</span>                                                                                         '
		+ ' 			</div>                                                                                                           '
		+ ' 			<div class="col-md-2">                                                                                           '
		+ ' 				<span class="glyphicon glyphicon-comment" aria-hidden="true"></span>                                     '
		+ ' 				<span><a href="javascript:___alert();">评论</a></span>                                                      '
		+ ' 			</div>                                                                                                           '
		+ ' 		</div>                                                                                                                   '
		+ ' 	</div>                                                                                                                           '
		+ ' </div>                                                                                                                               '
		+ '');
		$("#" + parent_id_name).append(d);

		//get current mix news id, use it(where news_id < it) to get news if has more
		if (i == json.size - 1) return cs[0];
	}
}

function add_news () {
	$.ajax({
		type: "POST",
		url: "/add-news",
		data: {
			title: "f title",
			keywords: "f keywords",
			content: "f content"
		},
		error: function (xmlhttprequest, errorinfo) {
			alert("error: " + errorinfo);
		},
		success: function (json) {
			console.log(json.msg);
		},
		complete: function (xhr, ts) {

		}
	});
}

function ___alert(msg) {
	$("#alert div").text(msg);

	$('#alert').modal('show');
	$('#alert').on("click", function () {
		$("#alert div").text("error");
		$(this).modal('hide');
	});
}
