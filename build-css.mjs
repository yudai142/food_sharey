#!/usr/bin/env node

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'
import postcss from 'postcss'
import postcssImport from 'postcss-import'
import tailwindcss from 'tailwindcss'
import autoprefixer from 'autoprefixer'
import * as sass from 'sass'
import { createRequire } from 'module'

const require = createRequire(import.meta.url)
const __dirname = path.dirname(fileURLToPath(import.meta.url))
const watchMode = process.argv.includes('--watch')

const inputFile = path.join(__dirname, 'app/assets/stylesheets/application.scss')
const outputFile = path.join(__dirname, 'public/assets/application.css')
const configFile = path.join(__dirname, 'tailwind.config.cjs')

async function buildCSS() {
  try {
    // Step 1: Read SCSS source and add @tailwind directives if not present
    let scssSource = fs.readFileSync(inputFile, 'utf-8')
    
    // Ensure @tailwind directives are present (as CSS, will be processed by PostCSS)
    if (!scssSource.includes('@tailwind base')) {
      scssSource = '@tailwind base;\n@tailwind components;\n@tailwind utilities;\n' + scssSource
    }
    
    // Step 2: Compile SCSS to CSS using sass
    const sassResult = sass.renderSync({
      data: scssSource,
      includePaths: [path.dirname(inputFile)],
    })
    
    const compiledCSS = sassResult.css.toString()
    
    // Step 3: Process with PostCSS (postcss-import, Tailwind, autoprefixer)
    const config = require(configFile)
    
    const result = await postcss([
      postcssImport(),
      tailwindcss(config),
      autoprefixer(),
    ]).process(compiledCSS, { 
      from: inputFile, 
      to: outputFile,
    })
    
    // Create output directory if it doesn't exist
    const outputDir = path.dirname(outputFile)
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true })
    }
    
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
  fs.watch(path.dirname(inputFile), () => {
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

