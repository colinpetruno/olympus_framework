class DisableCssAnimations
  DISABLE_ANIMATIONS_HTML = <<~HTML
    <script type="text/javascript">
      if (typeof window.jQuery !== 'undefined') {
        window.jQuery(() => {
            window.jQuery.support.transition = false;
            if (typeof window.jQuery.fx !== 'undefined') {
              window.jQuery.fx.off = true;
            }
        });
      }
    </script>
    <style>
      * {
         -webkit-transition: .0s !important;
         transition: .0s !important;
         -webkit-transform: .0s !important;
         transform: .0s !important;
         -webkit-animation: .0s !important;
         animation: .0s !important;
      }
    </style>
  HTML

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    return status, headers, body unless html?(headers)
    response = Rack::Response.new([], status, headers)

    body.each { |fragment| response.write inject(fragment) }
    body.close if body.respond_to?(:close)
    response.finish
  end

  private

  def html?(headers)
    headers['Content-Type'] =~ /html/
  end

  def inject(fragment)
    fragment.gsub('</body>', DISABLE_ANIMATIONS_HTML + '</body>')
  end
end
