// images_uploader_admin.js

function openImagesUploaderAction(parked_id, bool) {
	var paneObj = getGUIObjectInstanceById('div_imagesUploaderDialog');
	var paneObj2 = getGUIObjectInstanceById('div_imagesUploaderDialog_form');
	var paneObj3 = getGUIObjectInstanceById('div_imagesUploaderDialog_msg');
	if ( (paneObj != null) && (paneObj2 != null) && (paneObj3 != null) ) {
		var _width = clientWidth();
		var xPos_m = _width - (_width / 2);
		var yPos_m = 200;
		if ( (parked_id != null) && (parked_id.trim().length > 0) ) {
			var _tt_obj = getGUIObjectInstanceById(parked_id);
			if (_tt_obj != null) {
				var m_coord = getAnchorPosition(parked_id);
				xPos_m = m_coord.x;
				yPos_m = m_coord.y;
			}
		}
		paneObj.style.left = xPos_m.toString() + 'px';
		paneObj.style.top = yPos_m.toString() + 'px';
		paneObj.style.display = const_inline_style;
		paneObj2.style.display = ((bool == true) ? const_inline_style : const_none_style);
		paneObj3.style.display = ((bool == true) ? const_none_style : const_inline_style);
	}
}

function clearImagesUploaderError() {
	var errMsg = '&nbsp;';
	var errObj = getGUIObjectInstanceById('div_imagesUploaderDialog_err');
	if (errObj != null) {
		errObj.innerHTML = errMsg;
	}
	return true;
}

function closeImagesUploaderAction(formObj, forceClose) {
	var okayToSubmit = false;
	if ( (forceClose == null) && (formObj != null) ) {
		var a = formObj._fileName.value.trim().split('.');
		var b = const_gif_filetype_symbol.trim().split('.');
		var bool = ( (formObj._fileName.value.trim().toUpperCase().indexOf(const_gif_filetype_symbol.trim().toUpperCase()) != -1) && (a.length == 2) && (a[1].trim().toUpperCase() == b[1].trim().toUpperCase()) );
		if (bool == false) {
			b = const_jpg_filetype_symbol.trim().split('.');
			var bool = ( (formObj._fileName.value.trim().toUpperCase().indexOf(const_jpg_filetype_symbol.trim().toUpperCase()) != -1) && (a.length == 2) && (a[1].trim().toUpperCase() == b[1].trim().toUpperCase()) );
		}
		if (bool == false) {
			b = const_jpeg_filetype_symbol.trim().split('.');
			var bool = ( (formObj._fileName.value.trim().toUpperCase().indexOf(const_jpeg_filetype_symbol.trim().toUpperCase()) != -1) && (a.length == 2) && (a[1].trim().toUpperCase() == b[1].trim().toUpperCase()) );
		}
		okayToSubmit = bool;
		var errObj = getGUIObjectInstanceById('div_imagesUploaderDialog_err');
		var errMsg = '&nbsp;';
		if ( (errObj != null) && (okayToSubmit == false) ) {
			errMsg = '<p align="justify"><font color="red"><b>Invalid file, cannot upload the file named "' + formObj._fileName.value.trim() + '".  Choose a file with one of these file types: ' + const_gif_filetype_symbol + ', ' + const_jpg_filetype_symbol + ' or ' + const_jpeg_filetype_symbol + ' OR simplfy the file name and try again.</b></font></p>';
		}
		errObj.innerHTML = errMsg;
		if (okayToSubmit) {
			formObj.submitButton.disabled = true;
			formObj.cancelButton.disabled = true;
			formObj._fileName.readonly = true;
			formObj.submit();
		}
	}
	if ( (forceClose != null) && (okayToSubmit == false) ) {
		okayToSubmit = forceClose;
	}
	if (okayToSubmit) {
		var paneObj = getGUIObjectInstanceById('div_imagesUploaderDialog');
		var paneObj2 = getGUIObjectInstanceById('div_imagesUploaderDialog_form');
		var paneObj3 = getGUIObjectInstanceById('div_imagesUploaderDialog_msg');
		if ( (paneObj != null) && (paneObj2 != null) && (paneObj3 != null) ) {
			paneObj.style.display = const_none_style;
			paneObj2.style.display = const_none_style;
			paneObj3.style.display = const_none_style;
		}
	}
	return okayToSubmit;
}

function processUploaderUserFeedback(id, s_msg) {
	openImagesUploaderAction(id, false);
	var paneObj = getGUIObjectInstanceById('div_imagesUploaderDialog_msg');
	if (paneObj != null) {
		paneObj.innerHTML = s_msg;
	}
}
