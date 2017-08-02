function showProject(id){
  $.get('/projects/'+id + '.json', function(data){
    $('#project-name').text(data.name);
    $('#project-description').text(data.description);
  });
}
