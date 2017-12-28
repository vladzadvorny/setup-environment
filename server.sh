#! /bin/bash

yarn init -y

# install babel
yarn add -D babel-cli babel-preset-env
cat > .babelrc << EOF
{
  "presets": ["env"]
}
EOF

# install nodemon
yarn add -D nodemon
mkdir src
cat > src/index.js << EOF
console.log('hello')
EOF
tmp=$(mktemp)    
jq '.scripts.dev = "nodemon --exec babel-node src/index.js"' package.json > "$tmp" && mv "$tmp" package.json

# install eslint
yarn add -D eslint eslint-config-airbnb-base eslint-config-prettier eslint-plugin-import
cat > .eslintrc << EOF
{
  "extends": ["airbnb-base", "prettier"],  
  "rules": {
    "no-console": 0,
    "no-underscore-dangle": 0,
    "camelcase": 0
  }
}
EOF
tmp=$(mktemp)    
jq '.scripts.lint = "eslint src"' package.json > "$tmp" && mv "$tmp" package.json

# other
cat > .gitignore << EOF
node_modules
dist
.DS_Store
EOF