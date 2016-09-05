class Translator {
  constructor() {
    self = this
    this.modal = document.createElement('form')
    this.overlay = document.createElement('div')
    this.addModal()
    this.translations = {}
    this.addOverlay()
    this.getJson('translator/translations', null, function(data) { self.addTranslations(data) })
  }

  addOverlay() {
    self = this
    this.overlay.style.visibility = 'visible'
    this.overlay.id = 't_overlay'
    this.overlay.onclick = function (e) { if (e.target === this) self.close() }
    document.onkeyup = function (e) { if (e.keyCode === 27) self.close() }
    document.body.appendChild(this.overlay)
  }

  close() {
    document.onkeyup = null
    document.body.removeChild(this.overlay)
  }

  save() {
    this.postForm('translator/translate', this.modal, function () { window.location.reload(true) })
  }

  saveButton() {
    var self = this
    var button = document.createElement('button')
    button.innerText = 'Save'
    button.onclick = function() { self.save() }
    return button
  }

  addModal() {
    this.modal.appendChild(this.saveButton())
    this.modal.id = 't_modal'
    this.overlay.appendChild(this.modal)
  }

  addTranslations(translations) {
    for (let locale in translations) {
      this.addTable(locale, translations[locale])
    }
  }

  addTable(locale, translations) {
    let h2 = document.createElement('h2')
    h2.innerText = locale
    let table = document.createElement('table')
    table.id = 't_table'

    let thead = document.createElement('thead')
    let tbody = document.createElement('tbody')
    let row = document.createElement('tr')
    let key = document.createElement('th')
    let value = document.createElement('th')
    key.innerText = 'Key'
    value.innerText = 'Translation'
    row.appendChild(key)
    row.appendChild(value)
    thead.appendChild(row)
    table.appendChild(thead)

    for (let prop in translations) {
      let row = document.createElement('tr')
      let key = document.createElement('td')
      let value = document.createElement('td')
      let input = document.createElement('input')

      key.innerText = prop
      input.name = 'translations[' + locale + '][' + prop + ']'
      input.value = translations[prop]
      value.appendChild(input)
      row.appendChild(key)
      row.appendChild(value)
      tbody.appendChild(row)
    }

    table.appendChild(tbody)
    this.modal.appendChild(h2)
    this.modal.appendChild(table)
  }

  getJson(path, params, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open('GET', '/' + path + '.json' + this.objectToQuery(params))
    xhr.setRequestHeader('Content-Type', 'application/vnd.api+json; charset=UTF-8')
    xhr.send()
  }

  postForm(path, form, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open('POST', '/' + path)
    xhr.setRequestHeader('X-CSRF-Token', this.csrfToken())
    xhr.send(new FormData(form))
  }

  postJson(path, params, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open('POST', '/' + path + '.json')
    xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
    xhr.setRequestHeader('X-CSRF-Token', this.csrfToken())
    xhr.send(JSON.stringify(params))
  }

  // Looks for the csrf-token and returns it if found.
  csrfToken() {
    token = document.getElementsByName('csrf-token')
    if (token.length === 1) {
      return token[0].getAttribute('content')
    } else {
      window.alert('CSRF-token could not be found')
    }
  }

  xhrJson(callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200 && callback) {
        callback(JSON.parse(xhr.responseText))
      }
    }
    return xhr
  }

  objectToQuery(params) {
    var query = ''
    var key = ''

    for (key in params) {
      if (params[key]) {
        if (query !== '') {
          query += '&'
        } else {
          query += '?'
        }
        query += key + '=' + encodeURIComponent(params[key])
      }
    }
    return query
  }
}

;(function () {
  function addSwitch () {
    elemDiv = document.createElement('button')
    elemDiv.style.cssText = 'position:absolute; bottom:0; right:0; z-index:999;'
    elemDiv.innerText = 'Translate'
    elemDiv.onclick = function () { new Translator() }
    document.body.appendChild(elemDiv)
  }

  // After the turbolinks has loaded the DOM add our translation switch.
  // Without turbolinks this would be DOMContentLoaded
  document.addEventListener('turbolinks:load', function() {
    addSwitch()
  })
})()
