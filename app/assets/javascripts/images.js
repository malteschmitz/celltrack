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

function renderCell(cell, ctxCellmask, isMarked) {
  // Decode cellmask.
  var mask = base64decode(cell.mask);
  
  // Create ImageData object of proper size.
  var image = ctxCellmask.getImageData(cell.left, cell.top, cell.width, 
    cell.height);

  // Update color values. If cell is marked, render blue else render red.
  for (var k = 0; k < cell.width * cell.height; k++) {
    if (mask[k] > 0) {
      if (isMarked) {
        image.data[4*k]   = 0;
        image.data[4*k+2] = 96;
      } else {
        image.data[4*k]   = 96;
        image.data[4*k+2] = 0;
      }
      image.data[4*k+1] = 0;
      image.data[4*k+3] = 128;
    }
  }
  
  // Draw cellmask on cellmask canvas.
  ctxCellmask.putImageData(image, cell.left, cell.top);
}

// Calculate Euclidean distance.
function distance(x1,y1,x2,y2) {
  return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
}

// Find nearest cell to that coordinates via minimum of Euclidean distances.
function getNearestCell(x, y) {
  var min = Infinity;
  var result;
  $.each(cells, function(index, cell) {              
    var d = distance(x, y, cell.center_x, cell.center_y);
    // Update minimum.
    if (d < min) {
      min = d;
      result = cell;
    }
  });
  return result;
}

$(window).load(function () {
  if (cells) {
    // Initialize picture and canvas element.
    var picture = $('#picture');
    if (picture.length > 0) {
      var canvas = $('<canvas>',{'id':'cellmask'});
      picture.after(canvas);
      var p = picture.position();
      canvas.css({
        position: 'absolute',
        top: p.top + 'px',
        left: p.left + 'px',
        width: picture.width() + 'px',
        height: picture.height() + 'px'
      });
      var canvasCellmask = canvas.get(0);
      canvasCellmask.width = picture.width();
      canvasCellmask.height = picture.height();
      var ctxCellmask = canvasCellmask.getContext('2d');
      ctxCellmask.clearRect(0, 0, picture.width(), picture.height());
    
      // Render all cell masks.
      $.each(cells, function(index, cell) { 
        renderCell(cell, ctxCellmask, false);
      });
      
      var currentCell;
      
      // Add event listener on canvas element
      canvas.click(function(e){
        var offset = canvas.offset();
        var x = e.pageX - offset.left;
        var y = e.pageY - offset.top;
        var cell = getNearestCell(x,y);
        if (currentCell) {
          // Re-render last chosen cell in standard color.
          renderCell(currentCell, ctxCellmask, false);
        }
        if (distance(x, y, cell.center_x, cell.center_y) < 25) {    
          // Render new cell in special color.
          renderCell(cell, ctxCellmask, true);  
          // Update last chosen cell.
          currentCell = cell;
        }
      });
    }
  }
});