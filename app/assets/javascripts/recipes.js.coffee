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

  $("body").on "click", ".open_modal",(event) -> 
    $.ajax
      url: "https://api.instagram.com/v1/users/self/media/recent?access_token="+gon.current_user.instatoken
      dataType: "jsonp"
      success: (result, textStatus, jqXHR) ->
        i = 0
        $("#modal-body_"+event.target.id).html '<div id="modal_'+event.target.id+'"> </div>'
        while i < result.data.length
          $("#modal_"+event.target.id).before '<div class="col-md-4"><div class="thumbnail" ><img  style="width:150px;height:150px" src="'+result.data[i].images.standard_resolution.url+'"></div></div>'
          i++


  $("#add_step").on "click", ->
    $('#add_step').before '<div  name=\'S[]\'><legend>Step: <span class="number"> ' + stepN + '\ </span> <div class="btn btn-default open_modal" data-toggle="modal" data-target="#Modal' + stepN + '" id ="' + stepN + '" >Add Instagram content</div>  <div class="modal fade" id="Modal' + stepN + '" role="dialog">
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
  </div></legend><input required type=\'text\' class=\'step\' placeholder=\'Title for step ' + stepN + '\' name= \'SN[]\' id= \'SN' + stepN + '\'/><textarea required type=\'text\' class=\'step\' placeholder=\'Describe step ' + stepN + '\' name= \'S[]\' id= \'S' + stepN + '\'/></div>'
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
    $('#sel-ingredients').append '<span id="span-sel-ing">' + ($(event.target).data 'name') + '  </span>'
    $('#ingredients-input').before '<input type="hidden" name="IN[]" id="IN' + IngredientN + '" value="' + IngID + '">'
    $(event.target).remove()
    $('#ingredients-input').val ''
    IngredientN++

  $("#ingredients-input").keyup ->
    tempValue = $(this).val()
    $.ajax
      url: '/recipe/ingredients'
      type: 'post'
      data: ingredients: tempValue
      success: (response) ->
        ing=$(response).find('#div-ing').html()
        $('#search-result').html ing



  return


# ---
# generated by js2coffee 2.1.0
