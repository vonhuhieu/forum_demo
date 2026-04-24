const { defineConfig } = require('@vue/cli-service')
const path = require('path')

module.exports = defineConfig({
  chainWebpack: (config) => {
    config.resolve.alias.set('@', path.resolve(__dirname, './src'))
  },
  transpileDependencies: true,
  productionSourceMap: false,
  devServer: {
    port: 5173,
    allowedHosts: 'all',
    hot: true,
    proxy: {
      '/api': {
        target: process.env.VUE_APP_PROXY_TARGET || 'http://localhost:8080',
        changeOrigin: true,
        secure: false,
        logLevel: 'debug'
      }
    }
  }
})
