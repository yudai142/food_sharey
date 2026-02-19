import esbuild from 'esbuild'

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
  loader: {
    '.scss': 'copy',
    '.css': 'copy',
  },
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


