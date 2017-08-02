function showProject(id){
  $('#project').hide();
  $('#project-loading').show();
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
    $('#next-project').data('id', data.next_id);
    $('#next-project')[data.next_id? 'show' : 'hide']();//hide if next_id is null
    $('#prev-project').data('id', data.prev_id);
    $('#prev-project')[data.prev_id? 'show' : 'hide']();//hide if prev_id is null
    $('#new-task').data('project-id', id);
    $('#project-loading').hide();
    $('#project').show();
  });
}

function addTaskToProjectFromFormData(projectId, formData){
  $.post('/projects/'+projectId + '/tasks', formData, function(data){
    $('#project-tasks').append(new Task(data, projectId).buildHTML());
  });
}
