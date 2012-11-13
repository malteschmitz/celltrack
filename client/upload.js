Template.upload.events({
  'click #upload': function(event) {
    var files = $('#file')[0].files;
    
    if (files.length > 0) {
      // use native HTML5 FileReader object
      var fileReader = new FileReader();
      
      fileReader.onload = function(event) {
        var content = event.target.result;
        Meteor.call('upload', content);
      };
      
      fileReader.readAsBinaryString(files[0]);
    } else {
      alert('no file selected');
    }
  }
});
