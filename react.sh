#! /bin/bash

yarn init -y

# scripts
tmp=$(mktemp)    
jq '.scripts.build = "rm -rf dist && cross-env NODE_ENV=production webpack -p" | .scripts.serve = "PORT=3002 webpack-dev-server" | .scripts.lint = "eslint src"' package.json > "$tmp" && mv "$tmp" package.json

# install babel
yarn add -D babel-core babel-preset-env babel-preset-react babel-plugin-transform-class-properties babel-plugin-transform-object-rest-spread babel-plugin-transform-runtime 
cat > .babelrc << EOF
{
  "presets": [
    [
      "env",
      {
        "targets": {
          "browsers": ["last 2 versions"]
        },
        "modules": false
      }
    ],
    "react"
  ],
  "plugins": [
    "transform-runtime",
    "transform-class-properties",
    "transform-object-rest-spread",
    "react-hot-loader/babel"
  ]
}
EOF

# install eslint
yarn add -D eslint eslint-config-airbnb eslint-config-prettier eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react babel-eslint
cat > .eslintrc << EOF
{
  "parser": "babel-eslint",
  "extends": ["airbnb", "prettier"],
  "plugins": ["react", "jsx-a11y", "import"],
  "rules": {
    "react/jsx-filename-extension": [1, { "extensions": [".js", ".jsx"] }],
    "react/prefer-stateless-function": [0],
    "react/prop-types": [0],
    "jsx-a11y/anchor-is-valid": [0]
  },
  "env": {
    "browser": true
  }
}
EOF

# install webpack
yarn add -D webpack webpack-dev-server html-webpack-plugin copy-webpack-plugin
yarn add -D babel-loader style-loader css-loader file-loader url-loader
wget "https://raw.githubusercontent.com/vladzadvorny/team-chat-client/master/webpack.config.js"

# other
cat > .gitignore << EOF
node_modules
dist
.DS_Store
EOF
cat > .eslintignore << EOF
dist
registerServiceWorker.js
EOF
mkdir src

# install react 
yarn add react react-dom react-hot-loader