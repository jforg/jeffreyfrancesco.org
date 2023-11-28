const { merge } = require('webpack-merge');
const path = require('path');

const MiniCSSExtractPlugin = require('mini-css-extract-plugin');
const CSSMinimizerPlugin = require('css-minimizer-webpack-plugin');
const AssetsManifest = require('webpack-assets-manifest');

const publicPath = '/assets/';

const baseConfig = {
  entry: ['javascripts', 'stylesheets'],
  output: {
    publicPath: publicPath,
    assetModuleFilename: '[name]-[hash][ext][query]'
  },
  resolve: {
    modules: [path.resolve(__dirname, 'assets'), 'node_modules']
  },
  module: {
    rules: [
      {
        test: /\.(gif|jpg|png|svg)$/,
        type: 'asset',
        parser: {
          dataUrlCondition: {
            maxSize: 1024
          }
        }
      }
    ]
  }
};
const watchConfig = {
  mode: 'development',
  output: {
    path: path.resolve(__dirname, 'preview', 'assets'),
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.scss$/,
        use: ['style-loader', 'css-loader', 'sass-loader']
      }
    ]
  },
  devServer: {
    static: {
      directory: path.resolve(__dirname, 'preview'),
    }
  },
  devtool: 'eval-cheap-module-source-map'
};
const buildConfig = {
  mode: 'production',
  output: {
    path: path.resolve(__dirname, 'gh-pages', 'assets'),
    filename: '[name]-[chunkhash].js'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [MiniCSSExtractPlugin.loader, 'css-loader']
      },
      {
        test: /\.scss$/,
        use: [MiniCSSExtractPlugin.loader, 'css-loader', 'sass-loader']
      }
    ]
  },
  optimization: {
    minimizer: [
      `...`,
      new CSSMinimizerPlugin()
    ]
  },
  plugins: [
    new MiniCSSExtractPlugin({
      filename: 'style-[contenthash].css'
    }),
    new AssetsManifest({
      output: path.resolve(__dirname, 'source', '_data', 'manifest.json'),
      publicPath: publicPath
    })
  ]
};

const isBuild = /^build/.test(process.env.npm_lifecycle_event);
module.exports = merge(baseConfig, (isBuild ? buildConfig : watchConfig));
