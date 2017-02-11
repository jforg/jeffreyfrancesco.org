const webpack = require('webpack');

// path
const path = require('path');
const publicPath = '/assets/';

// loaders
const urlLoader = {
  loader: 'url-loader',
  options: {
    name: '[name].[ext]',
    limit: 1024
  }
};
const cssLoader = {
  loader: 'css-loader',
  options: {
    sourceMap: true
  }
};
const sassLoader = {
  loader: 'sass-loader',
  options: {
    sourceMap: true
  }
};
const styleLoader = {
  loader: 'style-loader'
};

// config
module.exports = {
  entry: {
    style: 'stylesheets'
  },
  output: {
    path: path.resolve(__dirname, 'gh-pages', 'assets'),
    filename: '[name].js',
    publicPath: publicPath
  },
  resolve: {
    modules: [ path.resolve(__dirname, 'assets'), 'node_modules' ]
  },
  module: {
    rules: [
      {
        test: /\.(png|svg)$/,
        use: [ urlLoader ]
      },
      {
        test: /\.css$/,
        use: [ styleLoader, cssLoader ]
      },
      {
        test: /\.scss$/,
        use: [ styleLoader, cssLoader, sassLoader ]
      }
    ]
  },
  devServer: {
    contentBase: path.resolve(__dirname, 'gh-pages'),
    hot: true,
    publicPath: publicPath,
    watchContentBase: true
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ]
};
