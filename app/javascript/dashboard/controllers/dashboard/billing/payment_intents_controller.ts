import { Controller } from "stimulus";

export default class extends Controller {
  element: HTMLElement;
  $form: JQuery<HTMLElement>;
  initialized: boolean = false;
  customerId: string;
  stripe: any;
  stripeElements: any;
  card: any;

  connect() {
    this.$form = $(this.element).find(".simple_form.edit_billing_payment_intent");
    this.stripe = window.Stripe(this.element.dataset["stripePublicKey"]);
    this.stripeElements = this.stripe.elements();

    this.card = this.stripeElements.create('card', {
      style: this.defaultStyles()
    });

    this.card.mount('#card-element');

    if(!this.initialized) {
      this.bindEvents();
      this.checkSubmittable();
    }
  }

  bindEvents() {
    this.card.on('change', function(event:any) {
      var displayError = document.getElementById('card-errors');

      if (event.error) {
        displayError.textContent = event.error.message;
      } else {
        displayError.textContent = '';
      }
    });

    let that = this;

    this.$form.on("change", () => {
      this.checkSubmittable();
    });

    this.$form[0].addEventListener('submit', (event:any) => {
      let selectedCard = $('input[name="billing_payment_intent[billing_source_id]"]:checked').val();

      if (selectedCard != "new_card") {
        return true;
      }

      event.preventDefault();

      this.stripe.createSource(this.card).then((result:any) => {
        if (result.error) {
          // Inform the user if there was an error.
          var errorElement = document.getElementById('card-errors');
          errorElement.textContent = result.error.message;
        } else {
          // Send the token to your server.
          this.stripeTokenHandler(result.source);
        }
      });
    });

    this.initialized = true;
  }

  checkSubmittable() {
    let termsAccepted = $("#billing_payment_intent_accept_terms").prop("checked");
    let newCard = $('input[name="billing_payment_intent[billing_source_id]"]:checked').val(); 

    if (newCard == "new_card") {
      $("#card-element-container").slideDown();
    } else {
      $("#card-element-container").slideUp();
    }


    if(termsAccepted == true) {
      this.$form.find("input[type=submit]").prop("disabled", false);
    } else {
      this.$form.find("input[type=submit]").prop("disabled", "disabled");
      this.$form.find("input[type=submit]").attr("disabled", "disabled");
    }
  }

  stripeTokenHandler(stripeSource:any) {
    $("#billing_payment_intent_billing_external_id_attributes_external_id").val(stripeSource.id);
    $("#billing_payment_intent_exp_year").val(stripeSource.card.exp_year);
    $("#billing_payment_intent_exp_month").val(stripeSource.card.exp_month);
    $("#billing_payment_intent_brand").val(stripeSource.card.brand);
    $("#billing_payment_intent_last_four").val(stripeSource.card.last4);

    // Submit the form
    this.$form.submit();
  }

  defaultStyles() {
    return {
      base: {
        color: '#32325d',
        fontFamily: '"GT Walsheim Pro", "Helvetica Neue", Arial, sans-serif',
        fontSmoothing: 'antialiased',
        fontSize: '16px',
        '::placeholder': {
          color: '#aab7c4'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    };
  }
}
