function showProject(id){
  $.get('/projects/'+id + '.json', function(data){
    $('#project-messages').html('');
    $('#project-tasks').html('');
    $('#project-name').text(data.name);
    $('#project-description').text(data.description);
    data.messages.forEach(function(msg){
      $('#project-messages').append('<div class="alert alert-'+msg.message_type+'">'+msg.content+'</div>');
    });
    data.tasks.forEach(function(task){
      $('#project-tasks').append(new Task(task, id).buildHTML());
    });
  });
}
