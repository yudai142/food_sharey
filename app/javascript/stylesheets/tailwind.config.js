module.exports = {
  purge: [
    "./app/**/*.html.erb",
    "./app/**/*.js.erb",
    "./app/**/*.html.slim",
    "./app/**/*.js.slim",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/javascript/**/*.vue"
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
