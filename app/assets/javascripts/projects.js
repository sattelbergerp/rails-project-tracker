function showProject(id){
  $.get('/projects/'+id + '.json', function(data){
    $('#project-name').text(data.name);
    $('#project-description').text(data.description);
    $('#project-messages').html('');
    data.messages.forEach(function(msg){
      $('#project-messages').append('<div class="alert alert-'+msg.message_type+'">'+msg.content+'</div>');
    });
  });
}
