import esbuild from 'esbuild'
import fs from 'fs'
import path from 'path'
import postcss from 'postcss'
import tailwindcss from 'tailwindcss'
import autoprefixer from 'autoprefixer'
import { createRequire } from 'module'
import { fileURLToPath } from 'url'

const require = createRequire(import.meta.url)
const __dirname = path.dirname(fileURLToPath(import.meta.url))

// PostCSS処理用のプラグイン
const cssPlugin = {
  name: 'css',
  setup(build) {
    // SCSS ファイルの処理
    build.onLoad({ filter: /\.scss$/ }, async (args) => {
      const source = fs.readFileSync(args.path, 'utf-8')
      
      const configFile = path.join(__dirname, 'tailwind.config.cjs')
      const config = require(configFile)
      
      const result = await postcss([
        tailwindcss(config),
        autoprefixer(),
      ]).process(source, { from: args.path })
      
      return {
        contents: `export default ${JSON.stringify(result.css)}`,
        loader: 'js',
      }
    })

    // CSS ファイルの処理
    build.onLoad({ filter: /\.css$/ }, async (args) => {
      const source = fs.readFileSync(args.path, 'utf-8')
      
      const result = await postcss([
        autoprefixer(),
      ]).process(source, { from: args.path })
      
      return {
        contents: `export default ${JSON.stringify(result.css)}`,
        loader: 'js',
      }
    })
  },
}

const args = process.argv.slice(2)
const watch = args.includes('--watch')
const prod = process.env.NODE_ENV === 'production'

let opts = {
  bundle: true,
  sourcemap: !prod,
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  entryPoints: ['app/javascript/application.js'],
  format: 'esm',
  plugins: [cssPlugin],
}

if (watch) {
  opts.logLevel = 'info'
}

;(async () => {
  const ctx = await esbuild.context(opts)

  if (watch) {
    await ctx.watch()
  } else {
    await ctx.rebuild()
    await ctx.dispose()
  }
})().catch((err) => {
  console.error(err)
  process.exit(1)
})


