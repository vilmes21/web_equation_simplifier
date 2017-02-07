$(document).ready(function() {

  $('#eq-mode-tab').trigger('click');

  var alertEmpty = function(userInput){
    if (userInput.replace(/\s/g, '') === ''){
      alert('Please enter something before calculating.');
      return true;
    }
  };

  $('#simplify').click(function(e) {
    e.preventDefault();
    var inputField = $('#eq_input');
    var userInput = inputField.val();

    if (alertEmpty(userInput)) {return}

    $.post("/result", {eq_input: userInput},
      function(final_res) {
        $('#result-section').append(`<h2>Simplification Result:</h2> Input: ${userInput} <br /> Output: ${final_res}`);
        inputField.val('');
    });
  });
  // closing `simplify.click`

  $('#convert').click(function() {
    var inputField = $('#file_input');
    var userInput = inputField.val();

    if (alertEmpty(userInput)) {return}

    $.post("/file_result", {file_path: userInput},
      function(final_res) {
        $('#result-section').append(`<h2>File Conversion Result:</h2> ${final_res}`);
        inputField.val('');
    });
  });
  // closing `conver.click`

  $('#clear-board').click(function(){
    $('#result-section').html('');
  });

});
// closing `document.ready`
