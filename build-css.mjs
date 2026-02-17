#!/usr/bin/env node

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'
import postcss from 'postcss'
import tailwindcss from 'tailwindcss'
import autoprefixer from 'autoprefixer'
import { createRequire } from 'module'

const require = createRequire(import.meta.url)
const __dirname = path.dirname(fileURLToPath(import.meta.url))
const watchMode = process.argv.includes('--watch')

const inputFile = path.join(__dirname, 'app/javascript/stylesheets/application.scss')
const outputFile = path.join(__dirname, 'app/assets/builds/application.css')
const configFile = path.join(__dirname, 'tailwind.config.cjs')

async function buildCSS() {
  try {
    const input = fs.readFileSync(inputFile, 'utf-8')
    const config = require(configFile)
    
    const result = await postcss([
      tailwindcss(config),
      autoprefixer(),
    ]).process(input, { from: inputFile, to: outputFile })
    
    fs.writeFileSync(outputFile, result.css)
    const timestamp = new Date().toLocaleTimeString()
    console.log(`[${timestamp}] ✓ CSS built successfully (${result.css.length} bytes)`)
  } catch (error) {
    console.error('CSS build failed:', error.message)
    console.error(error.stack)
    process.exit(1)
  }
}

if (watchMode) {
  console.log('Watching for CSS changes...')
  fs.watch(inputFile, () => {
    buildCSS()
  })
  fs.watch(configFile, () => {
    console.log('Tailwind config changed, rebuilding CSS...')
    buildCSS()
  })
  // Keep watch mode running
  setInterval(() => {}, 1000)
} else {
  buildCSS()
}

