const merge = require('webpack-merge');
const path = require('path');

const ExtractTextPlugin = require('extract-text-webpack-plugin');
const AssetsManifest = require('webpack-assets-manifest');

const publicPath = '/assets/';

const baseConfig = {
  entry: ['stylesheets'],
  output: {
    publicPath: publicPath
  },
  resolve: {
    modules: [path.resolve(__dirname, 'assets'), 'node_modules']
  },
  module: {
    rules: [
      {
        test: /\.(gif|jpg|png|svg)$/,
        loader: 'url-loader',
        options: {
          limit: 1024,
          name: '[name]-[hash].[ext]'
        }
      }
    ]
  }
};
const watchConfig = {
  output: {
    path: path.resolve(__dirname, 'preview', 'assets'),
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader?sourceMap']
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader?sourceMap', 'sass-loader?sourceMap']
      }
    ]
  },
  devServer: {
    contentBase: path.resolve(__dirname, 'preview'),
    publicPath: publicPath,
    watchContentBase: true
  }
};
const buildConfig = {
  output: {
    path: path.resolve(__dirname, 'gh-pages', 'assets'),
    filename: '[name]-[chunkhash].js'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract(['css-loader'])
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract(['css-loader', 'sass-loader'])
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin({
      filename: 'style-[contenthash].css',
      allChunks: true
    }),
    new AssetsManifest({
      output: path.resolve(__dirname, 'source', '_data', 'manifest.json'),
      publicPath: publicPath
    })
  ]
};

const isBuild = /^build/.test(process.env.npm_lifecycle_event);
module.exports = merge(baseConfig, (isBuild ? buildConfig : watchConfig));
