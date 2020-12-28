const { environment } = require('@rails/webpacker')
const typescript =  require('./loaders/typescript')

const webpack = require('webpack')

environment.config.set('resolve.alias', {
  jquery: 'jquery/src/jquery',
  $: 'jquery/src/jquery',
  "jquery-ui": 'jquery-ui-dist/jquery-ui.js',
  Popper: 'Popper'
});

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
);

environment.loaders.prepend('typescript', typescript)

environment.loaders.append('expose', {
  test: require.resolve('jquery'),
  use: [
    {
      loader: 'expose-loader',
      options: {
        exposes: ['$', 'jQuery']
      }
    }
  ]
})

environment.splitChunks((config) => Object.assign({}, config, {
  optimization: {
    splitChunks: {
      cacheGroups: {
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          priority: -10
        },
        default: {
          minChunks: 2,
          priority: -20,
          reuseExistingChunk: true,
        },
      }
    },
    runtimeChunk: true
  }
}))

environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    'window.Tether': "tether",
    Popper: ['popper.js', 'default']
  })
)

module.exports = environment
