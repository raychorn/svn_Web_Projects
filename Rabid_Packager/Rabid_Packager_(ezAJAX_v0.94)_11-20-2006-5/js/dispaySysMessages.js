function _dispaySysMessages(s, t, bool_hideShow, taName) {
	var cObj = $('div_sysMessages');
	var tObj = $('span_sysMessages_title');
	var sObj = $('span_sysMessages_body');
	var tbObj = $('div_sysMessages_titleBar_tr');
	var taObj = _$(taName);
	var s_ta = '';
	s = ((s == null) ? '' : s);
	t = ((t == null) ? '' : t);
	if ( (!!cObj) && (!!sObj) && (!!tObj) && (!!tbObj) ) {
		bool_hideShow = ((bool_hideShow == true) ? bool_hideShow : false);
		s_ta = ((!!taObj) ? taObj.value : '');
		tbObj.bgColor = ((t.trim().toUpperCase() != const_debug_symbol.trim().toUpperCase()) ? 'red' : 'silver');
		flushCache$(sObj);
		sObj.innerHTML = '<textarea id="' + taName + '" class="codeSmaller" cols="150" rows="30" readonly>' + ((s.length > 0) ? s_ta + '\n' : '') + s + '</textarea>';
		flushCache$(tObj);
		tObj.innerHTML = t;
		cObj.style.display = ((bool_hideShow) ? const_inline_style : const_none_style);
		cObj.style.position = 'absolute';
		cObj.style.left = 10 + 'px';
		cObj.style.top = document.body.scrollTop + 10 + 'px';
		cObj.style.width = (clientWid$() - 10) + 'px';
		cObj.style.height = (clientHt$() - 10) + 'px';
	}
}

function dispaySysMessages(s, t) {
	return _dispaySysMessages(s, t, true, 'textarea_sysMessages_body');
}

function _alert(s) {
	return dispaySysMessages(s, const_debug_symbol);
}

function _alertError(s) {
	return dispaySysMessages(s, 'ERROR');
}

function dismissSysMessages() {
	return _dispaySysMessages('', '', false, 'textarea_sysMessages_body');
}

// initialization upon script load...
document.write('<div id="div_sysMessages" style="display: none;">');
document.write('<table width="*" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80">');
document.write('<tr>');
document.write('<td>');
document.write('<table width="*" cellspacing="-1" cellpadding="-1">');
document.write('<tr id="div_sysMessages_titleBar_tr" bgcolor="silver">');
document.write('<td align="center">');
document.write('<span id="span_sysMessages_title" class="boldPromptTextClass"></span>');
document.write('</td>');
document.write('<td align="right">');
document.write('<button class="buttonClass" title="Click this button to dismiss this pop-up." onclick="dismissSysMessages(); return false;">[X]</button>');
document.write('</td>');
document.write('</tr>');
document.write('<tr>');
document.write('<td colspan="2">');
document.write('<span id="span_sysMessages_body" class="textClass"></span>');
document.write('</td>');
document.write('</tr>');
document.write('</table>');
document.write('</td>');
document.write('</tr>');
document.write('</table>');
document.write('</div>');
		
