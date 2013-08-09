//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file:
// http://jashkenas.github.com/coffee-script/
  <script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>

function appendNewTodo(id, name, atype)
{

    var newtodo = '<li style="list-style-type: none;"> \
    <span class="bullet"><a href="" class="checkoff-link" id="' + id + '" title="Check off' + atype + '"><i class="icon-check"></i></a></span> \
    <a href="" class="editable" title="Edit' + atype + '" data-id="' + id + '">' + name + '</a> \
    <span class="add-on hidden"><i class="icon-edit"></i></span> \
    </li>'

    if (atype == "todo")
        $("#todo").append(newtodo);
    else
    if (atype == "reminder")
        $("#reminder").append(newtodo);

}