function base64decode(data) {
  var b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  // b64 does not contain = at the end because this stands for the value
  // 64 which has to be ignored. Linebreaks and any other character not listed
  // in the above list have to be ignored, too.
  var result = [];
  var pos = 0;
  data.split('').forEach(function(c) {
    var value = b64.indexOf(c);
    var i = 0;
    if (value >= 0) {
      for (i = 5; i >= 0; i --) {
        result[pos++] = ((1 << i) & value) >> i;
      }
    }
  });
  return result;
}

function displayCells(cells) {
  var picture = $('#picture');
  if (picture.length > 0) {
    var canvas = $('<canvas>');
    picture.after(canvas);
    var p = picture.position();
    canvas.css({
      position: 'absolute',
      top: p.top + 'px',
      left: p.left + 'px',
      width: picture.width() + 'px',
      height: picture.height() + 'px'
    });
    
    var c = canvas.get(0);
    c.width = picture.width();
    c.height = picture.height();
    var context = c.getContext('2d');
    context.clearRect(0, 0, picture.width(), picture.height());
    
    $.each(cells, function(index, cell) {
      var mask = base64decode(cell.mask);

      // Create ImageData object of proper size).
      var image = context.createImageData(cell.width, cell.height);
      // TODO Implement color management.
      for (var k = 0; k < cell.width * cell.height; k++) {
        if (mask[k] > 0) {
          image.data[4*k] = 96;
          image.data[4*k+1] = 0;
          image.data[4*k+2] = 0;
          image.data[4*k+3] = 128;
        }
      }

      // Draw cellmask on cellmask canvas.
      context.putImageData(image, cell.left, cell.top);
    });
  }
}

$(window).load(function () {
  if (cells) {
    displayCells(cells);
  }
});