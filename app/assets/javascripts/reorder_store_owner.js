$.validator.addMethod("regex", function(value, element, regexp) {
        return this.optional(element) || regexp.test(value);
    }, "");
$(document).ready(function(){   
  $('#business_name').focus(); 
  jQuery.validator.addMethod("phoneNumber", function(value, element, params) {   
    return (/^(([0-9]+[0-9\-]*[0-9])|([0-9]+))$/.test(value) && (value.replace(/-/g, "").length==10));
  }, jQuery.validator.format(I18n.t('msg.phone')));
  $("#update_credit_card_store_owner").validate({
    rules:{
      "state": {
        required: true,
        maxlength: 256
      },
      "city": {
        required: true,
        maxlength: 256
      },
      "address": {
        required: true,
        maxlength: 256
      },
      "postal_code": {
        required: true,
        maxlength: 7,
        minlength: 7,
        number:true
      },
      "country": {
        required: true
      },
      "phone_number": {
        required: true,
        //maxlength: 20,
        //minlength: 10,
        //number:true,
        phoneNumber: true
      },
      "card_type": {
        required: true
      },
      "card_number": {
        required: true,
        maxlength: 16,
        minlength: 15,
        number:true
      },
      "month": {
        required: true
      },
      "year": {
        required: true
      },
      "cvv": {
        required: true,
        maxlength: 4,
        minlength: 3,
        number:true
      },
      "cardholder_name": {
        required: true
      }
    },
    groups: {
      expire_date: "month year"
    },
    messages: {
      "state":{
        required: I18n.t('require_field_msg'),
        maxlength: I18n.t('maxlength_msg', {field : I18n.t('state'), length: 256})
      },
      "city":{
        required: I18n.t('require_field_msg'),
        maxlength: I18n.t('maxlength_msg', {field : I18n.t('city'), length: 256})
      },
      "address":{
        required: I18n.t('require_field_msg'),
        maxlength: I18n.t('maxlength_msg', {field : I18n.t('locations.address'), length: 256})
      },
      "postal_code":{
        required: I18n.t('require_field_msg'),
        number: I18n.t('msg.postal_code'),
        maxlength: I18n.t('msg.postal_code'),
        minlength: I18n.t('msg.postal_code')
      },
      "country":{
        required: I18n.t('require_field_msg')
      },
      "phone_number":{
        required: I18n.t('require_field_msg'),
        //number: I18n.t('msg.phone'),
        //maxlength: I18n.t('msg.phone'),
        //minlength: I18n.t('msg.phone')
      },
      "card_type":{
        required: I18n.t('require_field_msg')
      },
      "card_number": {
        required: I18n.t('require_field_msg'),
        maxlength: I18n.t('msg.card_number'),
        minlength: I18n.t('msg.card_number'),
        number: I18n.t('msg.card_number')
      },
      "month":{
        required: I18n.t('require_field_msg')
      },
      "year":{
        required: I18n.t('require_field_msg')
      },
      "cvv":{
        required: I18n.t('require_field_msg'),
        maxlength: I18n.t('msg.cvv'),
        minlength: I18n.t('msg.cvv'),
        number: I18n.t('msg.cvv')
      },
      "cardholder_name":{
        required: I18n.t('require_field_msg'),
        maxlength: I18n.t('maxlength_msg', {field : I18n.t('cardholder_name'), length: 256})
      }

    },
    errorPlacement: function(error, element){
      if (element.attr("name") == "month" || element.attr("name") == "year") {
        error.addClass("col col-offset-3");
        error.appendTo(element.parent().parent());
        //error.insertAfter('#creditCardExpirationYear'); 
      }else{
        error.appendTo(element.parent());  
      }
      
    }
  });
  init_form();
  get_owner_user_info(billing_card_info);
  $("#hidden_credit_card_user_id").val(user_info.id);
});

function init_form(){

  $("#state").val('');
  $("#city").val('');
  $("#address").val('');
  $("#postal_code").val('');
  $("#country").val('');
  $("#phone_number").val('');
  $("#card_type").val('');
  $("#card_number").val('');
  $("#month").val('');
  $("#year").val('');
  $("#cvv").val('');
  $("#cardholder_name").val('');
}

function get_owner_user_info(bc_inf)
{

  if(bc_inf){
    $("#state").val(bc_inf.state);
    $("#city").val(bc_inf.city);
    $("#address").val(bc_inf.address);
    $("#postal_code").val(bc_inf.postal_code);
    $("#country").val(bc_inf.country);
    $("#phone_number").val(bc_inf.phone_number);
    $("#card_type").val(bc_inf.card_type);
    $("#card_number").val(bc_inf.card_number);
    $("#month").val(bc_inf.expiration_month);
    $("#year").val(bc_inf.expiration_year);
    $("#cvv").val(bc_inf.cvv);
    $("#cardholder_name").val(bc_inf.card_holder_name);
  }
}