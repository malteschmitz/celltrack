$(function () {
  var progress = $('#progress');
  var progress_bar = $('#progress_bar div');
  if (progress.length > 0 && typeof experiment_id !== 'undefined') {
    var update_progress_bar = function () {
      $.ajax({
        dataType: 'json',
        url: '/experiments/' + experiment_id,
        success: function(data) {
          if (data.import_done) {
            location.reload();
          } else {
            progress.html(data.import_progress);
            progress_bar.css('width', data.import_progress_percent + '%');
            window.setTimeout(update_progress_bar, 1000);
          }
        }
      });
    };
    window.setTimeout(update_progress_bar, 1000);
  }
});