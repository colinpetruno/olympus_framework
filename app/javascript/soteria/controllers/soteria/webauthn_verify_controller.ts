import { Controller } from "stimulus"
import { create, get, supported } from "@github/webauthn-json"
import { PublicKeyCredentialDescriptorJSON } from "@github/webauthn-json/dist/src/json";
import { PublicKeyCredentialWithAttestationJSON } from "@github/webauthn-json";

export default class extends Controller {
  allowedDevices: PublicKeyCredentialDescriptorJSON[]; 
  challenge: string;
  createPath: string;
  createPathJson: string;
  authStyle: string;

  connect () {
    console.log("connected");
    this.challenge = $(this.element).data("challenge")
    this.allowedDevices = $(this.element).data("allowedDevices");
    this.createPath = $(this.element).data("sessionUrl");
    this.createPathJson = $(this.element).data("sessionUrlJson");
    this.authStyle = $(this.element).data("authStyle");
  }

  async authenticate() : Promise<void> {
    if (this.authStyle == "redirect") {
      this.handleAuthForRedirect(await get({
        publicKey: {
          challenge: this.challenge,
          allowCredentials: this.allowedDevices,
          userVerification: "discouraged"
        }
      }));
    } else {
      this.handleAuthForRedemption(await get({
        publicKey: {
          challenge: this.challenge,
          allowCredentials: this.allowedDevices,
          userVerification: "discouraged"
        }
      }));
    }
  }

  handleAuthForRedemption (result:any) {
    let that = this;

    $.ajax({
      type: "POST",
      url: this.createPathJson, 
      data: {
        authenticity_token: $("meta[name=csrf-token]").attr("content"),
        public_key_credential: result 
      },
      dataType: "json",
      success: function(result: any) {
        $(that.element).trigger(
          "twoFactorAuthEvent", 
          { id: result["id"] }
        );
      }
    });
  }

  handleAuthForRedirect (result:any) {
    $.ajax({
      type: "POST",
      url: this.createPath, 
      data: {
        authenticity_token: $("meta[name=csrf-token]").attr("content"),
        public_key_credential: result 
      },
      dataType: "json",
      success: function(result: any) {
        window.location.href = result["redirect_url"];
      }
    });
  }
}
