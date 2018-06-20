
$(function() {

	$.validator.addMethod('strongPassword', function(value, element) {
		return value.length >=6;
	}, 'Das Passwort muss mindestens 6 Zeichen lang sein');
	
	$("#registrateForm").validate({
		errorClass: "my-error-class",
		rules: {
			firstName: {
				required: true
			},
			lastName: {
				required: true
			},
			street: {
				required: true
			},
			numberHouse: {
				required: true
			},
			zip: {
				required: true,
				number: true
			},
			city: {
				required: true
			},
			email: {
				required: true,
				email: true,
				remote: {url: "/registration/emailInUseValidator"}
			},
			emailConfirm: {
				required: true,
				email: true,
				equalTo: "#email"
			},
			password: {
				required: true, 
				strongPassword: true
			},
			confirmPassword: {
				required: true,
				equalTo: "#password"
			},
			regKey: {
				required: true,
				remote: {url: "/registration/regKeyValidator"}
			}
		},
		messages: {
			firstName: {
				required: "Bitte geben Sie Ihren Vornamen an"
			},
			lastName: {
				required: "Bitte geben Sie Ihren Nachnamen an"
			},
			street: {
				required: "Bitte geben Sie Ihre Straße an"
			},
			numberHouse: {
				required: "Bitte geben Sie Ihre Hausnummer an"
			},
			zip: {
				required: "Bitte geben Sie Ihre PLZ an",
				number: "Bitte geben Sie eine gültige PLZ an"
			},
			city: {
				required: "Bitte geben Sie Ihren Ort an"
			},
			email: {
				required: "Bitte geben Sie Ihre Email Adresse an",
				email: "Bitte geben Sie eine gültige Email Adresse an",
				remote: "Die Email Adresse ist schon registriert. Möchten sie sich <a href='/login'>einloggen?</a>"
			},
			emailConfirm: {
				required: "Bitte wiederholen Sie Ihre Email Adresse",
				email: "Bitte geben Sie eine gültige Email Adresse an",
				equalTo: "Die Email Adressen stimmen nicht überein"
			},
			password: {
				required: "Bitte geben Sie ein Passwort ein"
			},
			confirmPassword: {
				required: "Bitte wiederholen Sie Ihr Passwort",
				equalTo: "Die Passwörter stimmen nicht überein"
			},
			regKey: {
				required: "Bitte geben Sie einen gültigen Registrierungsschlüssel ein",
				email: "Bitte geben Sie eine gültige Email Adresse an",
				remote: "Der Registrierungsschlüssel ist nicht gültig oder wurde schon verbraucht"
			}
		}

	})

	$("#loginForm").validate({
		errorClass: "my-error-class",
		rules: {
			username: {
				required: true,
				email: true
			},
			password: {
				required: true
			}
		},
		messages: {
			username: {
				required: "Bitte geben Sie Ihre Email Adresse ein",
				email: "Bitte geben Sie eine gütlige Email Adresse ein"
			},
			password: {
				required: "Bitte geben Sie Ihr Passwort ein"
			}
		}
	});


	$("#changeprofile").validate({
		errorClass: "my-error-class",
		rules: {
			firstName: {
				required: true
			},
			lastName: {
				required: true
			},
			street: {
				required: true
			},
			numberHouse: {
				required: true
			},
			zip: {
				required: true,
				number: true
			},
			city: {
				required: true
			},
			email: {
				required: true,
				email: true,
				remote: {url: "/registration/emailInUseChangeProfileValidator"}
			}
		},
		messages: {
			firstName: {
				required: "Bitte geben Sie Ihren Vornamen an"
			},
			lastName: {
				required: "Bitte geben Sie Ihren Nachnamen an"
			},
			street: {
				required: "Bitte geben Sie Ihre Straße an"
			},
			numberHouse: {
				required: "Bitte geben Sie Ihre Hausnummer an"
			},
			zip: {
				required: "Bitte geben Sie Ihre PLZ an",
				number: "Bitte geben Sie eine gültige PLZ an"
			},
			city: {
				required: "Bitte geben Sie Ihren Ort an"
			},
			email: {
				required: "Bitte geben Sie Ihre Email Adresse an",
				email: "Bitte geben Sie eine gültige Email Adresse an",
				remote: "Die Email Adresse ist schon registriert. Bitte wählen Sie eine andere Email Adresse</a>"
			}
		}
	});


})