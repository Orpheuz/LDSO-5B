# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

stepN = 1
categoryN = 1
IngredientN = 1

$(document).ready ->

  $('[rel=tooltip]').tooltip placement: 'bottom'

  $("body").on "click", ".modal-image",(event) ->
    $("#SM_"+event.target.id).attr 'value', event.target.src
    $('#Modal'+event.target.id).modal 'hide'

  $("body").on "click", ".open_modal",(event) ->
    $.ajax
      url: "https://api.instagram.com/v1/users/self/media/recent?access_token="+gon.current_user.instatoken
      dataType: "jsonp"
      success: (result, textStatus, jqXHR) ->
        i = 0
        $("#modal-body_"+event.target.id).html '<div id="modal_'+event.target.id+'"> </div>'
        while i < result.data.length
          $("#modal_"+event.target.id).before '<div class="col-md-4"><div class="thumbnail" ><img id="'+event.target.id+'"class="modal-image" style="width:150px;height:150px" src="'+result.data[i].images.standard_resolution.url+'"></div></div>'
          i++


  $("#add_step").on "click", ->
    $('#add_step').before '<div  name=\'S[]\'><legend>Step: <span class="number"> ' + stepN + '\ </span>
        <div class="btn btn-default open_modal" data-toggle="modal" data-target="#Modal' + stepN + '" id ="' + stepN + '" >Add Instagram content</div>
    <div class="modal fade" id="Modal' + stepN + '" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">Select a photo</h4>
        </div>
        <div class="modal-body">
          <div class="row" id="modal-body_'+stepN+'">
            <div id="modal_'+stepN+'"> </div>
          </div>
        </div>
      </div>
    </div>
  </div></legend>

        <input type="text" class="step" placeholder="Image URL" name="SM[]"" id= "SM_' + stepN + '"/>' +
        '<input required type=\'text\' class=\'step\' placeholder=\'Title for step ' + stepN + '\' name= \'SN[]\' id= \'SN' + stepN + '\'/>' +
        '<textarea required type=\'text\' class=\'step\' placeholder=\'Describe step ' + stepN + '\' name= \'S[]\' id= \'S' + stepN + '\'/></div>' +
        '<label for="inputsm">Time (minutes):</label>' +
        '<input type="range" value="30" name="points" min="0" max="2000" id="inputrng-' + stepN + '" class="change-duration"><br>' +
        '<input class="recipe-form recipe_duration" value="30" min="0" max="2000" id="inputsm-' + stepN + '" name="T[]" type="number">'

    stepN++

  $("#add_category").on "click", ->
    i = 0
    while i < gon.categories.length
      if document.getElementById('cat-'+i) == null
        $("#add_category").before '<button type="button" class="btn btn-primary btn-xs cat" id="cat-'+i+'" value="' + gon.categories[i].name + '">'+gon.categories[i].name+'</button>'
      i++

  $("body").on "click", ".cat",(event) ->
    $('#' + event.target.id).toggleClass 'cat chosen-cat'
    realID = parseInt(event.target.id.slice(4)) + 1
    catValue=$('#' + event.target.id).attr 'value'
    $('#' + event.target.id).before  '<input type="hidden" name="CN[]" id="CN' + categoryN + '" value="' + realID + '">'
    categoryN++
    $('#' + event.target.id).disabled = true
    $(".cat").remove()
    return
  $("#create").on "click", ->
    size=$('.step').length
    if size < 1
      alert('Please write a step')
      return false
  $("#book-btn").on "click", ->
    $("#bookmark_ico").first().addClass('fa-spinner fa-pulse').removeClass('fa-bookmark');

  $("body").on "click", ".SIResult",(event) ->
    IngID = event.target.id.slice(4)
    IngQuant = $(".SIResult-quantity").val()
    console.log IngQuant
    $('#sel-ingredients').append '<span id="span-sel-ing">' + ($(event.target).data 'name') + '  </span>'
    $('#ingredients-input').before '<input type="hidden" name="IN[]" id="IN' + IngredientN + '" value="' + IngID + '">'
    $('#ingredients-input').before '<input type="hidden" name="quantity[]" value="' + IngQuant + '">'
    $(event.target).remove()
    $(".SIResult-quantity").remove()
    $('#ingredients-input').val ''
    IngredientN++

  $("#ingredients-input").keyup ->
    tempValue = $(this).val()
    if tempValue != ""
      $.ajax
        url: '/recipe/ingredients'
        type: 'post'
        data: ingredients: tempValue
        success: (response) ->
          ing=$(response).find('#div-ing').html()
          $('#search-result').html ing

  $(( ".remove_ingredient" )).on "click", (e) ->
    realID=$(".remove_ingredient").index(this)+1
    $("#ingredient"+realID).remove()

  $('body').on 'change', '.change-duration',(event) ->
    arr = event.target.id.split("-")
    $('#inputsm-'+ arr[1]).val $(this).val()


  $('body').on 'change' , '.recipe_duration',(event) ->
    arr = event.target.id.split("-")
    $('#inputrng-'+ arr[1]).val $(this).val()

  $("#edit_recipe_name").on "click", ->
    $("#current_recipe_name").before( "<legend id='recipe_name_label'> Recipe name:</legend>" +
        "<input required type=\'text\' name= \'new_name\' id= \'input_new_recipe_name\' value=\'"+ $("#name").text() + "\' />" +
        "<button type='button' id='button_change_name_done' class='btn btn-default'><i class='fa fa-check-square'></i></button>" )
    $("#current_recipe_name").remove()
    $("#edit_recipe_name").remove()
    $("#button_change_name_done").on "click", ->
      new_name= $("#input_new_recipe_name").val()
      $("#input_new_recipe_name").before('<input type="hidden" name="new_name" value="' + new_name + '">' +
          '<legend>
          <p>
            <div id="current_recipe_name"> ' + new_name + ' </div>
            <button type="button" id="edit_recipe_name" class="btn btn-default">\
              <i class="fa fa-pencil-square-o"></i>\
            </button>
        </p>
        </legend>' )
      $("#input_new_recipe_name").remove()
      $("#recipe_name_label").remove()
      $("#button_change_name_done").remove()


  $("#edit_recipe_description").on "click", ->
    $("#current_recipe_description").before( "<legend id='recipe_name_description'> Recipe description:</legend>" +
        "<textarea rows='12' cols='60' name= \'new_description\' id= \'input_new_recipe_description\'>"+ $("#description").text() + "</textarea>" +
        "<button type='button' id='button_change_description_done' class='btn btn-default'><i class='fa fa-check-square'></i></button>" )
    $("#current_recipe_description").remove()
    $("#edit_recipe_description").remove()
    $("#button_change_description_done").on "click", ->
      new_description= $("#input_new_recipe_description").val()
      $("#input_new_recipe_description").before('<input type="hidden" name="new_description" value="' + new_description + '">' +
          '<legend>
          <p>
            <div id="current_recipe_description"> ' + new_description + ' </div>
            <button type="button" id="edit_recipe_description" class="btn btn-default">\
              <i class="fa fa-pencil-square-o"></i>\
            </button>
        </p>
        </legend>' )
      $("#input_new_recipe_description").remove()
      $("#recipe_description_label").remove()
      $("#button_change_description_done").remove()


return


# ---
# generated by js2coffee 2.1.0
