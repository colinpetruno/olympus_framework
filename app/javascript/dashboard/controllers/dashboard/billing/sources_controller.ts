import { Controller } from "stimulus";

export default class extends Controller {
  element: HTMLElement;
  $form: JQuery<HTMLElement>;
  initialized: boolean = false;
  customerId: string;
  setupIntent: any;
  stripe: any;
  stripeElements: any;
  card: any;

  connect() {
    this.$form = $(this.element).find("#new_billing_source");
    this.stripe = window.Stripe(this.element.dataset["stripePublicKey"]);
    this.stripeElements = this.stripe.elements();

    if (this.card == null) {
      this.createStripeCard()
    } 
    this.card.mount('#card-element');


    if(!this.initialized) {
      this.bindEvents();
    }
  }

  // TODO: we need to make a billing_sources controller to better handle 
  // setup intents

  createStripeCard () {
    this.card = this.stripeElements.create('card', {
      style: this.defaultStyles()
    });

    return this.card;
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

    this.$form[0].addEventListener('submit', (event:any) => {
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


  stripeTokenHandler(stripeSource:any) {
    $("#billing_source_billing_external_id_attributes_external_id").val(stripeSource.id);
    $("#billing_source_exp_year").val(stripeSource.card.exp_year);
    $("#billing_source_exp_month").val(stripeSource.card.exp_month);
    $("#billing_source_brand").val(stripeSource.card.brand);
    $("#billing_source_last_four").val(stripeSource.card.last4);

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
