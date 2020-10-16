function performScrollerOpen() {
	var imgObj = document.getElementById("img_AnnouncementBox_Bottom_right");
	var msObj = document.getElementById("marquee_scroller");
	if ( (imgObj != null) && (msObj != null) ) {
		imgObj.src = const_images_folder_symbol + "t_AnnouncementBox_Bottom_right_close.gif";
		ms_original_height = msObj.height;
		msObj.innerHTML = ms_content;
		msObj.height = 200;
	}
}

function performScrollerClose() {
	var imgObj = document.getElementById("img_AnnouncementBox_Bottom_right");
	var msObj = document.getElementById("marquee_scroller");
	if ( (imgObj != null) && (msObj != null) ) {
		imgObj.src = const_images_folder_symbol + "t_AnnouncementBox_Bottom_right_open.gif";
		msObj.height = ms_original_height;
		msObj.innerHTML = ms_headlines;
		ms_original_height = -1;
	}
}

function performScrollerOpenClose() {
	if (ms_original_height == -1) {
		return performScrollerOpen();
	} else {
		return performScrollerClose();
	}
}
