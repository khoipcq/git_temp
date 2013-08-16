(function ($) {
    $.fn.extend({
        pschecker: function (options) {
            var settings = $.extend({ minlength: 8, maxlength: 16, onPasswordValidate: null, onPasswordMatch: null }, options);
            return this.each(function () {
                var wrapper = $('.password-container');
                var password = $('.strong-password:eq(0)', wrapper);

                password.keyup(validatePassword).blur(validatePassword).focus(validatePassword);

                function validatePassword() {
                    var pstr = password.val().toString();
                    var meter = $('.meter');
                    var strWeek = '<div class= "progress-bar" id= "weak"> Weak </div>';
                    var strFair = '<div class= "progress-bar" id= "weak"> Fair </div>';
                    var strStrong = '<div class= "progress-bar" id= "weak"> Strong </div>';
                    
                    meter.html(strWeek+strFair+strStrong);
                    
                    //fires password validate event if password meets the min length requirement
                    if (settings.onPasswordValidate != null)
                        settings.onPasswordValidate(pstr.length >= settings.minlength);

                    if (pstr.length < settings.maxlength){
                        meter.removeClass('strong').removeClass('medium').removeClass('week');
                    }
                    if (pstr.length > 0) {
                        var rx = new RegExp(/^(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{4,30}$/);
                        if (rx.test(pstr)) {
                            // meter.addClass('strong');
                            // meter.html("Strong");
                            strWeek = '<div class= "progress-bar bg-success" id= "weak"> Weak </div>';
                    		strFair = '<div class= "progress-bar bg-success" id= "weak"> Fair </div>';
                            strStrong = '<div class= "progress-bar bg-success" id= "weak"> Strong </div>';    
                            meter.html(strWeek+strFair+strStrong);
                        }
                        else {
                            var alpha = containsAlpha(pstr);
                            var number = containsNumeric(pstr);
                            var upper = containsUpperCase(pstr);
                            var special = containsSpecialCharacter(pstr);
                            var result = alpha + number + upper + special;

                            if (result > 2) {
                                // meter.addClass('medium');
                                // meter.html("Medium");
                                strWeek = '<div class= "progress-bar bg-warning" id= "weak"> Weak </div>';
                            	strFair = '<div class= "progress-bar bg-warning" id= "weak"> Fair </div>';    
                            	meter.html(strWeek+strFair+strStrong);    
                            }
                            else {
                                // meter.addClass('week');
                                // meter.html("Week");
                                var fair = $('#week');
                            	fair.addClass('bg-warning');
                            	strWeek = '<div class= "progress-bar bg-danger" id= "weak"> Weak </div>'
                            	meter.html(strWeek+strFair+strStrong);
                            }
                        }
                    }
                }

                function containsAlpha(str) {
                    var rx = new RegExp(/[a-z]/);
                    if (rx.test(str)) return 1;
                    return 0;
                }

                function containsNumeric(str) {
                    var rx = new RegExp(/[0-9]/);
                    if (rx.test(str)) return 1;
                    return 0;
                }

                function containsUpperCase(str) {
                    var rx = new RegExp(/[A-Z]/);
                    if (rx.test(str)) return 1;
                    return 0;
                }
                function containsSpecialCharacter(str) {

                    var rx = new RegExp(/[\W]/);
                    if (rx.test(str)) return 1;
                    return 0;
                }


            });
        }
    });
})(jQuery);
