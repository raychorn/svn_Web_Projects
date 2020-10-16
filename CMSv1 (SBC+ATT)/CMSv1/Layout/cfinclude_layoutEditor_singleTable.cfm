<cfoutput>
	<table width="990px" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<form action="#CGI.SCRIPT_NAME#">
								<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
								<input type="hidden" name="current_LayoutSpec" id="current_LayoutSpec" value="">
								<input type="submit" name="submit" id="saveLayout_button" value="#layoutSaveAction_symbol#" #_textarea_style_symbol# onclick="performPrepLayoutSpecSave(); return true;">
							</form>
						</td>
						<td>
							<form>
								<input type="button" id="layoutEditorAction_button" value="#layoutEditorAction_symbol#" onClick="performNewTableAction(); return false;" #_textarea_style_symbol#>
							</form>
						</td>
						<td align="center" valign="top">
							<form>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="center" valign="top">
										<font id="layout_content_type_text" size="1"><small><b>Content Types</b></small></font>
									</td>
								</tr>
								<tr>
									<td align="center" valign="top">
										<select name="layout_content_types" id="layout_content_types" size="8" #_textarea_style_symbol#>
											<option value="H" SELECTED>Header</option>
											<option value="N">Nav Bar</option>
											<option value="C">Content</option>
											<option value="M">Menu</option>
											<option value="Q">QuickLinks</option>
											<option value="MQ">Menu/QuickLinks</option>
											<option value="R">Rightside</option>
											<option value="F">Footer</option>
										</select>
									</td>
								</tr>
								<tr>
									<td align="center" valign="top">
										<table width="40%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td align="center">
													<input type="button" id="layoutContentAction_button" value="#layoutAssignContentAction_symbol#" onClick="performAssignContentAction(); return false;" #_textarea_style_symbol#>
												</td>
												<td align="right">
													<input type="button" id="layoutContentAssignClose_button" value="#layoutCloseAction_symbol#" onClick="performContentAssignClose(); return false;" #_textarea_style_symbol#>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id="layout_tableEditor" style="display: none;">
					<table width="50%" cellpadding="-1" cellspacing="-1">
						<tr bgcolor="##c0c0c0">
							<td align="center">
								<small><b>Define New Table</b></small>
							</td>
							<td align="right">
								<input type="button" id="layoutEditorClose_button" value="#layoutCloseAction_symbol#" onClick="performNewTableClose(); return false;" #_textarea_style_symbol#>
							</td>
						</tr>
						<tr>
							<td align="left" colspan="2">
								<form>
									<table width="100%" cellpadding="1" cellspacing="1">
										<tr>
											<td>
												<font size="1"><small><b>Width:</b></small></font>
												&nbsp;<input type="radio" name="table_width" id="table_width_100_percent" value="100_percent" onclick="performClickedAutoTableLayout(); return true;">&nbsp;<font size="1"><small><b>Auto</b></small></font>
												<div id="layout_autoTable" style="display: none;">
													<input type="text" name="auto_table_width" id="auto_table_width" value="100" size="5" maxlength="5" #_textarea_style_symbol#>&nbsp;<font size="1"><small><b>(0-100 percent)</b></small></font>
												</div>
											</td>
											<td>
												&nbsp;<input type="radio" name="table_width" id="table_width_fixed" value="fixed" checked onclick="performClickedFixedTableLayout(); return true;">&nbsp;<font size="1"><small><b>Fixed</b></small></font>
												<div id="layout_fixedTable" style="display: none;">
													<input type="text" name="fixed_table_width" id="fixed_table_width" value="990" size="5" maxlength="5" #_textarea_style_symbol#>&nbsp;<font size="1"><small><b>(0-990)</b></small></font>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<input type="button" id="layoutSaveTable_button" value="#layoutSaveTableAction_symbol#" onClick="performNewTableSave(); return false;" #_textarea_style_symbol#>
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
					</table>
				</div>
				<div id="layout_cellWidthEditor" style="display: none;">
					<table width="30%" cellpadding="-1" cellspacing="-1">
						<tr bgcolor="##c0c0c0">
							<td align="center">
								<small><b>Edit Cell Width</b></small>
							</td>
							<td align="right">
								<input type="button" id="layoutCellWidthEditorClose_button" value="#layoutCloseAction_symbol#" onClick="performCellWidthEditorClose(); return false;" #_textarea_style_symbol#>
							</td>
						</tr>
						<tr>
							<td align="left" colspan="2">
								<form>
									<table width="100%" cellpadding="1" cellspacing="1">
										<tr>
											<td>
												<font size="1"><small><b>Cell Width:</b></small></font>
												<input type="text" name="cell_width" id="cell_width" value="" size="5" maxlength="5" #_textarea_style_symbol#>&nbsp;
												<div id="layoutCellWidthEditor_autoText" style="display: none;">
													<font size="1"><small><b>(0-100 percent)</b></small></font>
												</div>
												<div id="layoutCellWidthEditor_fixedText" style="display: none;">
													<font size="1"><small><b>(0-990 pixels)</b></small></font>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<input type="button" id="layoutCellWidthEditorSave_button" value="#layoutApplyChangesAction_symbol#" onClick="performCellWidthEditorSave(); return false;" #_textarea_style_symbol#>
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0">
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="left" valign="top">
										<font size="1"><small><b><NOBR>Layout Editor:</NOBR></b></small></font>&nbsp;#layoutPreviewHTMLAction_link#
									</td>
									<td align="left" valign="top">
										<ul style="font-size: 10px; line-height: 12px; text-align: justify;">
											<LI>Site Layout Notes:
												<OL>
													<LI>The Site Layout is specified by creating a main Table into which Rows may be added; each row may have one or more Cells.</LI>
													<LI>Rows with Single Cells will be saved with ColSpan's that cause the single cells to be the same width as the parent Table.</LI>
													<LI>One type of Content may be added to each Cell;<br>Content types are: <b><U>H</U></b>eader, <b><U>N</U></b>av Bar, <b><U>C</U></b>ontent, <b><U>M</U></b>enu, <b><U>Q</U></b>uickLinks, <b><U>M</U></b>enu/<b><U>Q</U></b>uickLinks, <b><U>R</U></b>ightside and <b><U>F</U></b>ooter.</LI>
													<LI>Individual Cells may be adjusted as to the width of each Cell; widths may be specified as <b><U>A</U></b>uto or <b><U>F</U></b>ixed. Auto Cell widths are specified as percentages of the total table width. Fixed Cell widths are specified as a number of pixels based on the width of the table.</LI>
													<LI>Site Layout Specifications are saved to the database without editing buttons and without borders or border colors.</LI>
													<LI>Table Cell Alignment is assumed to be: <b>align=left</b> and <b>valign=top</b></LI>
												</OL>
											</LI>
										</UL>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<hr width="100%" size="1" color="##0000FF">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id="layout_preview_pane" style="display: inline;">
				</div>
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0">
				<hr width="100%" size="1" color="##0000FF">
			</td>
		</tr>
	</table>
</cfoutput>
