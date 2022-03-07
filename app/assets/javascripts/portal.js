/* Your portal javascript code goes here*/

$(document).ready( function() {
  /************************************************************************
   * Click on application menu action
   ************************************************************************/
  $('.app-menu .dc-link').bind('click', function(e) {
    $(this).siblings().removeClass('active');
    $(this).addClass('active');
  });

  /***  dropdown-menu
  /************************************************************************
   * Click on dropdown top level item.
   ************************************************************************/
  $('.dropdown-menu .sub-menu div').bind('click', function(e) {
    $(this).siblings("ul").first().slideToggle( "fast" );
    $(this).parent().toggleClass( "open" );
    e.preventDefault();
  });

  /************************************************************************
   * Click on dropdown menu item. Deactivate old and set active class to
   * currently selected menu item.
   ************************************************************************/
  $('.dropdown-menu .menu-item').bind('click', function(e) {
    $('.dropdown-menu .menu-item.active').toggleClass( "active" );
    $(this).toggleClass( "active" );
  });

});
