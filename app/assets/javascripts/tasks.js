function loadTasksIndex(filter){
  $.get('/tasks.json?filter='+filter, function(data){
    $('#tasks-list').text(JSON.stringify(data));
  });
}
