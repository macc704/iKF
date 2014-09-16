/**
 * kfmobile.js Mobile support Javascript Knowledge Forum
 * 
 * Original Author: Yoshiaki Matsuzawa 22 June,2014
 */

function replacePostReferenceTag() {
	var elements = document.getElementsByTagName("kf-post-reference");
	for (var i = 0; i < elements.length; i++) {
		var element = elements[i];
		var postId = element.getAttribute("postId");
		var original = element.innerHTML;
		elements[i].innerHTML = "<a href='http://kfpost/"
				+ postId + "'>" + "<img src='note.png' width=15px, height=15px/>"+ original + "</a>";
	}
}

function replaceContentReferenceTag() {
	var elements = document.getElementsByTagName("kf-content-reference");
	for (var i = 0; i < elements.length; i++) {
		var element = elements[i];
		var postId = element.getAttribute("postId");
		var original = element.innerHTML;
		elements[i].innerHTML = "<span style='font-style:italic;'>\""+original+"\"</span>" + "(<a href='http://kfpost/"
				+ postId + "'>" + "<img src='note.png' width=15px, height=15px/>" + "</a>)";
	}
}

function replaceWebLinkTag() {
    var elements = document.getElementsByTagName("kf-redirect");
    for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        var toUrl = element.getAttribute("url");
        elements[i].innerHTML = "<meta http-equiv='refresh' content='0; URL="+toUrl+"'>";
    }
}

function onLoadHook() {
    replaceWebLinkTag();
	replacePostReferenceTag();
	replaceContentReferenceTag();
}

window.onload = onLoadHook;
