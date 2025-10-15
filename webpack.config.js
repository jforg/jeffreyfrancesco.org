const { merge } = require('webpack-merge');
const path = require('path');

const MiniCSSExtractPlugin = require('mini-css-extract-plugin');
const CSSMinimizerPlugin = require('css-minimizer-webpack-plugin');
const { WebpackAssetsManifest } = require('webpack-assets-manifest');

const publicPath = '/assets/';

const baseConfig = {
  entry: ['javascripts', 'stylesheets'],
  output: {
    path: path.resolve(__dirname, 'public', 'assets'),
    publicPath: publicPath
  },
  resolve: {
    modules: [path.resolve(__dirname, 'assets'), 'node_modules']
  },
  module: {
    rules: [
      {
        test: /\.(gif|jpg|png|svg|woff2)$/,
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
    filename: '[name].js',
    assetModuleFilename: '[name][ext][query]'
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
    client: {
      overlay: {
        errors: true,
        warnings: true,
        runtimeErrors: false
      }
    },
    static: {
      directory: path.resolve(__dirname, 'public'),
    }
  },
  devtool: 'eval-cheap-module-source-map'
};
const buildConfig = {
  mode: 'production',
  output: {
    filename: '[name]-[chunkhash].js',
    assetModuleFilename: '[name]-[hash][ext][query]'
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
    new WebpackAssetsManifest({
      output: path.resolve(__dirname, 'source', '_data', 'manifest.json'),
      publicPath: publicPath
    })
  ]
};

const isBuild = /^build/.test(process.env.npm_lifecycle_event);
module.exports = merge(baseConfig, (isBuild ? buildConfig : watchConfig));
