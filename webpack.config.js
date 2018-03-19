const webpack = require('webpack');
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const isProduction = process.env.NODE_ENV === 'production';
const port = process.env.PORT || 3000;

const config = {
  entry: isProduction
    ? {
        bundle: './src/index.js'
      }
    : {
        bundle: [
          'react-hot-loader/patch',
          './src/index.js',
          'webpack/hot/only-dev-server'
        ],
        devServerClient: `webpack-dev-server/client?http://localhost:${port}`
      },
  output: {
    path: path.join(__dirname, 'dist'),
    filename: isProduction ? '[name].[chunkhash].js' : '[name].js'
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        commons: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendor',
          chunks: 'all'
        }
      }
    }
  },
  devServer: {
    hot: true,
    historyApiFallback: true,
    port,
    publicPath: '/'
  },
  module: {
    rules: [
      {
        use: 'babel-loader',
        test: /\.js$/,
        exclude: /node_modules/
      },
      {
        use: ['style-loader', 'css-loader'],
        test: /\.css$/
      },
      {
        loader: 'url-loader?limit=100000',
        test: /\.(png|woff|woff2|eot|ttf|svg)$/
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    }),
    new webpack.NamedModulesPlugin(),
    new CopyWebpackPlugin([
      // relative path is from src
      { from: './src/favicon.ico' } // <- your path to favicon
    ]),
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'src/index.html',
      minify: {
        removeScriptTypeAttributes: true,
        removeComments: true,
        collapseWhitespace: true
      }
    })
  ]
};

if (!isProduction) {
  config.plugins.push(new webpack.HotModuleReplacementPlugin());
}

module.exports = config;
