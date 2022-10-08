/** @type {import('next').NextConfig} */
const withPWA = require('next-pwa')
const runtimeCaching = require('next-pwa/cache')

module.exports = withPWA({
  images: {
    domains: ['images.unsplash.com'],
  },
  pwa: {
    dest: 'public',
    runtimeCaching,
  },
})
