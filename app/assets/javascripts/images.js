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

function getNearestCell(event, canvasCellmask, ctxCellmask) {
  // Get x and y coordinates of mouse pointer on the canvas.
  // Supported browsers (tested): Firefox, Opera, Chrome
  // Not supported browsers (tested): Internet Explorer
  var x = 0;
  var y = 0;
  if (event.layerX == undefined && event.layerY == undefined) {	// Opera
    x = event.offsetX + 1;
	y = event.offsetY + 1;
  } else {														// all other
	x = event.layerX + 1;
	y = event.layerY + 1;
  }
  
  // Find nearest cell to that coordinates via minimum of Euclidean distances.
  var minDistance = Infinity;
  var idx = 0;
  $.each(cells, function(index, cell) {
    // Calculate Euclidean distance.	      
    var distance = Math.sqrt(Math.pow(x - cell.center_x, 2) + 
      Math.pow(y - cell.center_y, 2));

    // Update minimum.
	if (distance < minDistance) {
	  minDistance = distance;
	  idx = index;
	}
  });
  	
  if (idx != lastChosenCell) {
    // Re-render last chosen cell in standard color.
    renderCell(cells[lastChosenCell], ctxCellmask, false);  

    // Render new cell in special color.
    renderCell(cells[idx], ctxCellmask, true);  
  }

  // Update last chosen cell.
  lastChosenCell = idx;
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
    
      // Add event listener on canvas element.
      canvasCellmask.addEventListener("mousedown", function(event){
    	getNearestCell(event, canvasCellmask, ctxCellmask)}, false);
    }
  }
});