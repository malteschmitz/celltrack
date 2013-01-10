function base64decode2(data) {
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

function base64decode1(data) {
  var b64 = 
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

  var h = 0;                  // value of the current "hexet"
  var i = 0;                  // position of the current "hexet"
  var j = 0;                  // counter for bits 
  var c = new Array(length);  // cellmask array
  
  do {
    // Get binary digit representation of the current "hexet".
    h = b64.indexOf(data.charAt(i++)).toString(2);
    
    // A "=" marks a fully padded 0-Byte at the end. So, ignore these.
    if (h != "1000000") {
      
      // Write padding zeros to the cellmask array, if necessary.
      for (var iDigit = h.length; iDigit < 6; iDigit++) {
        c[j] = 0;
        j++;
      }
      
      // Copy binary digits to the cellmask array.
      for (var iDigit = 0; iDigit < h.length; iDigit++) {
        c[j] = h[iDigit];
        j++;
      }
    }
  } while (i < data.length);
  
  return c;
}