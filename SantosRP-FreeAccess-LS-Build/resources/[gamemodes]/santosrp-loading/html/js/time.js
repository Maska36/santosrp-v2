// JavaScript Document


// screen loader
$(window).load(function() {
	$('body').css('overflow', 'hidden');
	$('.screen-loader').fadeOut('slow');
});

// preload
$(document).ready(function() {
	$('#preload').css({display: 'block'});
});

// preload function
$(window).load(preLoader);
function preLoader() {
	setTimeout(function() {
		$('#preload').delay(250).fadeOut(1000);
		$('.borders').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('#intro-wrapper').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('.social-icons-wrapper').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('.menu').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('.menu-mobile').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('#countdown').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('.launch-time').delay(1000).css({display: 'none'}).fadeIn(2500);
		$('#subscribe-wrapper').delay(1000).css({display: 'none'}).fadeIn(2500);
	});
};


// preload function mobile
jQuery(document).ready(function($) {  
    var $is_mobile = false;
    if( $('.preload-content').css('display') == 'none' ) {
        $is_mobile = true;      
    }
});


// fire home
	$("#fire-home").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$(".upper-page").fadeIn("slow");      
			$(".current").removeClass("current");
			$(".upper-page").addClass("current");
		});
	});
	
	
// fire about
	$("#fire-about").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#about").fadeIn("slow");
			$(".current").removeClass("current");
			$("#about").addClass("current");
		});
	});
	
	
// fire services
	$("#fire-services").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#services").fadeIn("slow");
			$(".current").removeClass("current");
			$("#services").addClass("current");
		});
	});
	
	
// fire contact
	$("#fire-contact").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#contact").fadeIn("slow");
			$(".current").removeClass("current");
			$("#contact").addClass("current");
		});
	});
	
	
// fire home mobile
	$("#fire-home-mobile").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$(".upper-page").fadeIn("slow");      
			$(".current").removeClass("current");
			$(".upper-page").addClass("current");
		});
	});
	
	
// fire about mobile
	$("#fire-about-mobile").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#about").fadeIn("slow");
			$(".current").removeClass("current");
			$("#about").addClass("current");
		});
	});
	
	
// fire services mobile
	$("#fire-services-mobile").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#services").fadeIn("slow");
			$(".current").removeClass("current");
			$("#services").addClass("current");
		});
	});
	
	
// fire contact mobile
	$("#fire-contact-mobile").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#contact").fadeIn("slow");
			$(".current").removeClass("current");
			$("#contact").addClass("current");
		});
	});
	
	
// fire launch time
	$("#fire-launch-time").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$("#launch-time").fadeIn("slow");
			$(".current").removeClass("current");
			$("#launch-time").addClass("current");
		});
	});
	

// fire closer
	$("#fire-about-closer, #fire-services-closer, #fire-contact-closer, #fire-launch-time-closer").click(function(e) {
		e.preventDefault();
		$(".current").fadeOut("slow", function() {
			$(".upper-page").fadeIn("slow");      
			$(".current").removeClass("current");
			$(".upper-page").addClass("current");
		});
	});
	
	
// pulsate effect
$(function(){
    // self-executing recursive animation
    (function pulse(){
		$('.launch-time-clock').delay(1000).fadeOut('slow').delay(50).fadeIn('slow', pulse);
    })();
});


// menu active state
$('a.menu-state').click(function() {
    $('a.menu-state').removeClass("active");
    $(this).addClass("active");
});


// niceScroll
$(document).ready(function () {
    $("body").niceScroll({
	   cursorcolor: "#fff",				 
	   cursorwidth: "5px",				 
	   cursorborder: "1px solid #fff",
	   cursorborderradius: "0px",
	   zindex: "9999",
	   scrollspeed: "60",
	   mousescrollstep: "40",
	   // background: "rgba(255, 255, 255, 0.1)"
    });
});


// niceScroll || scrollbars resize
$("body").getNiceScroll().resize();

// mobile-detect
	var isMobile = {
        Android: function() {
            return navigator.userAgent.match(/Android/i);
        },
        BlackBerry: function() {
            return navigator.userAgent.match(/BlackBerry/i);
        },
        iOS: function() {
            return navigator.userAgent.match(/iPhone|iPad|iPod/i);
        },
        Opera: function() {
            return navigator.userAgent.match(/Opera Mini/i);
        },
        Windows: function() {
            return navigator.userAgent.match(/IEMobile/i);
        },
        any: function() {
            return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
        }
    };