class Ichnaea {
  constructor() {
    this.setup_track_links_and_forms_handler()
  }

  setup_track_links_and_forms_handler () {
    let that = this;

    $(document).on('turbolinks:load', function() {
      $(document).find("a[data-track=true]").click(function(event:any) {
        event.preventDefault();
        let targetUrl = $(this).attr("href");
        let data = $(this).data();

        let tracking_keys:any = [];
        let data_keys:any = Object.keys(data)

        data_keys.map(function(key_name:any) {
          if(key_name.startsWith("track") && key_name != "track") {
            tracking_keys.push(key_name); 
          }
        });

        let additional_data = that.slice(data, tracking_keys);

        $.post("/ichnaea/events", { 
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          ichnaea_event: { 
            event_name: "Click",
            event_payload: Object.assign({
              action: $("body").data("action"),
              controller: $("body").data("controller"),
              pageX: event.pageX,
              pageY: event.pageY,
              text: $(this).text()
            }, additional_data)
          } 
        });

        if($(this).data("remote")) {
          // might not need to do anything here, turbolinks seems to take
          // over and complete the transaction
        } else {
          window.setTimeout(function(){ 
            window.location.href = targetUrl; 
          },100); 
        }
      });

      $(document).find("form[data-track=true]").submit(function(event:any) {
        event.preventDefault();

        let $form = $(this);
        let data = $(this).data();
        let tracking_keys:any = [];
        let data_keys:any = Object.keys(data)

        data_keys.map(function(key_name:any) {
          if(key_name.startsWith("track") && key_name != "track") {
            tracking_keys.push(key_name); 
          }
        });

        let additional_data = that.slice(data, tracking_keys);

        $.post("/ichnaea/events", { 
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          ichnaea_event: { 
            event_name: "Form Submit",
            event_payload: Object.assign({
              action: $("body").data("action"),
              controller: $("body").data("controller"),
            }, additional_data)
          } 
        });

        window.setTimeout(function(){ 
          $form.off("submit").submit();
        },100); 
      });
    });
  }

  slice(object:any, keys:any) {
    return Object.keys(object).filter(function (key) {
      return keys.indexOf(key) >= 0;
    }).reduce(function (acc:any, key:any) {
      acc[key] = object[key];
      return acc;
    }, {});
  }

  track(event_name: string, properties: any) {
    $.post("/ichnaea/events", { 
      authenticity_token: $("meta[name=csrf-token]").attr("content"),
      ichnaea_event: { 
        event_name: event_name,
        event_payload: Object.assign({
          action: $("body").data("action"),
          controller: $("body").data("controller"),
        }, properties)
      }
    });
  }
}

window.Ichnaea = new Ichnaea();
