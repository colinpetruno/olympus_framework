import { Controller } from "stimulus"
import { create, get, supported } from "@github/webauthn-json"
import { PublicKeyCredentialWithAttestationJSON } from "@github/webauthn-json";
import { PublicKeyCredentialDescriptorJSON, PublicKeyCredentialCreationOptionsJSON } from "@github/webauthn-json/dist/src/json";


export default class extends Controller {
  publicKey: PublicKeyCredentialCreationOptionsJSON;
  credential: PublicKeyCredentialWithAttestationJSON;
  createPath: string;
  postCreatePath: string;

  connect() {
    this.publicKey = $(this.element).data("webauthnOptions");
    this.createPath = $(this.element).data("createPath");
    this.postCreatePath = $(this.element).data("postCreatePath");
  }

  async register(): Promise<void> {
    this.storeRegistration(await create({
      publicKey: this.publicKey
    }))
  }

  storeRegistration(registration: PublicKeyCredentialWithAttestationJSON) {
    console.log(registration);
    this.credential = registration;

    $(this.element).find(".slider").removeClass("slide-1").addClass("slide-2");
  }

  displayError () {
    $(this.element).find("#keyNickname").addClass("is-invalid");
  }

  hideError () {
    $(this.element).find("#keyNickname").removeClass("is-invalid");
  }

  saveRegistration() {
    this.hideError();

    if (!this.validKeyName()) {
      this.displayError();
      return false;
    }

    let postCreatePath = this.postCreatePath;

    $.ajax({
      type: "POST",
      url: this.createPath, 
      data: {
        authenticity_token: $("meta[name=csrf-token]").attr("content"),
        public_key_credential: $.extend(
          this.credential, 
          { nickname: this.keyNickname() }
        )
      },
      dataType: "json",
      success: function(result: any) {
        // window.location.href = postCreatePath;
        window.location.reload(true);
      }
    });
  }

  validKeyName() : boolean {
    let nickname:string = this.keyNickname();

    if(nickname == null) {
      return false;
    } else {
      return ((4 < nickname.length) && (nickname.length < 255));
    }
  }

  keyNickname() : string {
    return $(this.element).find("#keyNickname").val().toString();
  }

  reset() {
    this.credential = null;
    this.hideError();
    $(this.element).find(".slider").removeClass("slide-2").addClass("slide-1");
  }
}



// response
// [
//   {
//     "type": "public-key",
//     "id": "O0hU9VDEQaI3d4yBPoGM4y0Zc3OJrZBgG5cjnvEI2ba2nIvzXTYiMQ43IMqCT6FfOGIw0L5PdS8rP7fLNq6BQA",
//     "rawId": "O0hU9VDEQaI3d4yBPoGM4y0Zc3OJrZBgG5cjnvEI2ba2nIvzXTYiMQ43IMqCT6FfOGIw0L5PdS8rP7fLNq6BQA",
//     "response": {
//       "clientDataJSON": "eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoiQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQSIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCIsImNyb3NzT3JpZ2luIjpmYWxzZX0",
//       "attestationObject": "o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YVjESZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NBAAAAAQAAAAAAAAAAAAAAAAAAAAAAQDtIVPVQxEGiN3eMgT6BjOMtGXNzia2QYBuXI57xCNm2tpyL8102IjEONyDKgk-hXzhiMNC-T3UvKz-3yzaugUClAQIDJiABIVggwuaEJFWSmCyo2o4GnGkS0Bk8qNGYlDecvTmEvPlpJD4iWCC-cSt03TB4-uLTAI-vDU81hrJufu4COL_tmqu3Bb389A"
//     },
//     "clientExtensionResults": {}
//   }
// ]
