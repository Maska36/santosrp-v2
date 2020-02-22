$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) { // Escape key
			$.post('http://esx_identity/escape', JSON.stringify({}));
		}
	};
});

function sendAccountInfo(state)
{
	$.post('http://esx_identity/container', JSON.stringify({
		firstname: $("#firstname").val(),
		lastname: $("#lastname").val(),
		dateofbirth: $("#dateofbirth").val(),
		sex: $("input[type='radio'][name='sex']:checked").val(),
		height: $("#height").val()
	}));
}
