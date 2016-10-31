;(function() {
  var d = document
  var e = function(tag) { return d.createElement(tag) }

  this.Translator = function () {
    self = this
    this.modal = e('div')
    this.modal_header = e('div')
    this.modal_body = e('form')
    this.modal_footer = e('div')
    this.modal_title = e('div')
    this.modal_close = e('div')
    this.overlay = e('div')
    this.addModal()
    this.translations = {}
    this.getJson('translator/translations', null, function(data) { self.addTranslations(data) })
    this.addOverlay()
  }

  Translator.prototype.addOverlay = function() {
    self = this
    this.overlay.style.visibility = 'visible'
    this.overlay.className += 'Overlay'
    this.overlay.onclick = function (e) { if (e.target === this) self.close() }
    this.modal_close.onclick = function () { self.close() }
    d.onkeyup = function (e) { if (e.keyCode === 27) self.close() }
    d.body.appendChild(this.overlay)
  }

  Translator.prototype.close = function() {
    d.onkeyup = null
    d.body.removeChild(this.overlay)
  }

  Translator.prototype.save = function() {
    this.postForm('translator/translate', this.modal_body, function () { window.location.reload(true) })
  }

  Translator.prototype.saveButton = function() {
    var self = this
    var button = e('button')
    button.innerText = 'Save'
    button.onclick = function() { self.save() }
    return button
  }

  Translator.prototype.addModal = function() {
    this.modal.className = 'Modal'
    this.modal_body.className += 'Modal-body'
    this.modal_header.className += 'Modal-header'
    this.modal_footer.className += 'Modal-footer'
    this.modal_title.className += 'Modal-title'
    this.modal_close.className += 'Modal-close'
    this.modal_title.innerText = 'Translator'
    this.modal_close.innerText = 'X'

    this.modal_header.appendChild(this.modal_title)
    this.modal_header.appendChild(this.modal_close)
    this.modal_footer.appendChild(this.saveButton())
    this.modal.appendChild(this.modal_header)
    this.modal.appendChild(this.modal_body)
    this.modal.appendChild(this.modal_footer)
    this.overlay.appendChild(this.modal)
  }

  Translator.prototype.addTranslations = function(translations) {
    for (var locale in translations) {
      this.addTable(locale, translations[locale])
    }
  }

  Translator.prototype.addTable = function(locale, translations) {
    var h2 = e('h2')
    h2.innerText = 'Translate: ' + locale
    var table = e('div')
    table.className += 'Table'

    var header = e('div')
    var row = e('div')
    var key = e('div')
    var value = e('div')
    var options = e('div')
    var defaults = e('div')
    row.className += 'Table-row'
    key.className += 'Table-row-item'
    value.className += 'Table-row-item'
    options.className += 'Table-row-item'
    defaults.className += 'Table-row-item'
    key.innerText = 'Key'
    value.innerText = 'Translation'
    options.innerText = 'Options'
    defaults.innerText = 'Defaults'
    row.appendChild(key)
    row.appendChild(value)
    row.appendChild(options)
    row.appendChild(defaults)
    header.appendChild(row)
    table.appendChild(header)

    for (var prop in translations) {
      var row = e('div')
      var key = e('div')
      var value = e('div')
      var options = e('div')
      var defaults = e('div')
      var input = e('textarea')

      row.className += 'Table-row'
      key.className += 'Table-row-item'
      value.className += 'Table-row-item'
      options.className += 'Table-row-item'
      defaults.className += 'Table-row-item'

      key.innerText = prop
      input.name = 'translations[' + locale + '][' + prop + ']'

      if (translations[prop].value) {
        input.value = translations[prop].value
      }

      if (Object.getOwnPropertyNames(translations[prop].options).length > 0) {
        for (var option in translations[prop].options) {
          options.innerText += '%{' + option + '} = ' + translations[prop].options[option] + '\u000A'
        }
      }

      var defaults_length = translations[prop].defaults.length
      for (var i = 0; i < defaults_length; i++) {
        defaults.innerText += translations[prop].defaults[i] + '\u000A'
      }

      value.appendChild(input)
      row.appendChild(key)
      row.appendChild(value)
      row.appendChild(options)
      row.appendChild(defaults)
      table.appendChild(row)
    }

    this.modal_body.appendChild(h2)
    this.modal_body.appendChild(table)
  }

  Translator.prototype.getJson = function(path, params, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open('GET', '/' + path + '.json' + this.objectToQuery(params))
    xhr.setRequestHeader('Content-Type', 'application/vnd.api+json; charset=UTF-8')
    xhr.send()
  }

  Translator.prototype.postForm = function(path, form, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open('POST', '/' + path)
    xhr.setRequestHeader('X-CSRF-Token', this.csrfToken())
    xhr.send(new FormData(form))
  }

  Translator.prototype.postJson = function(path, params, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open('POST', '/' + path + '.json')
    xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
    xhr.setRequestHeader('X-CSRF-Token', this.csrfToken())
    xhr.send(JSON.stringify(params))
  }

  // Looks for the csrf-token and returns it if found.
  Translator.prototype.csrfToken = function() {
    token = d.getElementsByName('csrf-token')
    if (token.length === 1) {
      return token[0].getAttribute('content')
    } else {
      window.alert('CSRF-token could not be found')
    }
  }

  Translator.prototype.xhrJson = function(callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200 && callback) {
        callback(JSON.parse(xhr.responseText))
      }
    }
    return xhr
  }

  Translator.prototype.objectToQuery = function(params) {
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
})()
