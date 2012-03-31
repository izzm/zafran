// JavaScript Document

//menu
var timeout    = 0;
var closetimer = 0;
var ddmenuitem = 0;
 
function jsddm_open() {
    jsddm_canceltimer();
    jsddm_close();
    ddmenuitem = $(this).find('div').css('visibility', 'visible');
}
 
function jsddm_close() {
    if (ddmenuitem) ddmenuitem.css('visibility', 'hidden');
}
 
function jsddm_timer() {
    closetimer = window.setTimeout(jsddm_close, timeout);
}
 
function jsddm_canceltimer() {
    if (closetimer) {
        window.clearTimeout(closetimer);
        closetimer = null;
    }
}

function show_popup($button, data) {
  var popID = $button.attr('rel'); //Get Popup Name
	var popURL = $button.attr('href'); //Get Popup href to define size
			
	//Pull Query & Variables from href URL
	var query= popURL.split('?');
	var dim= query[1].split('&');
	var popWidth = dim[0].split('=')[1]; //Gets the first query string value

	//Fade in the Popup and add close button
	$('#' + popID).fadeIn().css({ 'width': Number( popWidth ) }).prepend('<a href="#" class="close removable"><img src="/assets/site/close_pop.png" class="btn_close" title="Close Window" alt="Close" /></a>');
	
	//Define margin for center alignment (vertical + horizontal) - we add 80 to the height/width to accomodate for the padding + border width defined in the css
	var popMargTop = ($('#' + popID).height() + 80) / 2;
	var popMargLeft = ($('#' + popID).width() + 80) / 2;
	
	//Apply Margin to Popup
	$('#' + popID).css({ 
		'margin-top' : -popMargTop,
		'margin-left' : -popMargLeft
	});
	
	//Fade in Background
	$('body').append('<div id="fade"></div>'); //Add the fade layer to bottom of the body tag.
	$('#fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn(); //Fade in the fade layer
}

function update_cart (data) {
  $("#cart_container").html(data.cart_html);
}
 
$(document).ready(function() {
    $('#jsddm > li').bind('mouseover', jsddm_open);
    $('#jsddm > li').bind('mouseout',  jsddm_timer);
});
document.onclick = jsddm_close;

$(document).ready(function(){
  
  $(".weight_select").change(function(){
    var c_id = $(this).attr("rel");
    var g_id = $(this).val();

    $("#category_" + c_id + "_price").html($("#good_" + g_id + "_price").html());
  }).trigger("change");
  
  $(".small_category_image_link").click(function() {
    $("#main_category_image").attr("src", $(this).attr("rel")).parent().attr("href", $(this).attr("href")).lightBox();
    
    return false;
  });
  $("#main_category_image").parent().lightBox();
  
  $(".cart_add_good").click(function() {    
    var $this = $(this);
    var form_id = $this.attr('data-form-id');
    
    $("#submit_form_"+form_id).ajaxSubmit({
      dateType: "json",
      success: function(data) {
        show_popup($this);        
        update_cart(data);
      }
    });
    
    return false;
  });
	
	//Close Popups and Fade Layer
  $('a.close, #fade').live('click', function() { //When clicking on the close or fade layer...
    var $this = $(this);
    $('.popup_block, #fade').fadeOut(function() {
      //if(!$this.hasClass('noclose')) {
			  $('#fade, .removable').remove();
		  //}
	  }); //fade them both out
		
		return false;
	});

	
});