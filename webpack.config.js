const path = require('path')
const webpack = require('webpack')

const plugins = [new webpack.optimize.ModuleConcatenationPlugin()]

module.exports = function webpackStuff (env) {
    return {
        entry: ['./src/web/index.js'],
        output: {
            filename: 'public/bundle.js',
            path: path.resolve(__dirname, './')
        },
        mode: 'production',
        module: {
            rules: [
                {
                    test: /\.js$/,
                    loader: 'babel-loader',
                    query: {
                        presets: [
                            '@babel/env',
                            '@babel/react'
                        ],
                        plugins: []
                    }
                }
            ]
        },
        plugins
    }
}
