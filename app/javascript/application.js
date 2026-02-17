import '@fortawesome/fontawesome-free/js/all'
import Rails from '@rails/ujs'
import * as ActiveStorage from '@rails/activestorage'
import './channels'
import './entrypoints/resize.js'
import './entrypoints/preview.js'
// CSS is built separately by build-css.mjs and copied to app/assets/builds/

Rails.start()
ActiveStorage.start()
