$(function () {
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue") {
			setValue(event.data.key, event.data.value);
		} else if (event.data.action == "updateStatus") {
			updateStatus(event.data.status);
		} else if (event.data.action == "toggle") {
			if (event.data.show) {
				$('#ui').show();
			} else {
				$('#ui').hide();
			}
		}
	});
});

function setValue(key, value) {
	$('#' + key + ' span').html(value);
}

function updateStatus(status) {
	var hunger = status[0];
	var thirst = status[1];
	var drunk = status[2];
	$('#hunger .bg').css('height', hunger.percent + '%');
	$('#water .bg').css('height', thirst.percent + '%');
	$('#drunk .bg').css('height', drunk.percent + '%');
}