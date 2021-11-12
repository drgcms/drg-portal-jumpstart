/**
 * @license Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
//	config.language = 'sl';
	//	config.uiColor = '#AADC6E';
  config.uiColor = '#ccddee';
  config.filebrowserBrowseUrl       = '/assets/elfinder/elfinder.html';
//  config.filebrowserUploadUrl       = '/elfinder/datoteke';
//  config.filebrowserImageBrowseUrl  = '/elfinder/datoteke';
//  config.filebrowserImageUploadUrl  = '/elfinder/datoteke';
  config.filebrowserWindowWidth  	= 800;
  config.filebrowserWindowHeight  = 500;
	config.extraAllowedContent      = ['span(*)','button[name]']

/* */
config.toolbar_basic = [
    [ 'Save', '-', 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],
    [ 'Bold', 'Italic', 'Underline', '-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Source']
];

//config.toolbar = config.toolbar_basic;

//config.skin = 'moono,/assets/ckeditor/skins/moono/';

};

CKEDITOR.stylesSet.add( 'default', [
	/* Block Styles */

	// These styles are already available in the "Format" combo ("format" plugin),
	// so they are not needed here by default. You may enable them to avoid
	// placing the "Format" combo in the toolbar, maintaining the same features.
	/*
	{ name: 'Paragraph',		element: 'p' },
	{ name: 'Heading 1',		element: 'h1' },
	{ name: 'Heading 2',		element: 'h2' },
	{ name: 'Heading 3',		element: 'h3' },
	{ name: 'Heading 4',		element: 'h4' },
	{ name: 'Heading 5',		element: 'h5' },
	{ name: 'Heading 6',		element: 'h6' },
	{ name: 'Preformatted Text',element: 'pre' },
	{ name: 'Address',			element: 'address' },
	*/

	{
		name: 'Underlined with dots',
		element: 'div',
		styles: {
			padding: '2px',
      'border-bottom': '2px dotted #ccc',
      'margin-top': '10px',
      'padding-bottom': '30px'
	                 }
        },
	{
		name: 'Nice look',
		element: 'div',
                attributes: { 'class': 'nice-class'}
	},

	/* Inline Styles */

	// These are core styles available as toolbar buttons. You may opt enabling
	// some of them in the Styles combo, removing them from the toolbar.
	// (This requires the "stylescombo" plugin)
	/*
	{ name: 'Strong',			element: 'strong', overrides: 'b' },
	{ name: 'Emphasis',			element: 'em'	, overrides: 'i' },
	{ name: 'Underline',		element: 'u' },
	{ name: 'Strikethrough',	element: 'strike' },
	{ name: 'Subscript',		element: 'sub' },
	{ name: 'Superscript',		element: 'sup' },
	*/

	/* Object Styles */

	{
		name: 'Styled image (left)',
		element: 'img',
		attributes: { 'class': 'left' }
	},

	{
		name: 'Styled image (right)',
		element: 'img',
		attributes: { 'class': 'right' }
	},

	{
		name: 'Compact table',
		element: 'table',
		attributes: {
			cellpadding: '5',
			cellspacing: '0',
			border: '1',
			bordercolor: '#ccc'
		},
		styles: {
			'border-collapse': 'collapse'
		}
	},

	{ name: 'Borderless Table',		element: 'table',	styles: { 'border-style': 'hidden', 'background-color': '#E6E6FA' } },
	{ name: 'Square Bulleted List',	element: 'ul',		styles: { 'list-style-type': 'square' } }
]);
