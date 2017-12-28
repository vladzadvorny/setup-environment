#! /bin/bash

yarn init -y

# package.json
tmp=$(mktemp)    
jq 'del(.main) | .version = "0.0.1" | .scripts.dev = "nodemon --exec babel-node src/index.js" | .scripts.lint = "eslint src"' package.json > "$tmp" && mv "$tmp" package.json

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

# other
cat > .gitignore << EOF
node_modules
dist
.DS_Store
EOF

# remove
rm -rf server.sh