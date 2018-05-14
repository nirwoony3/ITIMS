/*
jQWidgets v4.3.0 (2016-Oct)
Copyright (c) 2011-2016 jQWidgets.
License: http://jqwidgets.com/license/
 */

(function(a) {
	a.jqx.jqxWidget("jqxComboBox", "", {});
	a
			.extend(
					a.jqx._jqxComboBox.prototype,
					{
						defineInstance : function() {
							var b = {
								disabled : false,
								width : 200,
								height : 25,
								items : new Array(),
								selectedIndex : -1,
								selectedItems : new Array(),
								_selectedItems : new Array(),
								source : null,
								autoItemsHeight : false,
								scrollBarSize : a.jqx.utilities.scrollBarSize,
								arrowSize : 18,
								enableHover : true,
								enableSelection : true,
								visualItems : new Array(),
								groups : new Array(),
								equalItemsWidth : true,
								itemHeight : -1,
								visibleItems : new Array(),
								emptyGroupText : "Group",
								emptyString : "",
								ready : null,
								openDelay : 250,
								closeDelay : 300,
								animationType : "default",
								dropDownWidth : "auto",
								dropDownHeight : "200px",
								autoDropDownHeight : false,
								enableBrowserBoundsDetection : false,
								dropDownHorizontalAlignment : "left",
								dropDownVerticalAlignment : "bottom",
								dropDownContainer : "default",
								searchMode : "startswithignorecase",
								autoComplete : false,
								remoteAutoComplete : false,
								remoteAutoCompleteDelay : 500,
								selectionMode : "default",
								minLength : 2,
								displayMember : "",
								valueMember : "",
								groupMember : "",
								searchMember : "",
								keyboardSelection : true,
								renderer : null,
								autoOpen : false,
								template : "",
								checkboxes : false,
								promptText : "",
								placeHolder : "",
								rtl : false,
								listBox : null,
								validateSelection : null,
								showCloseButtons : true,
								renderSelectedItem : null,
								search : null,
								popupZIndex : 100000,
								searchString : null,
								multiSelect : false,
								showArrow : true,
								_disabledItems : new Array(),
								touchMode : "auto",
								autoBind : true,
								aria : {
									"aria-disabled" : {
										name : "disabled",
										type : "boolean"
									}
								},
								events : [ "open", "close", "select",
										"unselect", "change", "checkChange",
										"bindingComplete", "itemAdd",
										"itemRemove", "itemUpdate" ]
							};
							a.extend(true, this, b);
							return b
						},
						createInstance : function(b) {
							var c = this;
							this.host.attr("role", "combobox");
							a.jqx.aria(this, "aria-autocomplete", "both");
							if (a.jqx._jqxListBox == null
									|| a.jqx._jqxListBox == undefined) {
								throw new Error(
										"jqxComboBox: Missing reference to jqxlistbox.js.")
							}
							a.jqx.aria(this);
							if (this.promptText != "") {
								this.placeHolder = this.promptText
							}
							this.render()
						},
						render : function() {
							var l = this;
							var p = l.element.nodeName.toLowerCase();
							if (p == "select" || p == "ul" || p == "ol") {
								l.field = l.element;
								if (l.field.className) {
									l._className = l.field.className
								}
								var n = {
									title : l.field.title
								};
								if (l.field.id.length) {
									n.id = l.field.id.replace(/[^\w]/g, "_")
											+ "_jqxComboBox"
								} else {
									n.id = a.jqx.utilities.createId()
											+ "_jqxComboBox"
								}
								var c = a("<div></div>", n);
								if (!l.width) {
									l.width = a(l.field).width()
								}
								if (!l.height) {
									l.height = a(l.field).outerHeight()
								}
								l.element.style.cssText = l.field.style.cssText;
								a(l.field).hide().after(c);
								var k = l.host.data();
								l.host = c;
								l.host.data(k);
								l.element = c[0];
								l.element.id = l.field.id;
								l.field.id = n.id;
								if (l._className) {
									l.host.addClass(l._className);
									a(l.field).removeClass(l._className)
								}
								if (l.field.tabIndex) {
									var f = l.field.tabIndex;
									l.field.tabIndex = -1;
									l.element.tabIndex = f
								}
								if (l.field.innerHTML != "") {
									var r = a.jqx.parseSourceTag(l.field);
									l.source = r.items;
									if (l.selectedIndex == -1) {
										l.selectedIndex = r.index
									}
								}
							}
							l.removeHandlers();
							l.isanimating = false;
							l.id = a.jqx.utilities.createId();
							l.element.innerHTML = "";
							var g = a("<div style='background-color: transparent; -webkit-appearance: none; outline: none; width:100%; height: 100%; padding: 0px; margin: 0px; border: 0px; position: relative;'><div id='dropdownlistWrapper' style='padding: 0; margin: 0; border: none; background-color: transparent; float: left; width:100%; height: 100%; position: relative;'><div id='dropdownlistContent' style='padding: 0; margin: 0; border-top: none; border-bottom: none; float: left; position: absolute;'/><div id='dropdownlistArrow' role='button' style='padding: 0; margin: 0; border-left-width: 1px; border-bottom-width: 0px; border-top-width: 0px; border-right-width: 0px; float: right; position: absolute;'/></div></div>");
							l.comboStructure = g;
							if (a.jqx._jqxListBox == null
									|| a.jqx._jqxListBox == undefined) {
								throw "jqxComboBox: Missing reference to jqxlistbox.js."
							}
							l.touch = a.jqx.mobile.isTouchDevice();
							if (l.touchMode === true) {
								l.touch = true
							}
							l.host.append(g);
							l.dropdownlistWrapper = l.host
									.find("#dropdownlistWrapper");
							l.dropdownlistArrow = l.host
									.find("#dropdownlistArrow");
							l.dropdownlistContent = l.host
									.find("#dropdownlistContent");
							l.dropdownlistContent.addClass(l
									.toThemeProperty("jqx-combobox-content"));
							l.dropdownlistContent.addClass(l
									.toThemeProperty("jqx-widget-content"));
							l.dropdownlistWrapper[0].id = "dropdownlistWrapper"
									+ l.element.id;
							l.dropdownlistArrow[0].id = "dropdownlistArrow"
									+ l.element.id;
							l.dropdownlistContent[0].id = "dropdownlistContent"
									+ l.element.id;
							if (l.template) {
								l.dropdownlistArrow.addClass(l
										.toThemeProperty("jqx-" + l.template
												+ ""))
							}
							l.dropdownlistContent
									.append(a('<input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="box-sizing: border-box; margin: 0; padding: 0; padding-left: 3px; padding-right: 3px; border: 0;" type="textarea"/>'));
							l.input = l.dropdownlistContent.find("input");
							l.input.addClass(l
									.toThemeProperty("jqx-combobox-input"));
							l.input.addClass(l
									.toThemeProperty("jqx-widget-content"));
							if (l.host.attr("tabindex")) {
								l.input.attr("tabindex", l.host
										.attr("tabindex"));
								l.host.removeAttr("tabindex")
							}
							l._addInput();
							if (l.rtl) {
								l.input.css({
									direction : "rtl"
								});
								l.dropdownlistContent
										.addClass(l
												.toThemeProperty("jqx-combobox-content-rtl"))
							}
							try {
								var q = "listBox" + l.id;
								var i = a(a.find("#" + q));
								if (i.length > 0) {
									i.remove()
								}
								a.jqx.aria(this, "aria-owns", q);
								a.jqx.aria(this, "aria-haspopup", true);
								a.jqx.aria(this, "aria-multiline", false);
								if (l.listBoxContainer) {
									l.listBoxContainer.jqxListBox("destroy")
								}
								if (l.container) {
									l.container.remove()
								}
								var b = a("<div style='overflow: hidden; border: none; background-color: transparent; position: absolute;' id='listBox"
										+ l.id
										+ "'><div id='innerListBox"
										+ l.id + "'></div></div>");
								b.hide();
								if (l.dropDownContainer == "element") {
									b.appendTo(l.host)
								} else {
									b.appendTo(document.body)
								}
								l.container = b;
								l.listBoxContainer = a(a.find("#innerListBox"
										+ l.id));
								var d = l.width;
								if (l.dropDownWidth != "auto") {
									d = l.dropDownWidth
								}
								if (l.dropDownHeight == null) {
									l.dropDownHeight = 200
								}
								l.container.width(parseInt(d) + 25);
								l.container
										.height(parseInt(l.dropDownHeight) + 25);
								l._ready = false;
								l.addHandler(l.listBoxContainer,
										"bindingComplete", function(e) {
											if (!l.listBox) {
												l.listBox = a.data(
														l.listBoxContainer[0],
														"jqxListBox").instance
											}
											if (!l._ready) {
												if (l.ready) {
													l.ready()
												}
												l._ready = true
											}
											l._raiseEvent("6")
										});
								l.addHandler(l.listBoxContainer, "itemAdd",
										function(e) {
											l._raiseEvent("7", e.args)
										});
								l.addHandler(l.listBoxContainer, "itemRemove",
										function(e) {
											l._raiseEvent("8", e.args)
										});
								l.addHandler(l.listBoxContainer, "itemUpdate",
										function(e) {
											l._raiseEvent("9", e.args)
										});
								var j = true;
								l.listBoxContainer
										.jqxListBox({
											autoItemsHeight : l.autoItemsHeight,
											_checkForHiddenParent : false,
											allowDrop : false,
											allowDrag : false,
											checkboxes : l.checkboxes,
											emptyString : l.emptyString,
											autoBind : !l.remoteAutoComplete
													&& l.autoBind,
											renderer : l.renderer,
											rtl : l.rtl,
											itemHeight : l.itemHeight,
											selectedIndex : l.selectedIndex,
											incrementalSearch : false,
											width : d,
											scrollBarSize : l.scrollBarSize,
											autoHeight : l.autoDropDownHeight,
											height : l.dropDownHeight,
											groupMember : l.groupMember,
											searchMember : l.searchMember,
											displayMember : l.displayMember,
											valueMember : l.valueMember,
											source : l.source,
											theme : l.theme,
											rendered : function() {
												l.listBox = a.data(
														l.listBoxContainer[0],
														"jqxListBox").instance;
												if (l.remoteAutoComplete) {
													if (l.autoDropDownHeight) {
														l.container
																.height(l.listBox.virtualSize.height + 25);
														l.listBoxContainer
																.height(l.listBox.virtualSize.height);
														l.listBox._arrange()
													} else {
														l.listBox._arrange();
														l.listBox
																.ensureVisible(0);
														l.listBox
																._renderItems();
														l.container
																.height(l.listBoxContainer
																		.height() + 25)
													}
													if (l.searchString != undefined
															&& l.searchString.length >= l.minLength) {
														var e = l.listBoxContainer
																.jqxListBox("items");
														if (e) {
															if (e.length > 0) {
																if (!l
																		.isOpened()) {
																	l.open()
																}
															} else {
																l.close()
															}
														} else {
															l.close()
														}
													} else {
														l.close()
													}
												} else {
													l.renderSelection("mouse");
													if (l.multiSelect) {
														l.doMultiSelect(false)
													}
												}
												if (l.rendered) {
													l.rendered()
												}
											}
										});
								if (l.dropDownContainer == "element") {
									l.listBoxContainer.css({
										position : "absolute",
										top : 0,
										left : 0
									})
								} else {
									l.listBoxContainer.css({
										position : "absolute",
										zIndex : l.popupZIndex,
										top : 0,
										left : 0
									})
								}
								l.listBoxContainer.css("border-top-width",
										"1px");
								l.listBoxContainer.addClass(l
										.toThemeProperty("jqx-popup"));
								if (a.jqx.browser.msie) {
									l.listBoxContainer.addClass(l
											.toThemeProperty("jqx-noshadow"))
								}
								if (l.template) {
									l.listBoxContainer.addClass(l
											.toThemeProperty("jqx-"
													+ l.template + "-item"))
								}
								l.listBox = a.data(l.listBoxContainer[0],
										"jqxListBox").instance;
								l.listBox.enableSelection = l.enableSelection;
								l.listBox.enableHover = l.enableHover;
								l.listBox.equalItemsWidth = l.equalItemsWidth;
								l.listBox._arrange();
								l.addHandler(l.listBoxContainer, "unselect",
										function(e) {
											if (!l.multiSelect) {
												l._raiseEvent("3", {
													index : e.args.index,
													type : e.args.type,
													item : e.args.item
												})
											}
										});
								l
										.addHandler(
												l.listBoxContainer,
												"change",
												function(e) {
													if (!l.multiSelect) {
														l.selectedIndex = l.listBox.selectedIndex;
														l
																._raiseEvent(
																		"4",
																		{
																			index : e.args.index,
																			type : e.args.type,
																			item : e.args.item
																		})
													}
												});
								if (l.animationType == "none") {
									l.container.css("display", "none")
								} else {
									l.container.hide()
								}
								j = false
							} catch (m) {
								throw m
							}
							var l = this;
							l.input.attr("disabled", l.disabled);
							var h = a.jqx.browser.msie
									&& a.jqx.browser.version < 8;
							if (!h) {
								l.input.attr("placeholder", l.placeHolder)
							}
							l.propertyChangeMap.disabled = function(e, t, s, u) {
								if (u) {
									e.host
											.addClass(l
													.toThemeProperty("jqx-combobox-state-disabled"));
									e.host
											.addClass(l
													.toThemeProperty("jqx-fill-state-disabled"));
									e.dropdownlistContent
											.addClass(l
													.toThemeProperty("jqx-combobox-content-disabled"))
								} else {
									e.host
											.removeClass(l
													.toThemeProperty("jqx-combobox-state-disabled"));
									e.host
											.removeClass(l
													.toThemeProperty("jqx-fill-state-disabled"));
									e.dropdownlistContent
											.removeClass(l
													.toThemeProperty("jqx-combobox-content-disabled"))
								}
								e.input.attr("disabled", e.disabled);
								a.jqx.aria(e, "aria-disabled", e.disabled);
								e.input.attr("disabled", e.disabled)
							};
							if (l.disabled) {
								l.host
										.addClass(l
												.toThemeProperty("jqx-combobox-state-disabled"));
								l.host
										.addClass(l
												.toThemeProperty("jqx-fill-state-disabled"));
								l.dropdownlistContent
										.addClass(l
												.toThemeProperty("jqx-combobox-content-disabled"))
							}
							l.host
									.addClass(l
											.toThemeProperty("jqx-combobox-state-normal"));
							l.host.addClass(l.toThemeProperty("jqx-combobox"));
							l.host.addClass(l.toThemeProperty("jqx-rc-all"));
							l.host.addClass(l.toThemeProperty("jqx-widget"));
							l.host.addClass(l
									.toThemeProperty("jqx-widget-content"));
							l.dropdownlistArrowIcon = a("<div></div>");
							if (l.dropDownVerticalAlignment == "top") {
								l.dropdownlistArrowIcon.addClass(l
										.toThemeProperty("jqx-icon-arrow-up"))
							} else {
								l.dropdownlistArrowIcon
										.addClass(l
												.toThemeProperty("jqx-icon-arrow-down"))
							}
							l.dropdownlistArrowIcon.addClass(l
									.toThemeProperty("jqx-icon"));
							l.dropdownlistArrow.append(l.dropdownlistArrowIcon);
							l.dropdownlistArrow
									.addClass(l
											.toThemeProperty("jqx-combobox-arrow-normal"));
							l.dropdownlistArrow.addClass(l
									.toThemeProperty("jqx-fill-state-normal"));
							if (!l.rtl) {
								l.dropdownlistArrow.addClass(l
										.toThemeProperty("jqx-rc-r"))
							} else {
								l.dropdownlistArrow.addClass(l
										.toThemeProperty("jqx-rc-l"))
							}
							l._setSize();
							l._updateHandlers();
							l
									.addHandler(
											l.input,
											"keyup.textchange",
											function(e) {
												if (l._writeTimer) {
													clearTimeout(l._writeTimer)
												}
												l._writeTimer = setTimeout(
														function() {
															var s = l
																	._search(e);
															if (l.cinput
																	&& l.input) {
																if (!l.displayMember) {
																	l.cinput[0].value = l.input[0].value
																} else {
																	l
																			._updateInputSelection()
																}
															}
														}, 50)
											});
							if (a.jqx.browser.msie && a.jqx.browser.version < 8) {
								if (l.host.parents(".jqx-window").length > 0) {
									var o = l.host.parents(".jqx-window").css(
											"z-index");
									b.css("z-index", o + 10);
									l.listBoxContainer.css("z-index", o + 10)
								}
							}
							if (l.checkboxes) {
								l.input.attr("readonly", true);
								a.jqx.aria(this, "aria-readonly", true)
							} else {
								a.jqx.aria(this, "aria-readonly", false)
							}
							if (!l.remoteAutoComplete) {
								l.searchString = ""
							}
						},
						_addInput : function() {
							var b = this.host.attr("name");
							this.cinput = a("<input type='hidden'/>");
							this.host.append(this.cinput);
							if (b) {
								this.cinput.attr("name", b)
							}
						},
						_updateInputSelection : function() {
							if (this.cinput) {
								var c = new Array();
								if (this.selectedIndex == -1) {
									this.cinput.val("")
								} else {
									var e = this.getSelectedItem();
									if (e != null) {
										this.cinput.val(e.value);
										c.push(e.value)
									} else {
										this.cinput
												.val(this.dropdownlistContent
														.text())
									}
								}
								if (this.checkboxes || this.multiSelect) {
									if (!this.multiSelect) {
										var b = this.getCheckedItems()
									} else {
										var b = this.getSelectedItems()
									}
									var f = "";
									if (b != null) {
										for (var d = 0; d < b.length; d++) {
											if (d == b.length - 1) {
												f += b[d].value
											} else {
												f += b[d].value + ","
											}
											c.push(b[d].value)
										}
									}
									this.cinput.val(f)
								}
								if (this.field && this.cinput) {
									if (this.field.nodeName.toLowerCase() == "select") {
										a.each(this.field, function(g, h) {
											a(this).removeAttr("selected");
											this.selected = c
													.indexOf(this.value) >= 0;
											if (this.selected) {
												a(this).attr("selected", true)
											}
										})
									} else {
										a
												.each(
														this.items,
														function(g, h) {
															a(
																	this.originalItem.originalItem)
																	.removeAttr(
																			"data-selected");
															this.selected = c
																	.indexOf(this.value) >= 0;
															if (this.selected) {
																a(
																		this.originalItem.originalItem)
																		.attr(
																				"data-selected",
																				true)
															}
														})
									}
								}
							}
						},
						_search : function(d) {
							var i = this;
							if (d.keyCode == 9) {
								return
							}
							if (i.searchMode == "none" || i.searchMode == null
									|| i.searchMode == "undefined") {
								return
							}
							if (d.keyCode == 16 || d.keyCode == 17
									|| d.keyCode == 20) {
								return
							}
							if (i.checkboxes) {
								return
							}
							if (i.multiSelect) {
								var l = a("<span style='visibility: hidden; white-space: nowrap;'>"
										+ i.input.val() + "</span>");
								l.addClass(i.toThemeProperty("jqx-widget"));
								a(document.body).append(l);
								var e = l.width() + 15;
								l.remove();
								if (e > i.host.width()) {
									e = i.host.width()
								}
								if (e < 25) {
									e = 25
								}
								i.input.css("width", e + "px");
								if (i.selectedItems.length == 0) {
									i.input.css("width", "100%");
									i.input.attr("placeholder", i.placeHolder)
								} else {
									i.input.attr("placeholder", "")
								}
								var j = parseInt(this._findPos(i.host[0])[1])
										+ parseInt(i.host.outerHeight()) - 1
										+ "px";
								var r = a.jqx.mobile.isSafariMobileBrowser()
										|| a.jqx.mobile.isWindowsPhone();
								if ((r != null && r)) {
									j = a.jqx.mobile.getTopPos(this.element)
											+ parseInt(i.host.outerHeight());
									if (a("body").css("border-top-width") != "0px") {
										j = parseInt(j)
												- this._getBodyOffset().top
												+ "px"
									}
								}
								i.container.css("top", j);
								var o = parseInt(i.host.height());
								i.dropdownlistArrow.height(o)
							}
							if (!i.isanimating) {
								if (d.altKey && d.keyCode == 38) {
									i.hideListBox("altKey");
									return false
								}
								if (d.altKey && d.keyCode == 40) {
									if (!i.isOpened()) {
										i.showListBox("altKey")
									}
									return false
								}
							}
							if (d.keyCode == 37 || d.keyCode == 39) {
								return false
							}
							if (d.altKey || d.keyCode == 18) {
								return
							}
							if (d.keyCode >= 33 && d.keyCode <= 40) {
								return
							}
							if (d.ctrlKey || i.ctrlKey) {
								if (d.keyCode != 88 && d.keyCode != 86) {
									return
								}
							}
							var k = i.input.val();
							if (k.length == 0 && !i.autoComplete) {
								i.listBox.searchString = i.input.val();
								i.listBox.clearSelection();
								i.hideListBox("search");
								i.searchString = i.input.val();
								return
							}
							if (i.remoteAutoComplete) {
								var i = this;
								var q = function() {
									i.listBox.vScrollInstance.value = 0
								};
								if (k.length >= i.minLength) {
									if (!d.ctrlKey && !d.altKey) {
										if (i.searchString != k) {
											var c = i.listBoxContainer
													.jqxListBox("source");
											if (c == null) {
												i.listBoxContainer.jqxListBox({
													source : i.source
												})
											}
											if (i._searchTimer) {
												clearTimeout(i._searchTimer)
											}
											if (d.keyCode != 13
													&& d.keyCode != 27) {
												i._searchTimer = setTimeout(
														function() {
															q();
															if (i.autoDropDownHeight) {
																i.listBox.autoHeight = true
															}
															i.searchString = i.input
																	.val();
															if (i.search != null) {
																i
																		.search(i.input
																				.val())
															} else {
																throw "'search' function is not defined"
															}
														},
														i.remoteAutoCompleteDelay)
											}
										}
										i.searchString = k
									}
								} else {
									if (i._searchTimer) {
										clearTimeout(i._searchTimer)
									}
									q();
									i.searchString = "";
									i.search("");
									i.listBoxContainer.jqxListBox({
										source : null
									})
								}
								return
							}
							var i = this;
							if (k === i.searchString) {
								return
							}
							if (!(d.keyCode == "27" || d.keyCode == "13")) {
								var n = i.input[0].value;
								var g = i._updateItemsVisibility(k);
								var m = g.matchItems;
								if (i.autoComplete && i.autoItemsHeight) {
									i.input[0].value = n
								}
								var h = g.index;
								if (!i.autoComplete && !i.remoteAutoComplete) {
									if (!i.multiSelect
											|| (i.multiSelect && h >= 0)) {
										i.listBox.selectIndex(h);
										var f = i.listBox.isIndexInView(h);
										if (!f) {
											i.listBox.ensureVisible(h)
										} else {
											i.listBox._renderItems()
										}
									}
								}
								if (i.autoComplete && m.length === 0) {
									i.hideListBox("search")
								}
							}
							if (d.keyCode == "13") {
								var b = i.container.css("display") == "block";
								if (b && !i.isanimating) {
									i.hideListBox("keyboard");
									i._oldvalue = i.listBox.selectedValue;
									return
								}
							} else {
								if (d.keyCode == "27") {
									var b = i.container.css("display") == "block";
									if (b && !i.isanimating) {
										if (!i.multiSelect) {
											var p = i.listBox
													.getVisibleItem(i._oldvalue);
											if (p) {
												var i = this;
												setTimeout(
														function() {
															if (i.autoComplete) {
																i
																		._updateItemsVisibility("")
															}
															i.listBox
																	.selectIndex(p.index);
															i
																	.renderSelection("api")
														}, i.closeDelay)
											} else {
												i.clearSelection()
											}
										} else {
											i.input.val("");
											i.listBox.selectedValue = null
										}
										i.hideListBox("keyboard");
										i.renderSelection("api");
										d.preventDefault();
										return false
									}
								} else {
									if (!i.isOpened() && !i.opening
											&& !d.ctrlKey) {
										if (i.listBox.visibleItems
												&& i.listBox.visibleItems.length > 0) {
											if (i.input.val() != i.searchString
													&& i.searchString != undefined
													&& h != -1) {
												i.showListBox("search")
											}
										}
									}
									i.searchString = i.input.val();
									if (i.searchString == "") {
										if (!i.listBox.itemsByValue[""]) {
											h = -1;
											if (!i.multiSelect) {
												i.clearSelection()
											}
										}
									}
									var p = i.listBox.getVisibleItem(h);
									if (p != undefined) {
										i._updateInputSelection()
									}
								}
							}
						},
						val : function(c) {
							if (!this.input) {
								return ""
							}
							var d = function(f) {
								for ( var e in f) {
									if (f.hasOwnProperty(e)) {
										return false
									}
								}
								if (typeof c == "number") {
									return false
								}
								if (typeof c == "date") {
									return false
								}
								if (typeof c == "boolean") {
									return false
								}
								if (typeof c == "string") {
									return false
								}
								return true
							};
							if (d(c) || arguments.length == 0) {
								var b = this.getSelectedItem();
								if (b) {
									return b.value
								}
								return this.input.val()
							} else {
								var b = this.getItemByValue(c);
								if (b != null) {
									this.selectItem(b)
								} else {
									this.input.val(c)
								}
								return this.input.val()
							}
						},
						focus : function() {
							var c = this;
							var b = function() {
								c.input.focus();
								var d = c.input.val();
								c._setSelection(0, d.length)
							};
							b();
							setTimeout(function() {
								b()
							}, 10)
						},
						_setSelection : function(e, b) {
							try {
								if ("selectionStart" in this.input[0]) {
									this.input[0].focus();
									this.input[0].setSelectionRange(e, b)
								} else {
									var c = this.input[0].createTextRange();
									c.collapse(true);
									c.moveEnd("character", b);
									c.moveStart("character", e);
									c.select()
								}
							} catch (d) {
							}
						},
						setContent : function(b) {
							this.input.val(b)
						},
						_updateItemsVisibility : function(k) {
							var i = this.getItems();
							if (i == undefined) {
								return {
									index : -1,
									matchItem : new Array()
								}
							}
							var f = this;
							var g = -1;
							var l = new Array();
							var j = 0;
							a
									.each(
											i,
											function(o) {
												var q = "";
												if (!this.isGroup) {
													if (this.searchLabel) {
														q = this.searchLabel
													} else {
														if (this.label) {
															q = this.label
														} else {
															if (this.value) {
																q = this.value
															} else {
																if (this.title) {
																	q = this.title
																} else {
																	q = "jqxItem"
																}
															}
														}
													}
													q = q.toString();
													var p = false;
													switch (f.searchMode) {
													case "containsignorecase":
														p = a.jqx.string
																.containsIgnoreCase(
																		q, k);
														break;
													case "contains":
														p = a.jqx.string
																.contains(q, k);
														break;
													case "equals":
														p = a.jqx.string
																.equals(q, k);
														break;
													case "equalsignorecase":
														p = a.jqx.string
																.equalsIgnoreCase(
																		q, k);
														break;
													case "startswith":
														p = a.jqx.string
																.startsWith(q,
																		k);
														break;
													case "startswithignorecase":
														p = a.jqx.string
																.startsWithIgnoreCase(
																		q, k);
														break;
													case "endswith":
														p = a.jqx.string
																.endsWith(q, k);
														break;
													case "endswithignorecase":
														p = a.jqx.string
																.endsWithIgnoreCase(
																		q, k);
														break
													}
													if (f.autoComplete && !p) {
														this.visible = false
													}
													if (p && f.autoComplete) {
														l[j++] = this;
														this.visible = true;
														g = this.visibleIndex
													}
													if (k == ""
															&& f.autoComplete) {
														this.visible = true;
														p = false
													}
													if (f.multiSelect) {
														this.disabled = false;
														if (f.selectedItems
																.indexOf(this.value) >= 0
																|| f._disabledItems
																		.indexOf(this.value) >= 0) {
															this.disabled = true;
															p = false
														}
													}
													if (!f.multiSelect) {
														if (p
																&& !f.autoComplete) {
															g = this.visibleIndex;
															return false
														}
													} else {
														if (p
																&& !f.autoComplete) {
															if (g === -1) {
																g = this.visibleIndex
															}
															return true
														}
													}
												}
											});
							this.listBox.searchString = k;
							var f = this;
							var h = function() {
								if (!f.multiSelect) {
									return
								}
								var o = 0;
								var r = false;
								var q = null;
								for (var p = 0; p < f.listBox.items.length; p++) {
									f.listBox.selectedIndexes[p] = -1;
									if (!f.listBox.items[p].disabled) {
										if (r == false) {
											q = f.listBox.items[p];
											o = q.visibleIndex;
											r = true
										}
									}
								}
								f.listBox.selectedIndex = -1;
								f.listBox.selectedIndex = o;
								f.listBox.selectedIndexes[o] = o;
								if (f.listBox.visibleItems.length > 0) {
									if (q) {
										f.listBox.selectedValue = q.value
									} else {
										f.listBox.selectedValue = null
									}
								} else {
									f.listBox.selectedValue = null
								}
								f.listBox.ensureVisible(0)
							};
							if (!this.autoComplete) {
								h();
								return {
									index : g,
									matchItems : l
								}
							}
							this.listBox.renderedVisibleItems = new Array();
							var b = this.listBox.vScrollInstance.value;
							this.listBox.vScrollInstance.value = 0;
							this.listBox.visibleItems = new Array();
							this.listBox._renderItems();
							var e = this.listBox.selectedValue;
							var n = this.listBox.getItemByValue(e);
							if (!this.multiSelect) {
								if (n) {
									if (n.visible) {
										this.listBox.selectedIndex = n.visibleIndex;
										for (var d = 0; d < this.listBox.items.length; d++) {
											this.listBox.selectedIndexes[d] = -1
										}
										this.listBox.selectedIndexes[n.visibleIndex] = n.visibleIndex
									} else {
										for (var d = 0; d < this.listBox.items.length; d++) {
											this.listBox.selectedIndexes[d] = -1
										}
										this.listBox.selectedIndex = -1
									}
								}
							} else {
								h()
							}
							this.listBox._renderItems();
							var m = this.listBox._calculateVirtualSize().height;
							if (m < b) {
								b = 0;
								this.listBox.vScrollInstance.refresh()
							}
							if (this.autoDropDownHeight) {
								this._disableSelection = true;
								if (this.listBox.autoHeight != this.autoDropDownHeight) {
									this.listBoxContainer.jqxListBox({
										autoHeight : this.autoDropDownHeight
									})
								}
								this.container.height(m + 25);
								this.listBox.invalidate();
								this._disableSelection = false
							} else {
								if (m < parseInt(this.dropDownHeight)) {
									var c = this.listBox.hScrollBar[0].style.visibility == "hidden" ? 0
											: 20;
									this.listBox.height = c + m;
									this.container.height(m + 25 + c);
									this.listBox.invalidate()
								} else {
									this.listBox.height = parseInt(this.dropDownHeight);
									this.container
											.height(parseInt(this.dropDownHeight) + 25);
									this.listBox.invalidate()
								}
							}
							this.listBox.vScrollInstance.setPosition(b);
							return {
								index : g,
								matchItems : l
							}
						},
						findItems : function(e) {
							var b = this.getItems();
							var d = this;
							var c = 0;
							var f = new Array();
							a
									.each(
											b,
											function(g) {
												var j = "";
												if (!this.isGroup) {
													if (this.label) {
														j = this.label
													} else {
														if (this.value) {
															j = this.value
														} else {
															if (this.title) {
																j = this.title
															} else {
																j = "jqxItem"
															}
														}
													}
													var h = false;
													switch (d.searchMode) {
													case "containsignorecase":
														h = a.jqx.string
																.containsIgnoreCase(
																		j, e);
														break;
													case "contains":
														h = a.jqx.string
																.contains(j, e);
														break;
													case "equals":
														h = a.jqx.string
																.equals(j, e);
														break;
													case "equalsignorecase":
														h = a.jqx.string
																.equalsIgnoreCase(
																		j, e);
														break;
													case "startswith":
														h = a.jqx.string
																.startsWith(j,
																		e);
														break;
													case "startswithignorecase":
														h = a.jqx.string
																.startsWithIgnoreCase(
																		j, e);
														break;
													case "endswith":
														h = a.jqx.string
																.endsWith(j, e);
														break;
													case "endswithignorecase":
														h = a.jqx.string
																.endsWithIgnoreCase(
																		j, e);
														break
													}
													if (h) {
														f[c++] = this
													}
												}
											});
							return f
						},
						_resetautocomplete : function() {
							a.each(this.listBox.items, function(b) {
								this.visible = true
							});
							this.listBox.vScrollInstance.value = 0;
							this.listBox._addItems();
							this.listBox.autoHeight = false;
							this.listBox.height = this.dropDownHeight;
							this.container
									.height(parseInt(this.dropDownHeight) + 25);
							this.listBoxContainer
									.height(parseInt(this.dropDownHeight));
							this.listBox._arrange();
							this.listBox._addItems();
							this.listBox._renderItems()
						},
						getItems : function() {
							var b = this.listBox.items;
							return b
						},
						getVisibleItems : function() {
							return this.listBox.getVisibleItems()
						},
						_setSize : function() {
							if (this.width != null
									&& this.width.toString().indexOf("px") != -1) {
								this.host.width(this.width)
							} else {
								if (this.width != undefined
										&& !isNaN(this.width)) {
									this.host.width(this.width)
								}
							}
							if (this.height != null
									&& this.height.toString().indexOf("px") != -1) {
								this.host.height(this.height)
							} else {
								if (this.height != undefined
										&& !isNaN(this.height)) {
									this.host.height(this.height)
								}
							}
							var e = false;
							if (this.width != null
									&& this.width.toString().indexOf("%") != -1) {
								e = true;
								this.host.width(this.width)
							}
							if (this.height != null
									&& this.height.toString().indexOf("%") != -1) {
								e = true;
								this.host.height(this.height)
							}
							if (e) {
								var c = this;
								var b = this.host.width();
								if (this.dropDownWidth != "auto") {
									b = this.dropDownWidth
								}
								this.listBoxContainer.jqxListBox({
									width : b
								});
								this.container.width(parseInt(b) + 25);
								this._arrange()
							}
							var c = this;
							var d = function() {
								if (c.multiSelect) {
									c.host.height(c.height)
								}
								c._arrange();
								if (c.multiSelect) {
									c.host.height("auto")
								}
							};
							c.oldWidth = c.host.width();
							c.oldHeight = c.host.height();
							a.jqx.utilities.resize(this.host, function() {
								var f = c.host.width();
								var g = c.host.height();
								if (f != c.oldWidth || g != c.oldHeight) {
									d();
									c.hideListBox("api")
								}
								c.oldWidth = f;
								c.oldHeight = g
							})
						},
						isOpened : function() {
							var c = this;
							var b = a.data(document.body,
									"openedCombojqxListBox" + this.element.id);
							if (this.container.css("display") != "block") {
								return false
							}
							if (b != null && b == c.listBoxContainer) {
								return true
							}
							return false
						},
						_updateHandlers : function() {
							var e = this;
							var d = false;
							this.removeHandlers();
							if (this.multiSelect) {
								this.addHandler(this.dropdownlistContent,
										"click", function(f) {
											if (f.target.href) {
												return false
											}
											e.input.focus();
											setTimeout(function() {
												e.input.focus()
											}, 10)
										});
								this.addHandler(this.dropdownlistContent,
										"focus", function(f) {
											if (f.target.href) {
												return false
											}
											e.input.focus();
											setTimeout(function() {
												e.input.focus()
											}, 10)
										})
							}
							if (!this.touch) {
								if (this.host.parents()) {
									this
											.addHandler(this.host.parents(),
													"scroll.combobox"
															+ this.element.id,
													function(f) {
														var g = e.isOpened();
														if (g) {
															e.close()
														}
													})
								}
								this
										.addHandler(
												this.host,
												"mouseenter",
												function() {
													if (!e.disabled
															&& e.enableHover) {
														d = true;
														e.host
																.addClass(e
																		.toThemeProperty("jqx-combobox-state-hover"));
														if (e.dropDownVerticalAlignment == "top") {
															e.dropdownlistArrowIcon
																	.addClass(e
																			.toThemeProperty("jqx-icon-arrow-up"))
														} else {
															e.dropdownlistArrowIcon
																	.addClass(e
																			.toThemeProperty("jqx-icon-arrow-down-hover"))
														}
														e.dropdownlistArrow
																.addClass(e
																		.toThemeProperty("jqx-combobox-arrow-hover"));
														e.dropdownlistArrow
																.addClass(e
																		.toThemeProperty("jqx-fill-state-hover"))
													}
												});
								this
										.addHandler(
												this.host,
												"mouseleave",
												function() {
													if (!e.disabled
															&& e.enableHover) {
														e.host
																.removeClass(e
																		.toThemeProperty("jqx-combobox-state-hover"));
														e.dropdownlistArrowIcon
																.removeClass(e
																		.toThemeProperty("jqx-icon-arrow-down-hover"));
														e.dropdownlistArrowIcon
																.removeClass(e
																		.toThemeProperty("jqx-icon-arrow-up-hover"));
														e.dropdownlistArrow
																.removeClass(e
																		.toThemeProperty("jqx-combobox-arrow-hover"));
														e.dropdownlistArrow
																.removeClass(e
																		.toThemeProperty("jqx-fill-state-hover"));
														d = false
													}
												})
							}
							if (e.autoOpen) {
								this.addHandler(this.host, "mouseenter",
										function() {
											var f = e.isOpened();
											if (!f && e.autoOpen) {
												e.open();
												e.host.focus()
											}
										});
								this.addHandler(a(document), "mousemove."
										+ e.id, function(i) {
									var h = e.isOpened();
									if (h && e.autoOpen) {
										var m = e.host.coord();
										var l = m.top;
										var k = m.left;
										var j = e.container.coord();
										var f = j.left;
										var g = j.top;
										canClose = true;
										if (i.pageY >= l
												&& i.pageY <= l
														+ e.host.height() + 2) {
											if (i.pageX >= k
													&& i.pageX < k
															+ e.host.width()) {
												canClose = false
											}
										}
										if (i.pageY >= g
												&& i.pageY <= g
														+ e.container.height()
														- 20) {
											if (i.pageX >= f
													&& i.pageX < f
															+ e.container
																	.width()) {
												canClose = false
											}
										}
										if (canClose) {
											e.close()
										}
									}
								})
							}
							var c = "mousedown";
							if (this.touch) {
								c = a.jqx.mobile
										.getTouchEventName("touchstart")
							}
							var b = function(h) {
								if (!e.disabled) {
									var f = e.container.css("display") == "block";
									if (!e.isanimating) {
										if (f) {
											e.hideListBox("api");
											if (!a.jqx.mobile.isTouchDevice()) {
												e.input.focus();
												setTimeout(function() {
													e.input.focus()
												}, 10)
											}
											return true
										} else {
											if (e.autoDropDownHeight) {
												e.container
														.height(e.listBoxContainer
																.height() + 25);
												var g = e.listBoxContainer
														.jqxListBox("autoHeight");
												if (!g) {
													e.listBoxContainer
															.jqxListBox({
																autoHeight : e.autoDropDownHeight
															});
													e.listBox._arrange();
													e.listBox.ensureVisible(0);
													e.listBox._renderItems();
													e.container
															.height(e.listBoxContainer
																	.height() + 25)
												}
											}
											e.showListBox("api");
											if (!a.jqx.mobile.isTouchDevice()) {
												setTimeout(function() {
													e.input.focus()
												}, 10)
											} else {
												return true
											}
										}
									}
								}
							};
							this.addHandler(this.dropdownlistArrow, c,
									function(f) {
										b(f)
									});
							this.addHandler(this.dropdownlistArrowIcon, c,
									function(f) {
									});
							this.addHandler(this.host, "focus", function() {
								e.focus()
							});
							this
									.addHandler(
											this.input,
											"focus",
											function(f) {
												e.focused = true;
												e.host
														.addClass(e
																.toThemeProperty("jqx-combobox-state-focus"));
												e.host
														.addClass(e
																.toThemeProperty("jqx-fill-state-focus"));
												e.dropdownlistContent
														.addClass(e
																.toThemeProperty("jqx-combobox-content-focus"));
												if (f.stopPropagation) {
													f.stopPropagation()
												}
											});
							this
									.addHandler(
											this.input,
											"blur",
											function() {
												e.focused = false;
												if (!e.isOpened() && !e.opening) {
													if (e.selectionMode == "dropDownList") {
														e._selectOldValue()
													}
													e.host
															.removeClass(e
																	.toThemeProperty("jqx-combobox-state-focus"));
													e.host
															.removeClass(e
																	.toThemeProperty("jqx-fill-state-focus"));
													e.dropdownlistContent
															.removeClass(e
																	.toThemeProperty("jqx-combobox-content-focus"))
												}
												if (e._searchTimer) {
													clearTimeout(e._searchTimer)
												}
											});
							this.addHandler(a(document),
									"mousedown." + this.id,
									e.closeOpenedListBox, {
										that : this,
										listbox : this.listBox,
										id : this.id
									});
							if (this.touch) {
								this.addHandler(a(document), a.jqx.mobile
										.getTouchEventName("touchstart")
										+ "." + this.id, e.closeOpenedListBox,
										{
											that : this,
											listbox : this.listBox,
											id : this.id
										})
							}
							this
									.addHandler(
											this.host,
											"keydown",
											function(k) {
												var h = e.container
														.css("display") == "block";
												e.ctrlKey = k.ctrlKey;
												if (e.host.css("display") == "none") {
													return true
												}
												if (k.keyCode == "13"
														|| k.keyCode == "9") {
													if (h && !e.isanimating) {
														if (e.listBox.selectedIndex != -1) {
															e
																	.renderSelection("mouse");
															var f = e.listBox.selectedIndex;
															var j = e.listBox
																	.getVisibleItem(f);
															if (j) {
																e.listBox.selectedValue = j.value
															}
															e
																	._setSelection(
																			e.input
																					.val().length,
																			e.input
																					.val().length);
															e
																	.hideListBox("keyboard")
														}
														if (k.keyCode == "13") {
															e._oldvalue = e.listBox.selectedValue
														}
														if (!e.keyboardSelection) {
															e
																	._raiseEvent(
																			"2",
																			{
																				index : e.selectedIndex,
																				type : "keyboard",
																				item : e
																						.getItem(e.selectedIndex)
																			})
														}
														if (k.keyCode == "9") {
															return true
														}
														return false
													}
												}
												if (k.keyCode == 115) {
													if (!e.isanimating) {
														if (!e.isOpened()) {
															e
																	.showListBox("keyboard")
														} else {
															if (e.isOpened()) {
																e
																		.hideListBox("keyboard")
															}
														}
													}
													return false
												}
												if (k.altKey) {
													if (e.host.css("display") == "block") {
														if (!e.isanimating) {
															if (k.keyCode == 38) {
																if (e
																		.isOpened()) {
																	e
																			.hideListBox("altKey")
																}
															} else {
																if (k.keyCode == 40) {
																	if (!e
																			.isOpened()) {
																		e
																				.showListBox("altKey")
																	}
																}
															}
														}
													}
												}
												if (k.keyCode == "27"
														|| k.keyCode == "9") {
													if (e.isOpened()
															&& !e.isanimating) {
														if (k.keyCode == "27") {
															if (!e.multiSelect) {
																var j = e.listBox
																		.getItemByValue(e._oldvalue);
																if (j) {
																	setTimeout(
																			function() {
																				if (e.autoComplete) {
																					e
																							._updateItemsVisibility("")
																				}
																				e.listBox
																						.selectIndex(j.index);
																				e
																						.renderSelection("api")
																			},
																			e.closeDelay)
																} else {
																	e
																			.clearSelection()
																}
															} else {
																e.listBox.selectedValue = null;
																e.input.val("")
															}
														}
														e
																.hideListBox("keyboard");
														if (k.keyCode == "9") {
															return true
														}
														e
																.renderSelection("api");
														k.preventDefault();
														return false
													}
												}
												var g = k.keyCode;
												if (h && !e.disabled && g != 8) {
													return e.listBox
															._handleKeyDown(k)
												} else {
													if (!e.disabled && !h) {
														var g = k.keyCode;
														if (g == 33 || g == 34
																|| g == 35
																|| g == 36
																|| g == 38
																|| g == 40) {
															return e.listBox
																	._handleKeyDown(k)
														}
													}
												}
												if (g === 8 && e.multiSelect) {
													if (e.input.val().length === 0) {
														var i = e.selectedItems[e.selectedItems.length - 1];
														e.selectedItems.pop();
														e._selectedItems.pop();
														if (i) {
															e
																	._raiseEvent(
																			"3",
																			{
																				index : i.index,
																				type : "keyboard",
																				item : i
																			});
															e
																	._raiseEvent(
																			"4",
																			{
																				index : i.index,
																				type : "keyboard",
																				item : i
																			})
														}
														e.listBox.selectedValue = null;
														e.doMultiSelect();
														return false
													}
												}
											});
							this.addHandler(this.listBoxContainer,
									"checkChange", function(f) {
										e.renderSelection("mouse");
										e._updateInputSelection();
										e._raiseEvent(5, {
											label : f.args.label,
											value : f.args.value,
											checked : f.args.checked,
											item : f.args.item
										})
									});
							this
									.addHandler(
											this.listBoxContainer,
											"select",
											function(f) {
												if (!e.disabled) {
													if (f.args.type != "keyboard"
															|| e.keyboardSelection) {
														e
																.renderSelection(f.args.type);
														if (!e.multiSelect) {
															e
																	._raiseEvent(
																			"2",
																			{
																				index : f.args.index,
																				type : f.args.type,
																				item : f.args.item
																			})
														}
														if (f.args.type == "mouse") {
															e._oldvalue = e.listBox.selectedValue;
															if (!e.checkboxes) {
																e
																		.hideListBox("mouse");
																if (!e.touch) {
																	e.input
																			.focus()
																} else {
																	return false
																}
															}
														}
													}
												}
											});
							if (this.listBox != null
									&& this.listBox.content != null) {
								this
										.addHandler(
												this.listBox.content,
												"click",
												function(f) {
													if (!e.disabled) {
														if (e.listBox.itemswrapper) {
															if (f.target === e.listBox.itemswrapper[0]) {
																return true
															}
														}
														if (f.target
																&& f.target.className) {
															if (f.target.className
																	.indexOf("jqx-fill-state-disabled") >= 0) {
																return true
															}
														}
														e
																.renderSelection("mouse");
														e._oldvalue = e.listBox.selectedValue;
														if (!e.touch
																&& !e.ishiding) {
															if (!e.checkboxes) {
																e
																		.hideListBox("mouse");
																e.input.focus()
															}
														}
														if (e.touch === true) {
															if (!e.checkboxes) {
																e
																		.hideListBox("mouse")
															}
														}
													}
												})
							}
						},
						_selectOldValue : function() {
							var c = this;
							if (c.listBox.selectedIndex == -1) {
								if (!c.multiSelect) {
									var b = c.listBox
											.getItemByValue(c._oldvalue);
									if (b) {
										setTimeout(function() {
											if (c.autoComplete) {
												c._updateItemsVisibility("")
											}
											c.listBox.selectIndex(b.index);
											c.renderSelection("api")
										}, c.closeDelay)
									} else {
										c.clearSelection();
										c.listBox.selectIndex(0);
										c.renderSelection("api")
									}
								} else {
									c.listBox.selectedValue = null;
									c.input.val("")
								}
							} else {
								c.renderSelection("api")
							}
						},
						removeHandlers : function() {
							var c = this;
							if (this.dropdownlistWrapper != null) {
								this.removeHandler(this.dropdownlistWrapper,
										"mousedown")
							}
							if (this.dropdownlistContent) {
								this.removeHandler(this.dropdownlistContent,
										"click");
								this.removeHandler(this.dropdownlistContent,
										"focus")
							}
							this.removeHandler(this.host, "keydown");
							this.removeHandler(this.host, "focus");
							if (this.input != null) {
								this.removeHandler(this.input, "focus");
								this.removeHandler(this.input, "blur")
							}
							this.removeHandler(this.host, "mouseenter");
							this.removeHandler(this.host, "mouseleave");
							this
									.removeHandler(a(document), "mousemove."
											+ c.id);
							if (this.listBoxContainer) {
								this.removeHandler(this.listBoxContainer,
										"checkChange");
								this.removeHandler(this.listBoxContainer,
										"select")
							}
							if (this.host.parents()) {
								this.removeHandler(this.host.parents(),
										"scroll.combobox" + this.element.id)
							}
							if (this.dropdownlistArrowIcon
									&& this.dropdownlistArrow) {
								var b = "mousedown";
								if (this.touch) {
									b = a.jqx.mobile
											.getTouchEventName("touchstart")
								}
								this.removeHandler(this.dropdownlistArrowIcon,
										b);
								this.removeHandler(this.dropdownlistArrow, b)
							}
						},
						getItem : function(b) {
							var c = this.listBox.getItem(b);
							return c
						},
						getItemByValue : function(c) {
							var b = this.listBox.getItemByValue(c);
							return b
						},
						getVisibleItem : function(b) {
							var c = this.listBox.getVisibleItem(b);
							return c
						},
						renderSelection : function(j) {
							if (j == undefined || j == "none") {
								return
							}
							if (this._disableSelection === true) {
								return
							}
							if (this.listBox == null) {
								return
							}
							if (this.multiSelect) {
								return
							}
							var k = this.listBox.visibleItems[this.listBox.selectedIndex];
							if (this.autoComplete && !this.checkboxes) {
								if (this.listBox.selectedValue !== undefined) {
									var k = this
											.getItemByValue(this.listBox.selectedValue)
								}
							}
							if (this.checkboxes) {
								var f = this.getCheckedItems();
								if (f != null && f.length > 0) {
									k = f[0]
								} else {
									k = null
								}
							}
							if (k == null) {
								var d = a.jqx.browser.msie
										&& a.jqx.browser.version < 8;
								this.input.val("");
								this.input.attr("value", "");
								if (!d) {
									this.input.attr("placeholder",
											this.placeHolder)
								}
								this._updateInputSelection();
								return
							}
							this.selectedIndex = this.listBox.selectedIndex;
							var c = a("<span></span>");
							if (k.label != undefined && k.label != null
									&& k.label.toString().length > 0) {
								a.jqx.utilities.html(c, k.label)
							} else {
								if (k.value != undefined && k.value != null
										&& k.value.toString().length > 0) {
									a.jqx.utilities.html(c, k.value)
								} else {
									if (k.title != undefined && k.title != null
											&& k.title.toString().length > 0) {
										a.jqx.utilities.html(c, k.title)
									} else {
										a.jqx.utilities.html(c,
												this.emptyString)
									}
								}
							}
							var b = c.outerHeight();
							if (this.checkboxes) {
								var g = this.getCheckedItems();
								var h = "";
								for (var e = 0; e < g.length; e++) {
									if (e == g.length - 1) {
										h += g[e].label
									} else {
										h += g[e].label + ", "
									}
								}
								this.input.val(h)
							} else {
								this.input.val(c.text())
							}
							c.remove();
							this._updateInputSelection();
							if (this.renderSelectedItem) {
								var l = this.renderSelectedItem(
										this.listBox.selectedIndex, k);
								if (l != undefined) {
									this.input[0].value = l
								}
							}
							this.input.attr("value", this.input.val());
							if (this.listBox && this.listBox._activeElement) {
								a.jqx.aria(this, "aria-activedescendant",
										this.listBox._activeElement.id)
							}
						},
						dataBind : function() {
							this.listBoxContainer.jqxListBox({
								source : this.source
							});
							this.renderSelection("mouse");
							if (this.source == null) {
								this.clearSelection()
							}
						},
						clear : function() {
							this.listBoxContainer.jqxListBox({
								source : null
							});
							this.clearSelection()
						},
						clearSelection : function(b) {
							this.selectedIndex = -1;
							this.listBox.clearSelection();
							this.input.val("");
							if (this.multiSelect) {
								this.listBox.selectedValue = "";
								this.selectedItems = new Array();
								this._selectedItems = new Array();
								this.doMultiSelect(false)
							}
						},
						unselectIndex : function(c, d) {
							if (isNaN(c)) {
								return
							}
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							this.listBox.unselectIndex(c, d);
							this.renderSelection("mouse");
							if (this.multiSelect) {
								if (c >= 0) {
									var b = this.getItem(c);
									var e = this.selectedItems.indexOf(b.value);
									if (e >= 0) {
										if (b.value === this.listBox.selectedValue) {
											this.listBox.selectedValue = null
										}
										this.selectedItems.splice(e, 1);
										this._selectedItems.splice(e, 1)
									}
								}
								this.doMultiSelect(false)
							}
						},
						selectIndex : function(b, d, e, c) {
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							this.listBox.selectIndex(b, d, e, c);
							this.renderSelection("mouse");
							this.selectedIndex = b;
							if (this.multiSelect) {
								this.doMultiSelect()
							}
						},
						selectItem : function(b) {
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							if (this.listBox != undefined) {
								this.listBox.selectedIndex = -1;
								this.listBox.selectItem(b);
								this.selectedIndex = this.listBox.selectedIndex;
								this.renderSelection("mouse");
								if (this.multiSelect) {
									this.doMultiSelect(false)
								}
							}
						},
						unselectItem : function(d) {
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							if (this.listBox != undefined) {
								this.listBox.unselectItem(d);
								this.renderSelection("mouse");
								if (this.multiSelect) {
									var b = this.getItemByValue(d);
									if (b) {
										var c = this.selectedItems
												.indexOf(b.value);
										if (c >= 0) {
											if (b.value === this.listBox.selectedValue) {
												this.listBox.selectedValue = null
											}
											this.selectedItems.splice(c, 1);
											this._selectedItems.splice(c, 1)
										}
									}
									this.doMultiSelect(false)
								}
							}
						},
						checkItem : function(b) {
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							if (this.listBox != undefined) {
								this.listBox.checkItem(b)
							}
						},
						uncheckItem : function(b) {
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							if (this.listBox != undefined) {
								this.listBox.uncheckItem(b)
							}
						},
						indeterminateItem : function(b) {
							if (this.autoComplete) {
								this._updateItemsVisibility("")
							}
							if (this.listBox != undefined) {
								this.listBox.indeterminateItem(b)
							}
						},
						getSelectedValue : function() {
							return this.listBox.selectedValue
						},
						getSelectedIndex : function() {
							if (!this.multiSelect) {
								return this.listBox.selectedIndex
							} else {
								if (this.remoteAutoComplete && this.multiSelect
										&& this._selectedItems.length > 0) {
									return this.getSelectedItems()[0].index
								}
								if (this._selectedItems
										&& this._selectedItems.length > 0) {
									return this.getSelectedItems()[0].index
								}
							}
						},
						getSelectedItem : function() {
							if (!this.multiSelect) {
								return this
										.getVisibleItem(this.listBox.selectedIndex)
							} else {
								if (this.remoteAutoComplete && this.multiSelect
										&& this._selectedItems.length > 0) {
									return this.getSelectedItems()[0]
								}
								if (this._selectedItems
										&& this._selectedItems.length > 0) {
									return this.getSelectedItems()[0]
								}
								return null
							}
						},
						getSelectedItems : function() {
							if (this.remoteAutoComplete && this.multiSelect) {
								return this._selectedItems
							}
							var c = new Array();
							var b = this;
							a.each(this.selectedItems, function() {
								var d = b.getItemByValue(this);
								if (d) {
									c.push(d)
								} else {
									var d = b._selectedItems[this];
									if (d) {
										c.push(d)
									}
								}
							});
							return c
						},
						getCheckedItems : function() {
							return this.listBox.getCheckedItems()
						},
						checkIndex : function(b) {
							this.listBox.checkIndex(b)
						},
						uncheckIndex : function(b) {
							this.listBox.uncheckIndex(b)
						},
						indeterminateIndex : function(b) {
							this.listBox.indeterminateIndex(b)
						},
						checkAll : function() {
							this.listBox.checkAll();
							this.renderSelection("mouse")
						},
						uncheckAll : function() {
							this.listBox.uncheckAll();
							this.renderSelection("mouse")
						},
						insertAt : function(c, b) {
							if (c == null) {
								return false
							}
							return this.listBox.insertAt(c, b)
						},
						addItem : function(b) {
							return this.listBox.addItem(b)
						},
						removeAt : function(c) {
							var b = this.listBox.removeAt(c);
							this.renderSelection("mouse");
							return b
						},
						removeItem : function(c) {
							var b = this.listBox.removeItem(c);
							this.renderSelection("mouse");
							return b
						},
						updateItem : function(c, d) {
							var b = this.listBox.updateItem(c, d);
							this.renderSelection("mouse");
							return b
						},
						updateAt : function(d, c) {
							var b = this.listBox.updateAt(d, c);
							this.renderSelection("mouse");
							return b
						},
						ensureVisible : function(b) {
							return this.listBox.ensureVisible(b)
						},
						disableAt : function(b) {
							var c = this.getVisibleItem(b);
							if (c) {
								this._disabledItems.push(c.value)
							}
							return this.listBox.disableAt(b)
						},
						enableAt : function(b) {
							var c = this.getVisibleItem(b);
							if (c) {
								this._disabledItems.splice(this._disabledItems
										.indexOf(c.value), 1)
							}
							return this.listBox.enableAt(b)
						},
						disableItem : function(b) {
							var b = this.getVisibleItem(b);
							if (b) {
								this._disabledItems.push(b.value)
							}
							return this.listBox.disableItem(b)
						},
						enableItem : function(b) {
							var b = this.getVisibleItem(b);
							if (b) {
								this._disabledItems.splice(this._disabledItems
										.indexOf(b.value), 1)
							}
							return this.listBox.enableItem(b)
						},
						_findPos : function(c) {
							while (c
									&& (c.type == "hidden" || c.nodeType != 1 || a.expr.filters
											.hidden(c))) {
								c = c.nextSibling
							}
							if (c) {
								var b = a(c).coord(true);
								return [ b.left, b.top ]
							}
						},
						testOffset : function(h, f, c) {
							var g = h.outerWidth();
							var j = h.outerHeight();
							var i = a(window).width() + a(window).scrollLeft();
							var e = a(window).height() + a(window).scrollTop();
							if (f.left + g > i) {
								if (g > this.host.width()) {
									var d = this.host.coord().left;
									var b = g - this.host.width();
									f.left = d - b + 2
								}
							}
							if (f.left < 0) {
								f.left = parseInt(this.host.coord().left)
										+ "px"
							}
							f.top -= Math.min(f.top,
									(f.top + j > e && e > j) ? Math.abs(j + c
											+ 23) : 0);
							return f
						},
						open : function() {
							if (!this.isOpened() && !this.opening) {
								this.showListBox("api")
							}
						},
						close : function() {
							if (this.isOpened()) {
								this.hideListBox("api")
							}
						},
						_getBodyOffset : function() {
							var c = 0;
							var b = 0;
							if (a("body").css("border-top-width") != "0px") {
								c = parseInt(a("body").css("border-top-width"));
								if (isNaN(c)) {
									c = 0
								}
							}
							if (a("body").css("border-left-width") != "0px") {
								b = parseInt(a("body").css("border-left-width"));
								if (isNaN(b)) {
									b = 0
								}
							}
							return {
								left : b,
								top : c
							}
						},
						showListBox : function(n) {
							if (this.listBox.items
									&& this.listBox.items.length == 0) {
								return
							}
							if (n == "search" && !this.autoComplete
									&& !this.remoteAutoComplete) {
								if (this.autoDropDownHeight) {
									this.container.height(this.listBoxContainer
											.height() + 25)
								}
							}
							if (this.autoComplete || this.multiSelect
									&& !this.remoteAutoComplete) {
								if (n != "search") {
									this._updateItemsVisibility("");
									if (this.multiSelect) {
										var r = this.getVisibleItems();
										for (var x = 0; x < r.length; x++) {
											if (!r[x].disabled) {
												this.ensureVisible(x);
												break
											}
										}
									}
								}
							}
							if (this.remoteAutoComplete) {
								this.listBox.clearSelection()
							}
							if (n != "search") {
								this._oldvalue = this.listBox.selectedValue
							}
							a.jqx.aria(this, "aria-expanded", true);
							if (this.dropDownWidth == "auto"
									&& this.width != null && this.width.indexOf
									&& this.width.indexOf("%") != -1) {
								if (this.listBox.host.width() != this.host
										.width()) {
									var u = this.host.width();
									this.listBoxContainer.jqxListBox({
										width : u
									});
									this.container.width(parseInt(u) + 25)
								}
							}
							var j = this;
							var h = this.listBoxContainer;
							var z = this.listBox;
							var e = a(window).scrollTop();
							var f = a(window).scrollLeft();
							var p = parseInt(this._findPos(this.host[0])[1])
									+ parseInt(this.host.outerHeight()) - 1
									+ "px";
							var d, s = parseInt(Math.round(this.host
									.coord(true).left));
							d = s + "px";
							var y = a.jqx.mobile.isSafariMobileBrowser()
									|| a.jqx.mobile.isWindowsPhone();
							this.ishiding = false;
							var g = a.jqx.utilities.hasTransform(this.host);
							if (g || (y != null && y)) {
								d = a.jqx.mobile.getLeftPos(this.element);
								p = a.jqx.mobile.getTopPos(this.element)
										+ parseInt(this.host.outerHeight());
								if (a("body").css("border-top-width") != "0px") {
									p = parseInt(p) - this._getBodyOffset().top
											+ "px"
								}
								if (a("body").css("border-left-width") != "0px") {
									d = parseInt(d)
											- this._getBodyOffset().left + "px"
								}
							}
							this.host
									.addClass(this
											.toThemeProperty("jqx-combobox-state-selected"));
							if (this.dropDownVerticalAlignment == "top") {
								this.dropdownlistArrowIcon
										.addClass(this
												.toThemeProperty("jqx-icon-arrow-up-selected"))
							} else {
								this.dropdownlistArrowIcon
										.addClass(this
												.toThemeProperty("jqx-icon-arrow-down-selected"))
							}
							this.dropdownlistArrow
									.addClass(this
											.toThemeProperty("jqx-combobox-arrow-selected"));
							this.dropdownlistArrow.addClass(this
									.toThemeProperty("jqx-fill-state-pressed"));
							this.host
									.addClass(this
											.toThemeProperty("jqx-combobox-state-focus"));
							this.host.addClass(this
									.toThemeProperty("jqx-fill-state-focus"));
							this.dropdownlistContent
									.addClass(this
											.toThemeProperty("jqx-combobox-content-focus"));
							this.container.css("left", d);
							this.container.css("top", p);
							z._arrange();
							var c = true;
							var b = false;
							if (this.dropDownHorizontalAlignment == "right"
									|| this.rtl) {
								var l = this.container.outerWidth();
								var v = Math.abs(l - this.host.width());
								if (l > this.host.width()) {
									this.container.css("left", 25
											+ parseInt(Math.round(s)) - v
											+ "px")
								} else {
									this.container.css("left", 25
											+ parseInt(Math.round(s)) + v
											+ "px")
								}
							}
							if (this.dropDownVerticalAlignment == "top") {
								var w = h.height();
								b = true;
								h.css("top", 23);
								h
										.addClass(this
												.toThemeProperty("jqx-popup-up"));
								var o = parseInt(this.host.outerHeight());
								var m = parseInt(p) - Math.abs(w + o + 23);
								this.container.css("top", m)
							}
							if (this.enableBrowserBoundsDetection) {
								var k = this.testOffset(h,
										{
											left : parseInt(this.container
													.css("left")),
											top : parseInt(p)
										}, parseInt(this.host.outerHeight()));
								if (parseInt(this.container.css("top")) != k.top) {
									b = true;
									h.css("top", 23);
									h.addClass(this
											.toThemeProperty("jqx-popup-up"))
								} else {
									h.css("top", 0)
								}
								this.container.css("top", k.top);
								this.container.css("top", k.top);
								if (parseInt(this.container.css("left")) != k.left) {
									this.container.css("left", k.left)
								}
							}
							if (this.animationType == "none") {
								this.container.css("display", "block");
								a.data(document.body,
										"openedCombojqxListBoxParent", j);
								a.data(document.body, "openedCombojqxListBox"
										+ j.element.id, h);
								h.css("margin-top", 0);
								h.css("opacity", 1)
							} else {
								this.container.css("display", "block");
								var q = h.outerHeight();
								h.stop();
								if (this.animationType == "fade") {
									h.css("margin-top", 0);
									h.css("opacity", 0);
									h.animate({
										opacity : 1
									}, this.openDelay, function() {
										j.isanimating = false;
										j.opening = false;
										a.data(document.body,
												"openedCombojqxListBoxParent",
												j);
										a.data(document.body,
												"openedCombojqxListBox"
														+ j.element.id, h)
									})
								} else {
									h.css("opacity", 1);
									if (b) {
										h.css("margin-top", q)
									} else {
										h.css("margin-top", -q)
									}
									this.isanimating = true;
									this.opening = true;
									h.animate({
										"margin-top" : 0
									}, this.openDelay, function() {
										j.isanimating = false;
										j.opening = false;
										a.data(document.body,
												"openedCombojqxListBoxParent",
												j);
										a.data(document.body,
												"openedCombojqxListBox"
														+ j.element.id, h)
									})
								}
							}
							z._renderItems();
							if (!b) {
								this.host.addClass(this
										.toThemeProperty("jqx-rc-b-expanded"));
								h.addClass(this
										.toThemeProperty("jqx-rc-t-expanded"));
								this.dropdownlistArrow.addClass(this
										.toThemeProperty("jqx-rc-b-expanded"))
							} else {
								this.host.addClass(this
										.toThemeProperty("jqx-rc-t-expanded"));
								h.addClass(this
										.toThemeProperty("jqx-rc-b-expanded"));
								this.dropdownlistArrow.addClass(this
										.toThemeProperty("jqx-rc-t-expanded"))
							}
							h.addClass(this
									.toThemeProperty("jqx-fill-state-focus"));
							this._raiseEvent("0", z)
						},
						doMultiSelect : function(c) {
							if (this.checkboxes) {
								this.multiSelect = false
							}
							var e = this;
							if (!this.multiSelect) {
								var g = e.dropdownlistContent
										.find(".jqx-button");
								var d = "mousedown";
								if (this.touch) {
									d = a.jqx.mobile
											.getTouchEventName("touchstart")
								}
								this.removeHandler(g, d);
								this
										.removeHandler(g
												.find(".jqx-icon-close"), d);
								g.remove();
								var f = this.listBox.items;
								if (!f) {
									return
								}
								for (var b = 0; b < f.length; b++) {
									f[b].disabled = false
								}
								this.listBox._renderItems();
								this.selectedItems = new Array();
								this._selectedItems = new Array();
								return
							}
							if (this.validateSelection) {
								var k = this
										.validateSelection(this.listBox.selectedValue);
								if (!k) {
									return
								}
							}
							var h = this.selectedItems;
							if (this.listBox.selectedValue) {
								if (this.selectedItems
										.indexOf(this.listBox.selectedValue) === -1) {
									var j = this
											.getItemByValue(this.listBox.selectedValue);
									if (j && j.visible) {
										this.selectedItems
												.push(this.listBox.selectedValue);
										this._selectedItems.push(j);
										this._raiseEvent("2", {
											index : j.index,
											item : j
										});
										this._raiseEvent("4", {
											index : j.index,
											item : j
										})
									}
								}
								this.listBox.selectedIndex = 0
							}
							var f = this.listBox.items;
							if (!f) {
								return
							}
							for (var b = 0; b < f.length; b++) {
								f[b].disabled = false;
								if (this.selectedItems.indexOf(f[b].value) >= 0
										|| this._disabledItems
												.indexOf(this.value) >= 0) {
									f[b].disabled = true
								}
							}
							this.listBox._renderItems();
							this.searchString = "";
							this.input.val("");
							var f = "";
							var d = "mousedown";
							var g = e.dropdownlistContent.find(".jqx-button");
							if (this.touch) {
								d = a.jqx.mobile
										.getTouchEventName("touchstart")
							}
							this.removeHandler(g, d);
							this.removeHandler(g.find(".jqx-icon-close"), d);
							g.remove();
							e.input.detach();
							if (this.selectedItems.length > 0) {
								e.input.css("width", "25px");
								e.input.attr("placeholder", "")
							} else {
								e.input.css("width", "100%");
								e.input.attr("placeholder", this.placeHolder)
							}
							a
									.each(
											this.selectedItems,
											function(l) {
												var n = e.getItemByValue(this);
												if (!n || e.remoteAutoComplete) {
													n = e._selectedItems[l]
												}
												var p = a('<div style="overflow: hidden; float: left;"></div>');
												p
														.addClass(e
																.toThemeProperty("jqx-button"));
												p
														.addClass(e
																.toThemeProperty("jqx-combobox-multi-item"));
												p
														.addClass(e
																.toThemeProperty("jqx-fill-state-normal"));
												p
														.addClass(e
																.toThemeProperty("jqx-rc-all"));
												if (n) {
													var q = n.label;
													if (e.renderSelectedItem) {
														var i = e
																.renderSelectedItem(
																		l, n);
														if (i) {
															q = i
														}
													}
													if (p[0].innerHTML == "") {
														p[0].innerHTML = '<a data-value="'
																+ n.value
																+ '" style="float: left;" href="#">'
																+ q + "</a>"
													}
													if (e.rtl) {
														p[0].innerHTML = '<a data-value="'
																+ n.value
																+ '" style="float: right;" href="#">'
																+ q + "</a>"
													}
													var o = !e.rtl ? "right"
															: "left";
													if (e.showCloseButtons) {
														var m = '<div style="position: relative; overflow: hidden; float: '
																+ o
																+ '; min-height: 16px; min-width: 18px;"><div style="position: absolute; left: 100%; top: 50%; margin-left: -18px; margin-top: -7px; float: none; width: 16px; height: 16px;" class="'
																+ e
																		.toThemeProperty("jqx-icon-close")
																+ '"></div></div>';
														if (a.jqx.browser.msie
																&& a.jqx.browser.version < 8) {
															m = '<div style="position: relative; overflow: hidden; float: left; min-height: 16px; min-width: 18px;"><div style="position: absolute; left: 100%; top: 50%; margin-left: -18px; margin-top: -7px; float: none; width: 16px; height: 16px;" class="'
																	+ e
																			.toThemeProperty("jqx-icon-close")
																	+ '"></div></div>'
														}
														if (e.rtl) {
															var m = '<div style="position: relative; overflow: hidden; float: '
																	+ o
																	+ '; min-height: 16px; min-width: 18px;"><div style="position: absolute; left: 0px; top: 50%; margin-top: -7px; float: none; width: 16px; height: 16px;" class="'
																	+ e
																			.toThemeProperty("jqx-icon-close")
																	+ '"></div></div>';
															if (a.jqx.browser.msie
																	&& a.jqx.browser.version < 8) {
																m = '<div style="position: relative; overflow: hidden; float: left; min-height: 16px; min-width: 18px;"><div style="position: absolute; left: 0px; top: 50%; margin-top: -7px; float: none; width: 16px; height: 16px;" class="'
																		+ e
																				.toThemeProperty("jqx-icon-close")
																		+ '"></div></div>'
															}
														}
														p[0].innerHTML += m
													}
												} else {
													if (p[0].innerHTML == "") {
														p[0].innerHTML = '<a href="#"></a>'
													}
												}
												e.dropdownlistContent.append(p)
											});
							e.dropdownlistContent.append(e.input);
							e.input.val("");
							if (c !== false) {
								e.input.focus();
								setTimeout(function() {
									e.input.focus()
								}, 10)
							}
							var g = e.dropdownlistContent.find(".jqx-button");
							if (this.touchMode === true) {
								d = "mousedown"
							}
							this.addHandler(g, d, function(l) {
								if (l.target.className
										.indexOf("jqx-icon-close") >= 0) {
									return true
								}
								if (e.disabled) {
									return true
								}
								var m = a(l.target).attr("data-value");
								var i = e.getItemByValue(m);
								if (i) {
									e.listBox.selectedValue = null;
									e.listBox.clearSelection()
								}
								e.listBox.scrollTo(0, 0);
								e.open();
								if (l.preventDefault) {
									l.preventDefault()
								}
								if (l.stopPropagation) {
									l.stopPropagation()
								}
								return false
							});
							this
									.addHandler(
											g.find(".jqx-icon-close"),
											d,
											function(p) {
												if (e.disabled) {
													return
												}
												var r = a(p.target).parent()
														.parent().find("a")
														.attr("data-value");
												var o = e.getItemByValue(r);
												if (o
														|| (e.remoteAutoComplete
																&& !o && e.selectedItems
																.indexOf(r) >= 0)) {
													e.listBox.selectedValue = null;
													var l = e.selectedItems
															.indexOf(r);
													var n = o && o.index >= 0 ? o.index
															: l;
													if (l >= 0) {
														e.selectedItems.splice(
																l, 1);
														var q = e._selectedItems[l];
														if (!q) {
															q = o
														}
														e._selectedItems
																.splice(l, 1);
														e._raiseEvent("3", {
															index : n,
															type : "mouse",
															item : q
														});
														e._raiseEvent("4", {
															index : n,
															type : "mouse",
															item : q
														});
														e.doMultiSelect()
													} else {
														for (var m = 0; m < e.selectedItems.length; m++) {
															var q = e.selectedItems[m];
															if (q == r) {
																e.selectedItems
																		.splice(
																				m,
																				1);
																e._selectedItems
																		.splice(
																				m,
																				1);
																e
																		._raiseEvent(
																				"3",
																				{
																					index : n,
																					type : "mouse",
																					item : o
																				});
																e
																		._raiseEvent(
																				"4",
																				{
																					index : n,
																					type : "mouse",
																					item : o
																				});
																e
																		.doMultiSelect();
																break
															}
														}
													}
												}
											});
							e.dropdownlistArrow.height(this.host.height());
							e._updateInputSelection()
						},
						hideListBox : function(h) {
							var f = this.listBoxContainer;
							var g = this.listBox;
							var c = this.container;
							if (this.container[0].style.display == "none") {
								return
							}
							a.jqx.aria(this, "aria-expanded", false);
							if (h == "keyboard" || h == "mouse") {
								this.listBox.searchString = ""
							}
							if (h == "keyboard" || h == "mouse"
									&& this.multiSelect) {
								this.doMultiSelect()
							}
							var d = this;
							a.data(document.body, "openedCombojqxListBox"
									+ this.element.id, null);
							if (this.animationType == "none") {
								this.opening = false;
								this.container.css("display", "none")
							} else {
								if (!this.ishiding) {
									var b = f.outerHeight();
									f.css("margin-top", 0);
									f.stop();
									this.opening = false;
									this.isanimating = true;
									var e = -b;
									if (parseInt(this.container.coord().top) < parseInt(this.host
											.coord().top)) {
										e = b
									}
									if (this.animationType == "fade") {
										f.css({
											opacity : 1
										});
										f.animate({
											opacity : 0
										}, this.closeDelay, function() {
											d.isanimating = false;
											c.css("display", "none");
											d.ishiding = false
										})
									} else {
										f.animate({
											"margin-top" : e
										}, this.closeDelay, function() {
											d.isanimating = false;
											c.css("display", "none");
											d.ishiding = false
										})
									}
								}
							}
							this.ishiding = true;
							this.host
									.removeClass(this
											.toThemeProperty("jqx-combobox-state-selected"));
							this.dropdownlistArrowIcon
									.removeClass(this
											.toThemeProperty("jqx-icon-arrow-down-selected"));
							this.dropdownlistArrowIcon
									.removeClass(this
											.toThemeProperty("jqx-icon-arrow-up-selected"));
							this.dropdownlistArrow
									.removeClass(this
											.toThemeProperty("jqx-combobox-arrow-selected"));
							this.dropdownlistArrow.removeClass(this
									.toThemeProperty("jqx-fill-state-pressed"));
							if (!this.focused) {
								this.host
										.removeClass(this
												.toThemeProperty("jqx-combobox-state-focus"));
								this.host
										.removeClass(this
												.toThemeProperty("jqx-fill-state-focus"));
								this.dropdownlistContent
										.removeClass(this
												.toThemeProperty("jqx-combobox-content-focus"))
							}
							this.host.removeClass(this
									.toThemeProperty("jqx-rc-b-expanded"));
							f.removeClass(this
									.toThemeProperty("jqx-rc-t-expanded"));
							this.host.removeClass(this
									.toThemeProperty("jqx-rc-t-expanded"));
							f.removeClass(this
									.toThemeProperty("jqx-rc-b-expanded"));
							f.removeClass(this
									.toThemeProperty("jqx-fill-state-focus"));
							this.dropdownlistArrow.removeClass(this
									.toThemeProperty("jqx-rc-t-expanded"));
							this.dropdownlistArrow.removeClass(this
									.toThemeProperty("jqx-rc-b-expanded"));
							this._raiseEvent("1", g)
						},
						closeOpenedListBox : function(e) {
							var d = e.data.that;
							var b = a(e.target);
							var c = e.data.listbox;
							if (c == null) {
								return true
							}
							if (a(e.target).ischildof(d.host)) {
								return
							}
							var f = d;
							var g = false;
							a
									.each(
											b.parents(),
											function() {
												if (this.className != "undefined") {
													if (this.className.indexOf) {
														if (this.className
																.indexOf("jqx-listbox") != -1) {
															g = true;
															return false
														}
														if (this.className
																.indexOf("jqx-combobox") != -1) {
															if (d.element.id == this.id) {
																g = true
															}
															return false
														}
													}
												}
											});
							if (c != null && !g) {
								if (d.isOpened()) {
									d.hideListBox("api");
									d.input.blur()
								}
							}
							return true
						},
						loadFromSelect : function(b) {
							this.listBox.loadFromSelect(b);
							this.clearSelection()
						},
						refresh : function(b) {
							this._setSize();
							this._arrange();
							if (this.listBox) {
								this.renderSelection()
							}
						},
						resize : function() {
							this._setSize();
							this._arrange()
						},
						_arrange : function() {
							var d = parseInt(this.host.width());
							var j = parseInt(this.host.height());
							var e = this.arrowSize;
							var f = this.arrowSize;
							var h = 1;
							if (!this.showArrow) {
								f = 0;
								e = 0;
								this.dropdownlistArrow.hide();
								h = 0;
								this.host.css("cursor", "arrow")
							} else {
								if (this.dropdownlistArrow[0].style.display === "none") {
									this.dropdownlistArrow.show()
								}
							}
							var b = d - f - 1 * h;
							if (b > 0) {
								this.dropdownlistContent[0].style.width = b
										+ "px"
							}
							if (this.rtl) {
								this.dropdownlistContent[0].style.width = (-1
										+ b + "px")
							}
							this.dropdownlistContent[0].style.height = j + "px";
							this.dropdownlistContent[0].style.left = "0px";
							this.dropdownlistContent[0].style.top = "0px";
							this.dropdownlistArrow[0].style.width = f + 1
									+ "px";
							this.dropdownlistArrow[0].style.height = j + "px";
							this.dropdownlistArrow[0].style.left = 1 + b + "px";
							this.input[0].style.width = "100%";
							if (!this.multiSelect) {
								this.input.height(j)
							}
							var c = this.input.height();
							if (c == 0) {
								c = parseInt(this.input.css("font-size")) + 3
							}
							if (this.input[0].className.indexOf("jqx-rc-all") == -1) {
								this.input.addClass(this
										.toThemeProperty("jqx-rc-all"))
							}
							var i = parseInt(j) / 2 - parseInt(c) / 2;
							if (i > 0) {
							}
							if (this.rtl) {
								this.dropdownlistArrow.css("left", "0px");
								this.dropdownlistContent.css("left",
										this.dropdownlistArrow.width());
								if (a.jqx.browser.msie
										&& a.jqx.browser.version <= 8) {
									this.dropdownlistContent.css("left",
											1 + this.dropdownlistArrow.width())
								}
							}
							if (this.multiSelect) {
								this.input.css("float", "left");
								this.input.width(25);
								this.dropdownlistWrapper.parent().css("height",
										"auto");
								this.dropdownlistContent.css("height", "auto");
								this.dropdownlistWrapper.css("height", "auto");
								this.dropdownlistContent.css("position",
										"relative");
								this.dropdownlistContent.css("cursor", "text");
								this.host.css("height", "auto");
								this.host.css("min-height", this.height);
								this.dropdownlistContent.css("min-height",
										this.height);
								var j = parseInt(this.host.height());
								this.dropdownlistArrow.height(j);
								var g = parseInt(this.host.css("min-height"));
								var i = parseInt(g) / 2 - parseInt(c) / 2;
								if (i > 0) {
									this.input.css("margin-top", i)
								}
							}
						},
						destroy : function() {
							if (this.source && this.source.unbindBindingUpdate) {
								this.source
										.unbindBindingUpdate(this.element.id);
								this.source
										.unbindBindingUpdate(this.listBoxContainer[0].id);
								this.source
										.unbindDownloadComplete(this.element.id);
								this.source
										.unbindDownloadComplete(this.listBoxContainer[0].id)
							}
							a.jqx.utilities.resize(this.host, null, true);
							this.removeHandler(this.listBoxContainer, "select");
							this.removeHandler(this.listBoxContainer,
									"unselect");
							this.removeHandler(this.listBoxContainer, "change");
							this.removeHandler(this.listBoxContainer,
									"bindingComplete");
							this.removeHandler(this.dropdownlistWrapper,
									"selectstart");
							this.removeHandler(this.dropdownlistWrapper,
									"mousedown");
							this.removeHandler(this.host, "keydown");
							this.removeHandler(this.listBoxContainer, "select");
							this.removeHandler(this.listBox.content, "click");
							this.removeHandlers();
							this.removeHandler(this.input, "keyup.textchange");
							this.listBoxContainer.jqxListBox("destroy");
							this.listBoxContainer.remove();
							this.host.removeClass();
							this.removeHandler(a(document), "mousedown."
									+ this.id, this.closeOpenedListBox);
							if (this.touch) {
								this.removeHandler(a(document), a.jqx.mobile
										.getTouchEventName("touchstart")
										+ "." + this.id)
							}
							this.cinput.remove();
							delete this.cinput;
							this.dropdownlistArrow.remove();
							delete this.dropdownlistArrow;
							this.dropdownlistArrowIcon.remove();
							delete this.dropdownlistArrowIcon;
							delete this.dropdownlistWrapper;
							delete this.listBoxContainer;
							delete this.input;
							delete this.dropdownlistContent;
							delete this.comboStructure;
							this.container.remove();
							delete this.listBox;
							delete this.container;
							var b = a.data(this.element, "jqxComboBox");
							if (b) {
								delete b.instance
							}
							this.host.removeData();
							this.host.remove();
							delete this.host;
							delete this.set;
							delete this.get;
							delete this.call;
							delete this.element
						},
						_raiseEvent : function(f, c) {
							if (c == undefined) {
								c = {
									owner : null
								}
							}
							var d = this.events[f];
							args = c;
							args.owner = this;
							var e = new a.Event(d);
							e.owner = this;
							if (f == 2 || f == 3 || f == 4 || f == 5 || f == 6
									|| f == 7 || f == 8 || f == 9) {
								e.args = c
							}
							var b = this.host.trigger(e);
							return b
						},
						propertiesChangedHandler : function(b, c, e) {
							if (e.width && e.height
									&& Object.keys(e).length == 2) {
								b._setSize();
								if (c == "width") {
									if (b.dropDownWidth == "auto") {
										var d = b.host.width();
										b.listBoxContainer.jqxListBox({
											width : d
										});
										b.container.width(parseInt(d) + 25)
									}
								}
								b._arrange();
								b.close()
							}
						},
						propertyChangedHandler : function(d, f, j, h) {
							if (d.isInitialized == undefined
									|| d.isInitialized == false) {
								return
							}
							if (d.batchUpdate && d.batchUpdate.width
									&& d.batchUpdate.height
									&& Object.keys(d.batchUpdate).length == 2) {
								return
							}
							if (f == "template") {
								d.listBoxContainer.removeClass(d
										.toThemeProperty("jqx-" + j + "-item"));
								d.listBoxContainer.addClass(d
										.toThemeProperty("jqx-" + d.template
												+ "-item"));
								d.dropDownListArrow.removeClass(d
										.toThemeProperty("jqx-" + j + ""));
								d.dropDownListArrow.addClass(d
										.toThemeProperty("jqx-" + d.template
												+ ""))
							}
							if (f == "dropDownVerticalAlignment") {
								d.dropdownlistArrowIcon.removeClass(d
										.toThemeProperty("jqx-icon-arrow-up"));
								d.dropdownlistArrowIcon
										.removeClass(d
												.toThemeProperty("jqx-icon-arrow-down"));
								if (d.dropDownVerticalAlignment == "top") {
									d.dropdownlistArrowIcon
											.addClass(d
													.toThemeProperty("jqx-icon-arrow-up"))
								} else {
									d.dropdownlistArrowIcon
											.addClass(d
													.toThemeProperty("jqx-icon-arrow-down"))
								}
								d.listBoxContainer.css("top", 0);
								d.listBoxContainer.removeClass(this
										.toThemeProperty("jqx-popup-up"))
							}
							if (f == "autoItemsHeight") {
								d.listBoxContainer.jqxListBox({
									autoItemsHeight : h
								})
							}
							if (f == "itemHeight") {
								d.listBoxContainer.jqxListBox({
									itemHeight : h
								})
							}
							if (f == "renderSelectedItem") {
								d.renderSelection("mouse")
							}
							if (f == "renderer") {
								d.listBoxContainer.jqxListBox({
									renderer : h
								})
							}
							if (f == "enableSelection") {
								d.listBoxContainer.jqxListBox({
									enableSelection : h
								})
							}
							if (f == "enableHover") {
								d.listBoxContainer.jqxListBox({
									enableHover : h
								})
							}
							if (f === "touchMode") {
								d.listBoxContainer.jqxListBox({
									touchMode : h
								});
								d.touch = a.jqx.mobile.isTouchDevice();
								if (d.touchMode === true) {
									d.touch = true
								}
								d._updateHandlers()
							}
							if (f == "multiSelect") {
								if (h) {
									d.doMultiSelect(false)
								} else {
									var c = d.listBox.items;
									var b = -1;
									for (var e = 0; e < c.length; e++) {
										c[e].disabled = false;
										if (d.selectedItems.indexOf(c[e].value) >= 0
												|| d._disabledItems
														.indexOf(d.value) >= 0) {
											c[e].disabled = true;
											b = c[e].index
										}
									}
									d.doMultiSelect(false);
									d.listBox._renderItems();
									if (!c) {
										return
									}
									d.listBox.selectedIndex = b;
									d.renderSelection("mouse");
									d.dropdownlistWrapper.parent().css(
											"height", "100%");
									d.dropdownlistContent.css("height", "100");
									d.dropdownlistWrapper.css("height", "100");
									d.dropdownlistContent.css("position",
											"relative");
									d.host.css("min-height", null);
									d._setSize();
									d._arrange()
								}
							}
							if (f == "showArrow") {
								d._arrange();
								if (d.multiSelect) {
									d.doMultiSelect(false)
								}
							}
							if (f == "placeHolder") {
								d.input.attr("placeholder", d.placeHolder)
							}
							if (f == "popupZIndex") {
								d.listBoxContainer.css({
									zIndex : d.popupZIndex
								})
							}
							if (f == "promptText") {
								d.placeHolder = h
							}
							if (f == "autoOpen") {
								d._updateHandlers()
							}
							if (f == "renderer") {
								d.listBox.renderer = d.renderer
							}
							if (f == "itemHeight") {
								d.listBox.itemHeight = h
							}
							if (f == "source") {
								d.input.val("");
								d.listBoxContainer.jqxListBox({
									source : d.source
								});
								d.renderSelection("mouse");
								if (d.source == null) {
									d.clearSelection()
								}
								if (d.multiSelect) {
									d.selectedItems = new Array();
									d._selectedItems = new Array();
									d.doMultiSelect(false)
								}
							}
							if (f == "rtl") {
								if (h) {
									d.dropdownlistArrow.css("float", "left");
									d.dropdownlistContent.css("float", "right")
								} else {
									d.dropdownlistArrow.css("float", "right");
									d.dropdownlistContent.css("float", "left")
								}
								d.listBoxContainer.jqxListBox({
									rtl : d.rtl
								})
							}
							if (f == "displayMember" || f == "valueMember") {
								d.listBoxContainer.jqxListBox({
									displayMember : d.displayMember,
									valueMember : d.valueMember
								});
								d.renderSelection("mouse")
							}
							if (f == "autoDropDownHeight") {
								d.listBoxContainer.jqxListBox({
									autoHeight : d.autoDropDownHeight
								});
								if (d.autoDropDownHeight) {
									d.container.height(d.listBoxContainer
											.height() + 25)
								} else {
									d.listBoxContainer.jqxListBox({
										height : d.dropDownHeight
									});
									d.container
											.height(parseInt(d.dropDownHeight) + 25)
								}
								d.listBox._arrange();
								d.listBox._updatescrollbars()
							}
							if (f == "dropDownHeight") {
								if (!d.autoDropDownHeight) {
									d.listBoxContainer.jqxListBox({
										height : d.dropDownHeight
									});
									d.container
											.height(parseInt(d.dropDownHeight) + 25)
								}
							}
							if (f == "dropDownWidth" || f == "scrollBarSize") {
								var g = d.width;
								if (d.dropDownWidth != "auto") {
									g = d.dropDownWidth
								}
								d.listBoxContainer.jqxListBox({
									width : g,
									scrollBarSize : d.scrollBarSize
								});
								d.container.width(parseInt(g) + 25)
							}
							if (f == "autoComplete") {
								d._resetautocomplete()
							}
							if (f == "checkboxes") {
								d.listBoxContainer.jqxListBox({
									checkboxes : d.checkboxes
								});
								if (d.checkboxes) {
									d.input.attr("readonly", true);
									a.jqx.aria(d, "aria-readonly", true)
								} else {
									a.jqx.aria(d, "aria-readonly", false)
								}
							}
							if (f == "theme" && h != null) {
								d.listBoxContainer.jqxListBox({
									theme : h
								});
								d.listBoxContainer.addClass(d
										.toThemeProperty("jqx-popup"));
								if (a.jqx.browser.msie) {
									d.listBoxContainer.addClass(d
											.toThemeProperty("jqx-noshadow"))
								}
								a.jqx.utilities.setTheme(j, h, d.host)
							}
							if (f == "rtl") {
								d.render();
								d.refresh()
							}
							if (f == "width" || f == "height") {
								d._setSize();
								if (f == "width") {
									if (d.dropDownWidth == "auto") {
										var g = d.host.width();
										d.listBoxContainer.jqxListBox({
											width : g
										});
										d.container.width(parseInt(g) + 25)
									}
								}
								d._arrange();
								d.close()
							}
							if (f == "selectedIndex") {
								d.listBox.selectIndex(h);
								d.renderSelection("mouse")
							}
						}
					})
})(jqxBaseFramework);