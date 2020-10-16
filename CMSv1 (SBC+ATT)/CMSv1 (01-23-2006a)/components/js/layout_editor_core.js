_stack_button_values = [];
_stack_content_assignment = [];

const_plus_sign_symbol = '+';
const_minus_sign_symbol = '-';

const_percent_sign_symbol = '%';

const_content_symbol = 'Content';
const_Menu_symbol = 'Menu';
const_QuickLinks_symbol = 'QuickLinks';

function refreshLayoutEditorButtons() {
	var sbObj = document.getElementById('saveLayout_button');
	var layObj = document.getElementById('current_LayoutSpec');
	var divObj = document.getElementById('layout_tableEditor');
	var btnObj = document.getElementById('layoutEditorAction_button');
	if ( (sbObj != null) && (layObj != null) && (divObj != null) && (isObjValidHTMLValueHolder(layObj)) && (btnObj != null) ) {
		if (layObj.value.trim().length == 0) {
			sbObj.disabled = true;
			btnObj.disabled = false;
		} else {
			sbObj.disabled = false;
			btnObj.disabled = true;
		}
		divObj.style.display = const_none_style;
		closeContentTypeAssign();
	}
}

function initLayoutEditor() {
	refreshLayoutEditorButtons();
}

function performNewTableAction() {
	var btnObj = document.getElementById('layoutEditorAction_button');
	var divObj = document.getElementById('layout_tableEditor');
	var waObj = document.getElementById('table_width_100_percent');
	var wfObj = document.getElementById('table_width_fixed');
	if ( (btnObj != null) && (divObj != null) && (waObj != null) && (wfObj != null) ) {
		btnObj.disabled = true;
		divObj.style.display = const_inline_style;
		if (waObj.checked == true) {
			performClickedAutoTableLayout();
		}
		if (wfObj.checked == true) {
			performClickedFixedTableLayout();
		}
		closeContentTypeAssign();
	}
}

function performNewTableClose() {
	var sbObj = document.getElementById('saveLayout_button');
	var btnObj = document.getElementById('layoutEditorAction_button');
	var divObj = document.getElementById('layout_tableEditor');
	var layObj = document.getElementById('current_LayoutSpec');
	if ( (btnObj != null) && (divObj != null) && (layObj != null) && (isObjValidHTMLValueHolder(layObj)) ) {
		if (layObj.value.trim().length == 0) {
			sbObj.disabled = true;
			btnObj.disabled = false;
		} else {
			sbObj.disabled = false;
			btnObj.disabled = true;
		}
		divObj.style.display = const_none_style;
		closeContentTypeAssign();
	}
}

function performClickedFixedTableLayout() {
	var ftObj = document.getElementById('layout_fixedTable');
	var atObj = document.getElementById('layout_autoTable');
	var ftxtObj = document.getElementById('fixed_table_width');
	if ( (ftObj != null) && (atObj != null) && (ftxtObj != null) ) {
		ftObj.style.display = const_inline_style;
		atObj.style.display = const_none_style;
		setFocusSafely(ftxtObj);
	}
}

function performClickedAutoTableLayout() {
	var ftObj = document.getElementById('layout_fixedTable');
	var atObj = document.getElementById('layout_autoTable');
	var atxtObj = document.getElementById('auto_table_width');
	if ( (ftObj != null) && (atObj != null) && (atxtObj != null) ) {
		ftObj.style.display = const_none_style;
		atObj.style.display = const_inline_style;
		setFocusSafely(atxtObj);
	}
}

function performLayoutAddRow(id, i) {
	var otObj = document.getElementById(id);
	if (otObj != null) {
		otObj.insertRow();
		decorateTableWithEditingButtons(otObj.id);
	}
}

function performLayoutRemoveRow(id, i) {
	var otObj = document.getElementById(id);
	var lctObj = document.getElementById('layout_content_types');
	if ( (otObj != null) && (lctObj != null) ) {
		var rowObj = otObj.rows[i];
		if (rowObj != null) {
			var cells = rowObj.cells;
			for (var j = 0; j < cells.length; j++) {
				// What buttons are in the cell ?
				var btnObj = document.getElementById('layout_addContent_' + i.toString() + '_' + j.toString());
				if (btnObj != null) {
					if (btnObj.value.trim().indexOf(const_plus_sign_symbol) == -1) {
						_removeContentAssignmentFromCell(btnObj, lctObj);
					}
				}
			}
		}
		otObj.deleteRow(i);
		decorateTableWithEditingButtons(otObj.id);
	}
}

function performLayoutAddCell(id, row_i) {
	var otObj = document.getElementById(id);
	if (otObj != null) {
		var rObj = otObj.rows[row_i];
		if (rObj != null) {
			rObj.insertCell();
			decorateTableCellsWithEditingButtons(id, row_i, rObj.cells);
		}
	}
}

function performLayoutRemoveCell(id, row_i, cell_i) {
	var otObj = document.getElementById(id);
	if (otObj != null) {
		var rObj = otObj.rows[row_i];
		if (rObj != null) {
			// What buttons are in the cell ?
			var lctObj = document.getElementById('layout_content_types');
			var btnObj = document.getElementById('layout_addContent_' + row_i.toString() + '_' + cell_i.toString());
			if ( (btnObj != null) && (lctObj != null) ) {
				if (btnObj.value.trim().indexOf(const_plus_sign_symbol) == -1) {
					_removeContentAssignmentFromCell(btnObj, lctObj);
				}
			}
			rObj.deleteCell(cell_i);
			decorateTableCellsWithEditingButtons(id, row_i, rObj.cells);
			refreshEditWidthButtons(otObj.id, row_i);
		}
	}
}

function getButtonLabelFor(bName, ri, ci) {
	var aLabel = '';
	var btnObj = document.getElementById(bName + ri.toString() + '_' + ci.toString());
	if (btnObj != null) {
		aLabel = btnObj.value;
	}
	return aLabel;
}

function setButtonLabelFor(bName, ri, ci, label) {
	if (label.length > 0) {
		var btnObj = document.getElementById(bName + ri.toString() + '_' + ci.toString());
		if (btnObj != null) {
			btnObj.value = label;
		}
	}
}

function refreshEditWidthButtons(id, row_i) {
	var tbObj = document.getElementById(id);
	if ( (tbObj != null) && (row_i >= 0) && (row_i < tbObj.rows.length) ) {
		var rowObj = tbObj.rows[row_i];
		for (var j = 0; j < rowObj.cells.length; j++) {
			var b_disabled = true;
			if (rowObj.cells.length > 1) {
				b_disabled = false;
			}
			var btnObj = document.getElementById('layout_editWidth_' + row_i.toString() + '_' + j.toString());
			if (btnObj != null) {
				btnObj.disabled = b_disabled;
			}
		}
	}
}

function decorateTableCellsWithEditingButtons(id, row_i, cells) {
	var otObj = document.getElementById(id);
	if ( (otObj != null) && (cells != null) && (cells.length > 1) ) {
		var _html = '';
		var tbObj_id = "'" + otObj.id + "'";
		var _style = ' style="font-size: 10px;"';
		for (var i = 1; i < cells.length; i++) {
			var aCellObj = cells[i];
			_html = '';
			_html += '<input type="button" name="layout_addContent_' + row_i.toString() + '" id="layout_addContent_' + row_i.toString() + '_' + i.toString() + '"  onclick="performLayoutAddContent(' + tbObj_id + ', ' + row_i.toString() + ', ' + i.toString() + '); return false;" value="[+ Content]"' + _style + '>';
			_html += '&nbsp;';
			_html += '<input type="button" name="layout_removeCell_' + row_i.toString() + '" id="layout_removeCell_' + row_i.toString() + '" onclick="performLayoutRemoveCell(' + tbObj_id + ', ' + row_i.toString() + ', ' + i.toString() + '); return false;" value="[- Cell]"' + _style + '>';
			_html += '&nbsp;';
			_html += '<input type="button" name="layout_editWidth_' + i.toString() + '" id="layout_editWidth_' + row_i.toString() + '_' + i.toString() + '" onclick="performLayoutEditWidth(' + tbObj_id + ', ' + row_i.toString() + ', ' + i.toString() + '); return false;" value="[* Width]"' + _style + '>';
			_html += '&nbsp;';

			var aLabel = getButtonLabelFor('layout_addContent_', row_i, i);
			aCellObj.innerHTML = _html;
			setButtonLabelFor('layout_addContent_', row_i, i, aLabel);
			refreshEditWidthButtons(otObj.id, row_i);
		}
	}
}

function decorateTableRowWithEditingButtons(tbObj, aCellObj, i, rows) {
	if ( (tbObj != null) && (aCellObj != null) ) {
		var _html = '';
		var _style = ' style="font-size: 10px;"';
		var tbObj_id = "'" + tbObj.id + "'";
		if (i < (rows - 1)) {
			_html += '<input type="button" name="layout_removeRow_' + i.toString() + '" id="layout_removeRow_' + i.toString() + '" onclick="performLayoutRemoveRow(' + tbObj_id + ', ' + i.toString() + '); return false;" value="[- Row]"' + _style + '>';
		} else {
			_html += '<input type="button" name="layout_addRow_' + i.toString() + '" id="layout_addRow_' + i.toString() + '" onclick="performLayoutAddRow(' + tbObj_id + ', ' + i.toString() + '); return false;" value="[+ Row]"' + _style + '>';
		}
		_html += '&nbsp;';
		_html += '<input type="button" name="layout_addContent_' + i.toString() + '" id="layout_addContent_' + i.toString() + '_0" onclick="performLayoutAddContent(' + tbObj_id + ', ' + i.toString() + ', 0); return false;" value="[+ Content]"' + _style + '>';
		_html += '&nbsp;';
		_html += '<input type="button" name="layout_addCell_' + i.toString() + '" id="layout_addCell_' + i.toString() + '" onclick="performLayoutAddCell(' + tbObj_id + ', ' + i.toString() + '); return false;" value="[+ Cell]"' + _style + '>';
		_html += '&nbsp;';
		_html += '<input type="button" name="layout_editWidth_' + i.toString() + '" id="layout_editWidth_' + i.toString() + '_0" onclick="performLayoutEditWidth(' + tbObj_id + ', ' + i.toString() + ', 0); return false;" value="[* Width]"' + _style + '>';
		_html += '&nbsp;';

		var aLabel = getButtonLabelFor('layout_addContent_', i, 0);
		aCellObj.innerHTML = _html;
		setButtonLabelFor('layout_addContent_', i, 0, aLabel);
		refreshEditWidthButtons(tbObj.id, i);
	}
}

function decorateTableWithEditingButtons(tbName) {
	var tbObj = document.getElementById(tbName);
	if (tbObj != null) {
		for (var i = 0; i < tbObj.rows.length; i++) {
			var rowObj = tbObj.rows[i];
			if (rowObj.cells.length == 0) {
				rowObj.insertCell();
			}
			decorateTableRowWithEditingButtons(tbObj, rowObj.cells[0], i, tbObj.rows.length);
		}
	}
}

function performPreviewHTML() {
	var otObj = document.getElementById('layout_outerTable');
	if (otObj != null) {
		alert(otObj.outerHTML);
	} else {
		alert('There is NO HTML to view at this time.');
	}
}

function closeContentTypeAssign() {
	var lctObj = document.getElementById('layout_content_types');
	var lcaObj = document.getElementById('layoutContentAction_button');
	var lccObj = document.getElementById('layoutContentAssignClose_button');
	var lchObj = document.getElementById('layout_content_type_text');
	if ( (lctObj != null) && (lcaObj != null) && (lccObj != null) && (lchObj != null) ) {
		lctObj.disabled = true;
		lcaObj.disabled = true;
		lccObj.disabled = true;
		lchObj.color = 'silver';
	}
}

function prepContentTypeAssign() {
	var lctObj = document.getElementById('layout_content_types');
	var lcaObj = document.getElementById('layoutContentAction_button');
	var lccObj = document.getElementById('layoutContentAssignClose_button');
	var lchObj = document.getElementById('layout_content_type_text');
	if ( (lctObj != null) && (lcaObj != null) && (lccObj != null) && (lchObj != null) ) {
		lctObj.disabled = false;
		lcaObj.disabled = false;
		lccObj.disabled = false;
		lchObj.color = 'black';
	}
}

function performCellWidthEditorSave() {
	var edObj = document.getElementById('cell_width');
	var tblObj = document.getElementById('layout_outerTable');
	if ( (edObj != null) && (tblObj != null) ) {
		var c = _stack_content_assignment.pop();
		_stack_content_assignment.push(c);
		if (c.length == 2) {
			var row_i = c[0];
			var cell_i = c[1];
			var btnObj = document.getElementById('layout_editWidth_' + row_i.toString() + '_' + cell_i.toString());
			if (btnObj != null) {
				var w = tblObj.width;
				var rowObj = tblObj.rows[row_i];
				var cellObj = rowObj.cells[cell_i];
				cellObj.width = eval(edObj.value.trim());
				btnObj.value = '[* Width] = ' + cellObj.width.toString();
				if (rowObj.cells.length > 1) {
					var ww = cellObj.width;
					for (var k = 0; k < rowObj.cells.length; k++) {
						if (k != cell_i) {
							ww += rowObj.cells[k].width;
						}
					}
					w -= ww;
					if ( (w != 0) && (false) ) {
						// cell widths don't add up to the max so something needs adjusting...
						var ww = tblObj.width - cellObj.width;
						for (var k = 0; k < rowObj.cells.length; k++) {
							if (k != cell_i) {
								rowObj.cells[k].width = Math.floor(ww / (rowObj.cells.length - 1));
								var _btnObj = document.getElementById('layout_editWidth_' + row_i.toString() + '_' + k.toString());
								if (_btnObj != null) {
									_btnObj.value = '[* Width] = ' + rowObj.cells[k].width.toString();
								}
							}
						}
					}
				}
			}
		}
	}

	performCellWidthEditorClose();
}

function performCellWidthEditorClose() {
	var divObj = document.getElementById('layout_cellWidthEditor');
	if (divObj != null) {
		divObj.style.display = const_none_style;
		var a = _stack_button_values.pop();
		if (a.length == 2) {
			var _id = a[0];
			var obj = document.getElementById(_id);
			if (obj != null) {
				obj.value = a[1];
			}
		}

		var c = _stack_content_assignment.pop();
		if (c.length == 2) {
			var row_i = c[0];
			var cell_i = c[1];
			var bObj = document.getElementById('layout_editWidth_' + row_i.toString() + '_' + cell_i.toString());
			if (bObj != null) {
				bObj.disabled = false;
			}
		}
	}
}

function performLayoutEditWidth(id, row_i, cell_i) {
	var divObj = document.getElementById('layout_cellWidthEditor');
	var tblObj = document.getElementById('layout_outerTable');
	var btnObj = document.getElementById('layoutCellWidthEditorSave_button');
	var bObj = document.getElementById('layout_editWidth_' + row_i.toString() + '_' + cell_i.toString());
	var edObj = document.getElementById('cell_width');
	if ( (divObj != null) && (btnObj != null) && (tblObj != null) && (bObj != null) && (edObj != null) ) {
		bObj.disabled = true;
		divObj.style.display = const_inline_style;

		var a = [];
		a[0] = btnObj.id;
		a[1] = btnObj.value;
		_stack_button_values.push(a);

		var c = [];
		c[0] = row_i;
		c[1] = cell_i;
		_stack_content_assignment.push(c);

		btnObj.value += ' (' + row_i + ', ' + cell_i + ')';
		var w = eval(tblObj.width).toString();
		var rowObj = tblObj.rows[row_i];
		var cells = rowObj.cells;
		var a_txtObj = document.getElementById('layoutCellWidthEditor_autoText');
		var f_txtObj = document.getElementById('layoutCellWidthEditor_fixedText');
		if ( (a_txtObj != null) && (f_txtObj != null) ) {
			if (w.indexOf(const_percent_sign_symbol) != -1) {
				a_txtObj.style.display = const_inline_style;
				f_txtObj.style.display = const_none_style;
			} else {
				f_txtObj.style.display = const_inline_style;
				a_txtObj.style.display = const_none_style;
				if (cells.length > 1) {
					var ww = 0;
					for (var k = 0; k < cells.length; k++) {
						if ( (k != cell_i) && (cells[k].width.trim().length > 0) ) {
							ww += eval(cells[k].width);
						}
					}
				w -= ww;
				}
				var _html = '<font size="1"><small><b>(0-' + w + ' pixels)</b></small></font>';
				f_txtObj.innerHTML = _html;
			}
		}
		setFocusSafely(edObj);
	}
}

function performLayoutAddContent(id, row_i, cell_i) {
	var lcaObj = document.getElementById('layoutContentAction_button');
	var btnObj = document.getElementById('layout_addContent_' + row_i.toString() + '_' + cell_i.toString());
	if ( (lcaObj != null) && (btnObj != null) ) {
		var c = [];
		c[0] = row_i;
		c[1] = cell_i;
		_stack_content_assignment.push(c);

		var a = [];
		a[0] = lcaObj.id;
		a[1] = lcaObj.value;
		_stack_button_values.push(a);

		if (btnObj.value.trim().indexOf(const_plus_sign_symbol) != -1) {
			lcaObj.value += ' (' + row_i + ', ' + cell_i + ')';
			prepContentTypeAssign();
			btnObj.disabled = true;
		} else {
			performAssignContentAction();
		}
	}
}

function performContentAssignClose() {
	var a = _stack_button_values.pop();
	if (a.length == 2) {
		var _id = a[0];
		var obj = document.getElementById(_id);
		if (obj != null) {
			obj.value = a[1];
		}
	}
	var c = _stack_content_assignment.pop();
	if (c.length == 2) {
		var row_i = c[0];
		var cell_i = c[1];
		var btnObj = document.getElementById('layout_addContent_' + row_i.toString() + '_' + cell_i.toString());
		if (btnObj != null) {
			btnObj.disabled = false;
		}
	}
	closeContentTypeAssign();
}

function _removeContentAssignmentFromCell(btnObj, lctObj) {
	if ( (btnObj != null) && (lctObj != null) ) {
		var toks = btnObj.value.trim().split('=');
		btnObj.value = toks[0];
		var sel = lctObj.selectedIndex;
		if (sel != -1) {
			lctObj.options[sel].selected = false;
		}
		var v = toks[1].trim().substr(1, 1);
		if (toks[1].indexOf('/') != -1) {
			var _toks = toks[1].split('/');
			if (_toks.length > 1) {
				v += _toks[1].trim().substr(1, 1);
				for (var k = 0; k < _toks.length; k++) {
					var oObj = new Option( _toks[k].trim(), _toks[k].trim().substr(1, 1));
					lctObj.options[lctObj.options.length] = oObj;
				}
			}
		}
		var oObj = new Option( toks[1].trim(), v);
		lctObj.options[lctObj.options.length] = oObj;
		lctObj.options[lctObj.options.length - 1].selected = true;
		if ( (toks[1].trim().toUpperCase() == const_Menu_symbol.trim().toUpperCase()) || (toks[1].trim().toUpperCase() == const_QuickLinks_symbol.trim().toUpperCase()) ) {
			oObj = new Option( const_Menu_symbol + '/' + const_QuickLinks_symbol, const_Menu_symbol.substr(1, 1) + const_QuickLinks_symbol.substr(1, 1));
			var isFound = false;
			for (var jj = 0; jj < lctObj.options.length; jj++) {
				if (lctObj.options[jj].text.trim().toUpperCase().indexOf(oObj.text.trim().toUpperCase()) != -1) {
					isFound = true;
					break;
				}
			}
			if (isFound == false) {
				lctObj.options[lctObj.options.length] = oObj;
			}
		}
		btnObj.value = '[' + const_plus_sign_symbol + ' ' + const_content_symbol + ']';
	}
}

function performAssignContentAction() {
	var lctObj = document.getElementById('layout_content_types');
	if (lctObj != null) {
		var t = '';
		var v = '';
		var sel = lctObj.selectedIndex;
		if (sel != -1) {
			v = lctObj.options[sel].value;
			t = lctObj.options[sel].text;
		}
		var a = _stack_button_values.pop();
		if (a.length == 2) {
			var _id = a[0];
			var obj = document.getElementById(_id);
			if (obj != null) {
				obj.value = a[1];
			}
		}
		var c = _stack_content_assignment.pop();
		if (c.length == 2) {
			var row_i = c[0];
			var cell_i = c[1];
			var btnObj = document.getElementById('layout_addContent_' + row_i.toString() + '_' + cell_i.toString());
			if (btnObj != null) {
				if (btnObj.value.trim().indexOf(const_plus_sign_symbol) != -1) {
					// +
					// take item from the content type list
					// relabel this button with const_minus_sign_symbol
					if (sel != -1) {
						lctObj.options[sel] = null;
						if (sel >= lctObj.options.length) {
							sel = lctObj.options.length - 1;
						}
						if (sel != -1) {
							lctObj.options[sel].selected = true;
						}
						if (lctObj.options.length > 0) {
							var _toks = t.split('/');
							if (_toks.length > 1) {
								for (var j = 0; j < _toks.length; j++) {
									for (var jj = 0; jj < lctObj.options.length; jj++) {
										if (lctObj.options[jj].text.trim().toUpperCase() == _toks[j].trim().toUpperCase()) {
											lctObj.options[jj] = null;
										}
									}
								}
								for (var k = 0; k < lctObj.options.length; k++) {
									lctObj.options[k].selected = false;
								}
								if (lctObj.options.length > 0) {
									lctObj.options[0].selected = true;
								}
							} else {
								// BEGIN: Handle the case of Menu and QuickLinks also removing the combination of the two when either is removed from the content types list...
								for (var jj = 0; jj < lctObj.options.length; jj++) {
									var _toks = lctObj.options[jj].text.trim().split('/');
									if (_toks.length > 1) {
										for (var j = 0; j < _toks.length; j++) {
											if (t.trim().toUpperCase() == _toks[j].trim().toUpperCase()) {
												lctObj.options[jj] = null;
											}
										}
									}
								}
								// END! Handle the case of Menu and QuickLinks also removing the combination of the two when either is removed from the content types list...
							}
						}
					}
					btnObj.value = '[' + const_minus_sign_symbol + ' ' + const_content_symbol + ']';
					var toks = btnObj.value.trim().split('=');
					btnObj.value = toks[0] + ' = ' + t;
				} else {
					// -
					// relabel this button with const_plus_sign_symbol
					// put item into the content type list
					_removeContentAssignmentFromCell(btnObj, lctObj);
				}
				btnObj.disabled = false;
			}
		}
		closeContentTypeAssign();
	}
}

function performNewTableSave() {
	// save the table in the internal representation and create an external representation...
	var layObj = document.getElementById('current_LayoutSpec');
	var waObj = document.getElementById('table_width_100_percent');
	var atObj = document.getElementById('auto_table_width');
	var wfObj = document.getElementById('table_width_fixed');
	var ftObj = document.getElementById('fixed_table_width');
	var prevObj = document.getElementById('layout_preview_pane');
	if ( (layObj != null) && (isObjValidHTMLValueHolder(layObj)) && (waObj != null) && (wfObj != null) && (atObj != null) && (ftObj != null) && (prevObj != null) ) {
		var _width_spec = '';
		if (waObj.checked == true) {
			_width_spec = eval(atObj.value.trim());
			if (_width_spec < 0) {
				_width_spec = Math.abs(_width_spec);
			} else if (_width_spec > 100) {
				_width_spec = 100;
			}
			_width_spec += '%';
		}
		if (wfObj.checked == true) {
			_width_spec = eval(ftObj.value.trim());
			if (_width_spec < 0) {
				_width_spec = Math.abs(_width_spec);
			} else if (_width_spec > 990) {
				_width_spec = 990;
			}
			_width_spec += 'px';
		}

		var _html = '';
		if (layObj.value.trim().length == 0) {
			_html = '<table id="layout_outerTable" width="' + _width_spec + '" cellpadding="1" cellspacing="1">';
			_html += '<tr>';
			_html += '<td>';
			_html += '&nbsp;';
			_html += '</td>';
			_html += '</tr>';
			_html += '</table>';
		} else {
		}
		layObj.value = _html;
		// decorate the new table with editing links - editing links are not stored in the database...
		prevObj.innerHTML = _html;
		var otObj = document.getElementById('layout_outerTable');
		if (otObj != null) {
			otObj.border = 1;
			otObj.bordercolor = 'black';
			otObj.bordercolordark = 'black';
			otObj.bordercolorlight = 'black';
		}
		decorateTableWithEditingButtons('layout_outerTable');
		performNewTableClose();
	}
}

function performPrepLayoutSpecSave() {
	var otObj = document.getElementById('layout_outerTable');
	var layObj = document.getElementById('current_LayoutSpec');
	if ( (layObj != null) && (isObjValidHTMLValueHolder(layObj)) && (otObj != null) ) {
		for (var ri = 0; ri < otObj.rows.length; ri++) {
			var rowObj = otObj.rows[ri];
			for (var ci = 0; ci < rowObj.cells.length; ci++) {
				var _token = '';
				var btnObj = document.getElementById('layout_addContent_' + ri.toString() + '_' + ci.toString());
				if (btnObj != null) {
					if (btnObj.value.trim().indexOf(const_plus_sign_symbol) == -1) {
						var toks = btnObj.value.trim().split('=');
						if (toks.length > 1) {
							_token = '@' + toks[1] + '@';
						}
					}
				}
				var cell = rowObj.cells[ci];
				cell.innerHTML = _token;
			}
		}

		otObj.removeAttribute('border');
		otObj.removeAttribute('bordercolor');
		otObj.removeAttribute('bordercolordark');
		otObj.removeAttribute('bordercolorlight');
		layObj.value = otObj.outerHTML;
	}
}
