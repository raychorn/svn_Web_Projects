function handleMarqueeRecordValidationForSubmit() {
	var hcObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_headline');
	var acObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_article');
	var _hcObj = getGUIObjectInstanceById('headlineContent');
	var _acObj = getGUIObjectInstanceById('articleContent');
	var btnObj = getGUIObjectInstanceById('marqueeRecordEditor_actionButton');
	if ( (hcObj != null) && (acObj != null) && (_hcObj != null) && (_acObj != null) && (btnObj != null) ) {
		if ( (btnObj.value.trim().toUpperCase().indexOf(const_save_button_symbol.trim().toUpperCase()) == -1) 
			|| ( ( (hcObj.innerHTML.trim().length > 0) && (hcObj.innerHTML.trim().toUpperCase().indexOf(const_empty_table_cell.trim().toUpperCase()) == -1) || (_hcObj.value.trim().length > 0) )
				&& ( (acObj.innerHTML.trim().length > 0) && (acObj.innerHTML.trim().toUpperCase().indexOf(const_empty_table_cell.trim().toUpperCase()) == -1) ) || (_acObj.value.trim().length > 0) ) ) {
			return true;
		} else {
			var txt = '';
			if ( ( (hcObj.innerHTML.trim().length == 0) || (hcObj.innerHTML.trim().toUpperCase().indexOf(const_empty_table_cell.trim().toUpperCase()) != -1) ) && (_hcObj.value.trim().length == 0) ) {
				txt += 'Missing the Headline - please enter a Headline and try again.\n';
			}
			if ( ( (acObj.innerHTML.trim().length == 0) || (acObj.innerHTML.trim().toUpperCase().indexOf(const_empty_table_cell.trim().toUpperCase()) != -1) ) && (_acObj.value.trim().length == 0) ) {
				txt += 'Missing the Article - please enter an Article and try again.\n';
			}
			alert(txt);
			return false;
		}
	}
	return false;
}

function openMarqueeEditorAction() {
	var paneObj = getGUIObjectInstanceById('marqueeEditor_pane');
	var edlObj = getGUIObjectInstanceById('id_marqueeEditorLink');
	var tbObj = getGUIObjectInstanceById('marqueeTableBrowser_pane');
	if ( (paneObj != null) && (edlObj != null) && (tbObj != null) ) {
		paneObj.style.display = const_inline_style;
		tbObj.style.display = const_inline_style;
		edlObj.style.display = const_none_style;
	}
}

function _openMarqueeEditorAction(m) {
	// the design for this function was that the m value would be the page the browser pane should be navigated to when this function concludes...
	openMarqueeEditorAction();
	performClickedMarqueeBeginButton(i, s, p);
	for (; m >= 1; m--) {
		_performClickedMarqueePrevNextButton(1);
	}
}

function closeLastOpenedEditor() {
	if (_last_opened_WYSIWYG_for_stack.length > 0) {
		var a = _last_opened_WYSIWYG_for_stack.pop();
		if (a.length == 2) {
			var buttonObj = getGUIObjectInstanceById(a[0] + '_openeditor_button');
			if (buttonObj != null) {
				buttonObj.value = a[1];
			}
			var paneObj = getGUIObjectInstanceById('wysiwygEditor_pane_' + a[0]);
			if (paneObj != null) {
				paneObj.style.display = const_none_style;
				paneObj.style.visibility = 'hidden';
			}
			var prevObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_' + a[0]);
			if (prevObj != null) {
				var _id = a[0] + const_Content_symbol;
				var anObj = getGUIObjectInstanceById(_id);
				if (anObj != null) {
					var _html = editor_getHTML(_id);
					setHTMLpreviewWith(prevObj, _html);
					setWidgetValueInStack(_id, _html);
				} else {
					var _id = a[0] + const_Container_symbol;
					var anObj = getGUIObjectInstanceById(_id);
					if (anObj != null) {
						setHTMLpreviewWith(prevObj, '<NOBR>' + ((anObj.value.trim().length == 0) ? '&nbsp;' : anObj.value) + '</NOBR>');
						setWidgetValueInStack(_id, anObj.value);
					}
				}
				prevObj.style.display = const_inline_style;
			}
		}
	}
}

function handleWidgetActions() {
	if (widget_action_stack.length > 0) {
		var a = widget_action_stack.pop();
		if (a.length == 3) {
			var pObj = a[0];
			if (pObj != null) {
				if (a[1].toUpperCase() == const_disabled_symbol.toUpperCase()) {
					pObj.disabled = a[2];
					disableRegisteredGUIobjects(a[2], current_visible_page_of_headlines);
				}
			}
		}
	}
}

function closeMarqueeEditorAction() {
	var recpObj = getGUIObjectInstanceById('marqueeRecordEditor_pane');
	if (recpObj != null) {
		recpObj.style.display = const_none_style;
		closeLastOpenedEditor();
		handleWidgetActions();
		handleButtonWidgetStyleStack();
		refreshMarqueeVCRButtons();
	}
}

function openWYSIWYG_htmlEditor(thing) {
	var paneObj = getGUIObjectInstanceById('wysiwygEditor_pane_' + thing);
	var buttonObj = getGUIObjectInstanceById(thing + '_openeditor_button');
	var prevObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_' + thing);
	if ( (paneObj != null) && (buttonObj != null) && (prevObj != null) ) {
		var bv = buttonObj.value;
		closeLastOpenedEditor();
		if (bv.trim().toUpperCase() != const_closeButton_symbol.trim().toUpperCase()) {
			paneObj.style.display = const_inline_style;
			paneObj.style.visibility = 'visible';
			prevObj.style.display = const_none_style;
			var a = [];
			a[0] = thing;
			a[1] = buttonObj.value;
			_last_opened_WYSIWYG_for_stack.push(a);
			buttonObj.value = const_closeButton_symbol;

			var _id = thing + const_Content_symbol;
			var v = getWidgetValueFromStack(_id);
			if (v.trim().length > 0) {
				editor_setHTML(_id, v);
			} else {
				_id = thing + const_Container_symbol;
				v = getWidgetValueFromStack(_id);
				if (v.trim().length > 0) {
					anObj = getGUIObjectInstanceById(_id);
					if (anObj != null) {
						anObj.value = v;
						var cal = getCalendarForId(_id);
						cal.parseDate(v, cal.dateFormat);
					}
				}
			}
		}
	}
}

function getCalendarForId(id) {
	// catch the errors that might arise from dealing with the date_widget_validation_stack which is supposed to have array objects rather than anything else...
	try {
		for (var i = 0; i < date_widget_validation_stack.length; i++) {
			var a = date_widget_validation_stack[i];
			if (a.length == 2) {
				if (a[0].value.trim().length > 0) {
					if (a[0].id.trim().toUpperCase() == id.trim().toUpperCase()) {
						return a[1];
					}
				}
			}
		}
	} catch(e) {
		return null;
	} finally {
	}
	return null;
}

function validateDateFields() {
	// determine which is begin date and which is end date
	var begin_date_i = -1;
	var end_date_i = -1;

	var begin_date_cal = -1;
	var end_date_cal = -1;

	// catch the errors that might arise from dealing with the date_widget_validation_stack which is supposed to have array objects rather than anything else...
	try {
		for (var i = 0; i < date_widget_validation_stack.length; i++) {
			var a = date_widget_validation_stack[i];
			if (a.length == 2) {
				if (a[0].value.trim().length > 0) {
					if (begin_date_i == -1) {
						if (a[0].id.trim().toUpperCase().indexOf(const_begin_symbol.trim().toUpperCase()) != -1) {
							begin_date_i = i;
							begin_date_cal = a[1];
						}
					}
					if (end_date_i == -1) {
						if (a[0].id.trim().toUpperCase().indexOf(const_end_symbol.trim().toUpperCase()) != -1) {
							end_date_i = i;
							end_date_cal = a[1];
						}
					}
				}
			}
		}
	} catch(e) {
	} finally {
	}

	// only proceed if there is a begin versus end date scenario...
	if ( (begin_date_i != -1) && (end_date_i != -1) ) {
		// validations:
		// begin date > end date ?
		if (begin_date_cal.date >= end_date_cal.date) {
			// make the end date reddish and issue an error message via a bubble display...
			var a = date_widget_validation_stack[end_date_i];
			if ( (a[0] != null) && (date_widget_style_stack.length == 0) ) {
				date_widget_style_stack.push(Style2String(a[0].style));
				setStyle(a[0].style, const_backgroundColor_symbol + ': #FF9A88;');
			}
			openWYSIWYG_htmlEditor(const_end_symbol);

			var errorObj = getGUIObjectInstanceById('wysiwygEditorInvalid_pane_' + const_end_symbol);
			if (errorObj != null) {
				errorObj.style.display = const_inline_style;
			}
		} else {
			var a = date_widget_validation_stack[end_date_i];
			if (a[0] != null) {
				var s = date_widget_style_stack.pop();
				var v = getStyle(s, const_backgroundColor_symbol);
				if (v.length > 0) {
					setStyle(a[0].style, const_backgroundColor_symbol + ': ' + v + ';');
				} else {
					setStyle(a[0].style, const_backgroundColor_symbol + ': ' + const_bgColor + ';');
				}
			}

			var errorObj = getGUIObjectInstanceById('wysiwygEditorInvalid_pane_' + const_end_symbol);
			if (errorObj != null) {
				errorObj.style.display = const_none_style;
			}
		}
	}
}

function dateChanged(calendar, _pane_name) {
    // Beware that this function is called even if the end-user only
    // changed the month/year.  In order to determine if a date was
    // clicked you can use the dateClicked property of the calendar:
	if (calendar.dateClicked) {
		var dObj = getGUIObjectInstanceById(_pane_name + "Container");
		if (dObj != null) {
			dObj.value = calendar.date.print(calendar.dateFormat);
			closeLastOpenedEditor();
			validateDateFields();
		}
    }
};

function cal_onUpdate() {
	var x = this.date.print(this.dateFormat);

	var hh = -1;
	var mm = -1;
	var ap = -1;
	var _gui_paneName = '';
	var clickedDate = false;
	var _dateClicked = false;
	try {
		var hhObj = this._time_widget_hh;
		hh = eval(hhObj.firstChild.data);
		var mmObj = this._time_widget_mm;
		mm = eval(mmObj.firstChild.data);
		var apObj = this._time_widget_ap;
		ap = apObj.firstChild.data;
		_gui_paneName = this._gui_paneName;
		
		if ( (this.date.getHours() != hh) && (this.date.getMinutes() != mm) ) {
			clickedDate = true;
		}
		
		_dateClicked = this.dateClicked;
	} catch(e) {
		hh = -1;
		mm = -1;
		ap = -1;
		_gui_paneName = '';
		clickedDate = false;
		_dateClicked = false;
	} finally {
	}

	if (_dateClicked == true) {
		// this code might not work for every usage of the Calendar but it works for this one...
		if ( (this.time24 == false) && (ap.toUpperCase() == 'PM') ) {
			hh += 12;
		}
		this.date.setHours(hh);
		this.date.setMinutes(mm);
		var xx = this.date.print(this.dateFormat);
		return dateChanged(this, _gui_paneName);
	}
}

function showFlatCalendar(paneName) {
	var parentObj = getGUIObjectInstanceById("wysiwygEditor_pane_" + paneName);
	if (parentObj != null) {
		// construct a calendar giving only the "selected" handler.
		var cal = new Calendar(0, null, cal_onUpdate);
		
		// hide week numbers
		cal.weekNumbers = false;
		var _fmt = "%m-%d-%Y %H:%M";
		cal.setDateFormat(_fmt);
		cal.showsTime = true;
		cal.time24 = false;

		cal._gui_paneName = paneName;
		
		// this call must be the last as it might use data initialized above; if
		// we specify a parent, as opposite to the "showCalendar" function above,
		// then we create a flat calendar -- not popup.  Hidden, though, but...
		cal.create(parentObj);
		
		// ... we can show it here.
		cal.show();

		var dObj = getGUIObjectInstanceById(paneName + "Container");
		if (dObj != null) {
			var a = [];
			a[0] = dObj;
			a[1] = cal;
			date_widget_validation_stack.push(a);
		}
	}
}

function handleMouseOver_marqueeBrowser_panel(i, s) {
	var pName = const_marqueeBrowser_panel_symbol + i + s;
	var pObj = getGUIObjectInstanceById(pName);
	if (pObj != null) {
		if (pObj.disabled == false) {
			var a = [];
			a[0] = pObj;
			a[1] = Style2String(pObj.style);
			button_widget_style_stack.push(a);
			setStyle(pObj.style, const_backgroundColor_symbol + ': #FFFFBB;');
		}
	}
}

function handleButtonWidgetStyleStack() {
	if (button_widget_style_stack.length > 0) {
		var a = button_widget_style_stack.pop();
		if (a.length == 2) {
			var pObj = a[0];
			if (pObj != null) {
				if (pObj.disabled == false) {
					var s = a[1];
					var v = getStyle(s, const_backgroundColor_symbol);
					if (v.length > 0) {
						setStyle(pObj.style, const_backgroundColor_symbol + ': ' + v + ';');
					} else {
						setStyle(pObj.style, const_backgroundColor_symbol + ': silver;');
					}
				} else {
					// the widget is disabled so keep the item on this stack so it will be handled later on...
					button_widget_style_stack.push(a);
				}
			}
		}
	}
}

function handleMouseOut_marqueeBrowser_panel(i, s) {
	return handleButtonWidgetStyleStack();
}

function _performClickedMarqueeButton(i, s, p) {
	var paneObj = getGUIObjectInstanceById('marqueeRecordEditor_pane');
	var pObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + i + s);
	if ( (paneObj != null) && (pObj != null) ) {
		paneObj.style.display = const_inline_style;
		var a = [];
		a[0] = pObj;
		a[1] = const_disabled_symbol;
		a[2] = pObj.disabled;
		widget_action_stack.push(a);
		pObj.disabled = true;
		disableRegisteredGUIobjects(true, p);
	}
}

function getWidgetValueFromStack(id) {
	var v = '';
	var anObj = getGUIObjectInstanceById(id);
	if (anObj != null) {
		try {
			for (var i = 0; i < widget_value_stack.length; i++) {
				var a = widget_value_stack[i];
				if (a.length == 2) {
					var _id = a[0];
					if (_id.toUpperCase() == id.toUpperCase()) {
						v = a[1];
						break;
					}
				}
			}
		} catch(e) {
		} finally {
		}
	}
	return v;
}

function setWidgetValueInStack(id, v) {
	var _success = false;
	var anObj = getGUIObjectInstanceById(id);
	if (anObj != null) {
		try {
			for (var i = 0; i < widget_value_stack.length; i++) {
				var a = widget_value_stack[i];
				if (a.length == 2) {
					var _id = a[0];
					if (_id.toUpperCase() == id.toUpperCase()) {
						a[1] = v;
						widget_value_stack[i] = a;
						_success = true;
						break;
					}
				}
			}
		} catch(e) {
		} finally {
		}
	}
	return _success;
}

function registerWidgetValue(id, value) {
	var isRegistered = false;
	var isFailure = false;
	var anObj = getGUIObjectInstanceById(id);
	if (anObj != null) {
		anObj.value = value; // this is needed to allow the SQL code to save the value even if the user doesn't edit the field associated with the value
		try {
			for (var i = 0; i < widget_value_stack.length; i++) {
				var a = widget_value_stack[i];
				if (a.length == 2) {
					var _id = a[0];
					if (_id.toUpperCase() == id.toUpperCase()) {
						isRegistered = true;
						break;
					}
				}
			}
		} catch(e) {
			isFailure = true;
		} finally {
		}
		if (isFailure == false) {
			if (isRegistered == false) {
				var a = [];
				a[0] = id;
				a[1] = value;
				widget_value_stack.push(a);
				isRegistered = true;
			}
		}
	}
	return isRegistered;
}

function setHTMLpreviewWith(prevObj, v) {
	if (prevObj != null) {
		var _html = '<table width="100%" cellpadding="-1" cellspacing="-1">';
		_html += '<tr bgcolor="' + const_bgColor + '">';
		_html += '<td>';
		_html += v;
		_html += '</td>';
		_html += '</tr>';
		_html += '</table>';
		
		prevObj.innerHTML = _html;
		prevObj.style.display = const_inline_style;
	}
}

function _initMarqueeEditFields(i, s, hc, ac, bd, ed, recid) {
	var hcObj = getGUIObjectInstanceById('headlineContent');
	var acObj = getGUIObjectInstanceById('articleContent');
	var bdObj = getGUIObjectInstanceById('BeginDateContainer');
	var edObj = getGUIObjectInstanceById('EndDateContainer');
	var hcpObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_headline');
	var acpObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_article');
	var bdpObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_BeginDate');
	var edpObj = getGUIObjectInstanceById('wysiwygEditor_previewpane_EndDate');
	if ( (hcObj != null) && (acObj != null) && (bdObj != null) && (edObj != null) && (hcpObj != null) && (acpObj != null) && (bdpObj != null) && (edpObj != null) ) {
		registerWidgetValue(hcObj.id, hc);
		registerWidgetValue(acObj.id, ac);
		registerWidgetValue(bdObj.id, bd);
		registerWidgetValue(edObj.id, ed);

		setHTMLpreviewWith(hcpObj, '<div id="wysiwygEditor_previewpane_headline_value">' + hc + '</div>');
		setHTMLpreviewWith(acpObj, '<div id="wysiwygEditor_previewpane_article_value">' + ac + '</div>');
		setHTMLpreviewWith(bdpObj, '<NOBR>' + ((bd.trim().length == 0) ? '&nbsp;' : bd) + '</NOBR>');
		setHTMLpreviewWith(edpObj, '<NOBR>' + ((ed.trim().length == 0) ? '&nbsp;' : ed) + '</NOBR>');

		var recObj = getGUIObjectInstanceById('marqueeRecordEditor_recid');
		if (recObj != null) {
			recObj.value = recid;
		}
	}
}

function _fetchMarqueeDataFields(i, s, recid) {
	var oName = const_marqueeBrowser_panel_symbol + i + '_headline_data';
	var hcDataObj = getGUIObjectInstanceById(oName);
	if (hcDataObj != null) {
		_hc = hcDataObj.value.trim();
	} else {
		_hc = eval(oName).trim();
	}

	var oName = const_marqueeBrowser_panel_symbol + i + '_article_data';
	var acDataObj = getGUIObjectInstanceById(oName);
	if (acDataObj != null) {
		_ac = acDataObj.value.trim();
	} else {
		_ac = eval(oName).trim();
	}

	var oName = const_marqueeBrowser_panel_symbol + i + '_begin_dt_data';
	var bdDataObj = getGUIObjectInstanceById(oName);
	if (bdDataObj != null) {
		_bd = bdDataObj.value.trim();
	} else {
		_bd = eval(oName).trim();
	}

	var oName = const_marqueeBrowser_panel_symbol + i + '_end_dt_data';
	var edDataObj = getGUIObjectInstanceById(oName);
	if (edDataObj != null) {
		_ed = edDataObj.value.trim();
	} else {
		_ed = eval(oName).trim();
	}

	_initMarqueeEditFields(i, s, URLDecode(_hc), URLDecode(_ac), URLDecode(_bd), URLDecode(_ed), recid);
}

function labelMarqueeActionButton(label) {
	var buttonObj = getGUIObjectInstanceById('marqueeRecordEditor_actionButton');
	if (buttonObj != null) {
		buttonObj.value = label;
	}
}

function disableOpenEditorButtons(bool) {
	var hobObj = getGUIObjectInstanceById('headline_openeditor_button');
	var aobObj = getGUIObjectInstanceById('article_openeditor_button');
	var bdobObj = getGUIObjectInstanceById('BeginDate_openeditor_button');
	var edobObj = getGUIObjectInstanceById('EndDate_openeditor_button');
	if ( (hobObj != null) && (aobObj != null) && (bdobObj != null) && (edobObj != null) ) {
		var aBool = (((bool == true) || (bool == false)) ? bool : false);
		hobObj.disabled = aBool;
		aobObj.disabled = aBool;
		bdobObj.disabled = aBool;
		edobObj.disabled = aBool;
	}
}

function disableMarqueeVCRButtons() {
	var beginObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_begin_button');
	var fprevObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_fprev_button');
	var prevObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_prev_button');
	var nextObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_next_button');
	var fnextObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_fnext_button');
	var endObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_end_button');
	if ( (beginObj != null) && (fprevObj != null) && (prevObj != null) && (nextObj != null) && (fnextObj != null) && (endObj != null) ) {
		beginObj.disabled = true;
		fprevObj.disabled = true;
		prevObj.disabled = true;
		nextObj.disabled = true;
		fnextObj.disabled = true;
		endObj.disabled = true;
	}
}

function refreshMarqueeVCRButtons() {
	var beginObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_begin_button');
	var fprevObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_fprev_button');
	var prevObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_prev_button');
	var nextObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_next_button');
	var fnextObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_fnext_button');
	var endObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_end_button');
	var statObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines + '_status_pane');
	if ( (beginObj != null) && (fprevObj != null) && (prevObj != null) && (nextObj != null) && (fnextObj != null) && (endObj != null) && (statObj != null) ) {
		beginObj.disabled = true;
		beginObj.style.display = const_inline_style;
		fprevObj.disabled = true;
		fprevObj.style.display = const_inline_style;
		prevObj.disabled = true;
		prevObj.style.display = const_inline_style;
		nextObj.disabled = true;
		nextObj.style.display = const_inline_style;
		fnextObj.disabled = true;
		fnextObj.style.display = const_inline_style;
		endObj.disabled = true;
		endObj.style.display = const_inline_style;

		if (current_visible_page_of_headlines > 1) {
			beginObj.disabled = false;
			prevObj.disabled = false;
		}

		if (current_visible_page_of_headlines > 5) {
			fprevObj.disabled = false;
		}

		if (current_visible_page_of_headlines < max_visible_page_of_headlines) {
			nextObj.disabled = false;
			endObj.disabled = false;
		}
		
		if (current_visible_page_of_headlines < (max_visible_page_of_headlines - 5)) {
			fnextObj.disabled = false;
		}
		
		statObj.innerHTML = '<small><b>' + current_visible_page_of_headlines + ' of ' + max_visible_page_of_headlines + '</b></small>';

		var cpObj = getGUIObjectInstanceById('marqueeRecordEditor_curPage');
		if (cpObj != null) {
			cpObj.value = current_visible_page_of_headlines;
		}
	}
}

function _performClickedMarqueePrevNextButton(di) {
	if ((current_visible_page_of_headlines + di) < 1) {
		di = current_visible_page_of_headlines - 1;
	}

	if ((current_visible_page_of_headlines + di) > max_visible_page_of_headlines) {
		di = max_visible_page_of_headlines - current_visible_page_of_headlines;
	}

	if ( ((current_visible_page_of_headlines + di) >= 1) && ((current_visible_page_of_headlines + di) <= max_visible_page_of_headlines) ) {
		disableMarqueeVCRButtons();
		var pObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines);
		if (pObj != null) {
			pObj.style.display = const_none_style;
			current_visible_page_of_headlines += di;
			var pObj = getGUIObjectInstanceById(const_marqueeBrowser_panel_symbol + current_visible_page_of_headlines);
			if (pObj != null) {
				pObj.style.display = const_inline_style;
			}
		}
		refreshMarqueeVCRButtons();
	}
}

function performClickedMarqueeBeginButton(i, s, p) {
	return _performClickedMarqueePrevNextButton(-(current_visible_page_of_headlines - 1));
}

function performClickedMarqueeFastPrevButton(i, s, p) {
	return _performClickedMarqueePrevNextButton(-5);
}

function performClickedMarqueePrevButton(i, s, p) {
	return _performClickedMarqueePrevNextButton(-1);
}

function performClickedMarqueeNextButton(i, s, p) {
	return _performClickedMarqueePrevNextButton(1);
}

function performClickedMarqueeFastNextButton(i, s, p) {
	return _performClickedMarqueePrevNextButton(5);
}

function performClickedMarqueeEndButton(i, s, p) {
	return _performClickedMarqueePrevNextButton((max_visible_page_of_headlines - current_visible_page_of_headlines));
}

function performClickedMarqueeAddButton(i, s, p) {
	// need to initialize the contents of the various widgets based on what's being done...
	_performClickedMarqueeButton(i, s, p);
	_initMarqueeEditFields(i, s, '', '', '', '', -1);
	labelMarqueeActionButton(const_saveMarqueeButton_symbol);
	disableOpenEditorButtons(false);
}

function performClickedMarqueeEditButton(i, ii, s, recid, p) {
	// need to initialize the contents of the various widgets based on what's being done...
	_performClickedMarqueeButton(ii, s, p);

	_fetchMarqueeDataFields(i, s, recid);

	labelMarqueeActionButton(const_saveMarqueeButton_symbol);
	disableOpenEditorButtons(false);
}

function performClickedMarqueeRemoveButton(i, ii, s, recid, p) {
	// need to initialize the contents of the various widgets based on what's being done...
	_performClickedMarqueeButton(ii, s, p);

	// remove is a special case that shows the data but doesn't allow changes other than to remove the entities from the database...
	_fetchMarqueeDataFields(i, s, recid);

	labelMarqueeActionButton(const_removeMarqueeButton_symbol);
	disableOpenEditorButtons(true);
}

function disableRegisteredGUIobjects(b, p) {
	var pa = widget_registration_stack[p - 1];
	var _parent_id = '';
	var pObj = null;
	var _parent_style = const_inline_style;
	for (var i = 0; i < pa.length; i++) {
		var obj = pa[i];
		if (_parent_id.trim().length == 0) {
			var a = obj.id.split('.');
			if (a.length > 1) {
				_parent_id = a[0];
				pObj = getGUIObjectInstanceById(_parent_id);
				if (pObj != null) {
					_parent_style = pObj.style.display;
				}
			}
		}
		if (_parent_style.trim().toUpperCase() == const_inline_style.trim().toUpperCase()) {
			obj.disabled = (((b == true) || (b == false)) ? b : false);
		}
	}
}

function registerGUIobject(obj, p) {
	var _do = '';
	var isRegistered = false;
	if ( (obj != null) && (typeof obj == 'object') ) {
		var isFailure = false;
		try {
			p--;
			for (var i = 0; i < widget_registration_stack.length; i++) {
				var pa = widget_registration_stack[i];
				for (var j = 0; j < pa.length; j++) {
					if (pa[j].id.toUpperCase() == obj.id.toUpperCase()) {
						isRegistered = true;
						break;
					}
				}
			}
		} catch(e) {
			isFailure = true;
		} finally {
		}
		if (isFailure == false) {
			if (isRegistered == false) {
				var pa = widget_registration_stack[p];
				if (pa == null) {
					pa = new Array(0);
					widget_registration_stack[p] = pa;
				}
				pa.push(obj);
				isRegistered = true;
			}
		}
	}
	return isRegistered;
}

function registerGUIid(id, p) {
	var obj = getGUIObjectInstanceById(id);
	if (obj != null) {
		return registerGUIobject(obj, p);
	}
	return false;
}

function closeMarqueeBrowserAction() {
	var edlObj = getGUIObjectInstanceById('id_marqueeEditorLink');
	var tbObj = getGUIObjectInstanceById('marqueeTableBrowser_pane');
	if ( (tbObj != null) && (edlObj != null) ) {
		closeMarqueeEditorAction();
		tbObj.style.display = const_none_style;
		edlObj.style.display = const_inline_style;
	}
}
