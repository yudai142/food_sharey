import '@fortawesome/fontawesome-free/js/all'
import Rails from '@rails/ujs'
import * as ActiveStorage from '@rails/activestorage'
import './channels'
import './entrypoints/resize.js'
import './entrypoints/preview.js'

Rails.start()
ActiveStorage.start()
