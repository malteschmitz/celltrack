var base64decode = (function() {
  var b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  // b64 does not contain = at the end because this stands for the value
  // 64 which has to be ignored. Linebreaks and any other character not listed
  // in the above list have to be ignored, too.
  var i;
  var t = {};
  for (i = 0; i < b64.length; i++) {
    var result = [];
    var pos = 0;
    var k;
    for (k = 5; k >= 0; k --) {
      result[pos++] = ((1 << k) & i) >> k;
    }
    t[b64.charAt(i)] = result;
  }
  return function (data) {
    var result = [];
    var pos = 0;
    var i;
    for (i = 0; i < data.length; i++) {
      var value = t[data.charAt(i)];
      var j;
      if (value) {
        for (j = 0; j < 6; j++) {
          result[pos++] = value[j];
        }
      }
    }
    return result
  }
}());

function renderAllCells(canvas, image) {
  var canvasCellmask = canvas.get(0);
  canvasCellmask.width = image.width;
  canvasCellmask.height = image.height;
  var ctxCellmask = canvasCellmask.getContext('2d');
  ctxCellmask.clearRect(0, 0, image.width, image.height);

  // Initialize ImageData object.	
  var img = ctxCellmask.createImageData(image.width, image.height);  
	
  $.each(image.cells, function(index, cell) {
	// Decode cellmask.
    var mask = base64decode(cell.mask);
    
    // Update color values.
    for (var row = 0; row < cell.height; row++) {
      for (var col = 0; col < cell.width; col++) {
    	var k = row * cell.width + col;
        if (mask[k] > 0) {
          var idx = 4 * ((cell.top + row) * canvasCellmask.width + 
        	cell.left + col);
          img.data[idx]   = 96;
          img.data[idx+1] = 0;
          img.data[idx+2] = 0;
          img.data[idx+3] = 128;
        }
      }
    }   
  });
  
  // Draw cellmask on cellmask canvas.
  ctxCellmask.putImageData(img, 0, 0);
}

function renderSingleCell(canvas, cell, isMarked) {
  var ctxCellmask = canvas.get(0).getContext('2d');

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
function distance(x1, y1, x2, y2) {
  return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
}

// Find nearest cell to that coordinates via minimum of Euclidean distances.
function getNearestCell(x, y, cells) {
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

function adjustCanvasPosition(picture, image, canvas) {
  var p = picture.position();
  canvas.css({
    position: 'absolute',
    top: p.top + 'px',
    left: p.left + 'px',
    width: image.width + 'px',
    height: image.height + 'px'
  });
}

$(function () {
  if (typeof image !== 'undefined') {
    // Initialize picture and canvas element.
    var picture = $('#picture');
    if (picture.length > 0) {
      // create canvas
      var canvas = $('<canvas>',{'id':'cellmask'});
      picture.after(canvas);
      
      adjustCanvasPosition(picture, image, canvas);
      $(window).load(function() {
        adjustCanvasPosition(picture, image, canvas);
      });
    
      // Render all cell masks.
      renderAllCells(canvas, image);
      
      var currentCell;
      
      // Add event listener on canvas element
      canvas.click(function(e){
        var offset = canvas.offset();
        var x = e.pageX - offset.left;
        var y = e.pageY - offset.top;
        var cell = getNearestCell(x, y, image.cells);
        if (currentCell) {
          // Re-render last chosen cell in standard color.
          renderSingleCell(canvas, currentCell, false);
        }
        if (distance(x, y, cell.center_x, cell.center_y) < 25) {    
          // Render new cell in special color.
          renderSingleCell(canvas, cell, true);  
          // Update last chosen cell.
          currentCell = cell;
        }
      });
      
      var show_cellmasks = $('#show_cellmasks');
      show_cellmasks.click(function () {
        if (show_cellmasks.is(':checked')) {
          canvas.show();
        } else {
          canvas.hide();
        }
      });
      
      var picture_selector = $('#picture_id');
      picture_selector.change(function () {
        picture.attr('src', picture_selector.val());
      });
      
      var image_selector = $('#image_id');
      var prev_image_button = $('#prev_image_id');
      var next_image_button = $('#next_image_id');
      var play_button = $('#play');
      image_selector.change(function () {
        // request new image
        $.ajax({
          dataType: 'json',
          url: '/images/' + image_selector.val(),
          success: function(data) {
            image = data;
            renderAllCells(canvas, image);
            $('#image_title_ord').html(image.ord);
            // update picture
            var old_picture_ord = picture_selector.prop('selectedIndex');
            picture_selector.html('');
            $.each(image.pictures, function(index, p) {
              var value = '/experiments/' + p.filename;
              var display = p.filename.split('/')[0];
              picture_selector.append('<option value="' + value + '">' + display + '</option>');
            });
            picture_selector.prop('selectedIndex', old_picture_ord);
            picture_selector.change();
          }
        });
        // enable / disable buttons
        var index = image_selector.prop('selectedIndex');
        if (index == 0) {
          prev_image_button.attr('disabled', 'disabled');
        } else {
          prev_image_button.removeAttr('disabled');
        }
        if (+index === +image_selector.prop('length') - 1) {
          next_image_button.add(play_button).attr('disabled', 'disabled');
        } else {
          next_image_button.add(play_button).removeAttr('disabled');
        }
      });
      
      prev_image_button.click(function() {
        image_selector.prop('selectedIndex', image_selector.prop('selectedIndex') - 1);
        image_selector.change();
        return false
      });
      
      next_image_button.click(function() {
        image_selector.prop('selectedIndex', image_selector.prop('selectedIndex') + 1);
        image_selector.change();
        return false
      });
      
      var play_speed_selector = $('#play_speed');
      var playing = false;
      var click_next = function () {
        if (!next_image_button.attr('disabled')) {
          next_image_button.click();
        }
        if (!next_image_button.attr('disabled')) {
          playing = window.setTimeout(click_next, +play_speed_selector.val());
        } else {
          play_button.html('Play');
        }
      };
      play_button.click(function () {
        if (playing) {
          window.clearTimeout(playing);
          playing = false;
          play_button.html('Play');
        } else {
          play_button.html('Stop');
          click_next();
        }
        return false
      });
    }
  }
});