;(function() {
  this.Translator = function () {}

  var d = document
  var e = function(tag) { return d.createElement(tag) }
  var t = new Translator()

  // Wait for the dom to be loaded, and then an extra 2 seconds to let other ajax queries
  // finish their requests, during those other ajax requests additional translations might
  // get triggered that would otherwise be missed.
  var main = function() {
    var elements = d.getElementsByClassName("translator")

    if (elements !== undefined) {
      var missing_translations = 0

      setTimeout(function(){
        t.getTranslations(function(data) {
          for (var locale in data) {
            if (data.hasOwnProperty(locale)) {
              for (var key in data[locale]) {
                if (data[locale].hasOwnProperty(key)) {
                  if (data[locale][key].value === null) {
                    missing_translations++
                  }
                }
              }
            }
          }

          if (missing_translations !== 0) {
            var counters = d.getElementsByClassName("translator-counter")
            var span = e("span")
            span.innerHTML = missing_translations

            for (var i = 0; i < counters.length; i++) {
              counters[i].appendChild(span)
            }
          }
        })

        for (var i = 0; i < elements.length; i++) {
          elements[i].addEventListener("click", function() { t.openModal() })
          elements[i].classList.add("translator-attention")
        }
      }, 2000)
    }
  }

  window.onload = function() {
    if (typeof Turbolinks !== 'undefined') {
      d.addEventListener("turbolinks:load", function() { main() })
    }

    main()
  }

  Translator.prototype.addOverlay = function() {
    self = this
    this.overlay.style.visibility = "visible"
    this.overlay.className += "Overlay"
    this.overlay.onclick = function (e) { if (e.target === this) self.close() }
    this.modal_close.onclick = function () { self.close() }
    d.onkeyup = function (e) { if (e.keyCode === 27) self.close() }
    d.body.appendChild(this.overlay)
  }

  // Closes the modal and removes the overlay.
  Translator.prototype.close = function() {
    d.onkeyup = null
    d.body.removeChild(this.overlay)
  }

  // Filters all rows based on the given value.
  Translator.prototype.search = function(value) {
    var regex = new RegExp(value, 'i')
    var rows = d.getElementById('TranslatorModalBody').querySelectorAll('.Table-row:not(.Table-header)')

    // Hide all rows where the value does not appear in the key or value.
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i]
      var key = row.querySelector('.Table-row-item').innerHTML
      var value = row.querySelector('textarea').value

      if (key.match(regex) || value.match(regex)) {
        row.removeAttribute('hidden')
      } else {
        row.setAttribute('hidden', 'hidden')
      }
    }
  }

  // Sends the translations to the backend.
  Translator.prototype.save = function() {
    var elements = d.getElementById('TranslatorModalBody').querySelectorAll('textarea')
    var disableds = 0

    // Disable all fields that have not been changed.
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i]
      var value = translations[element.getAttribute("data-locale")][element.getAttribute("data-key")].value
      var disable = value === element.value

      if (disable) {
        disableds += 1
        element.setAttribute('disabled', 'disabled')
      }
    }

    // Only post if at least one of the translations has been changed.
    if (elements.length !== disableds) {
      this.postForm("translator/translate", this.modal_body, function () {
        window.location.reload(true)
      })
    } else {
      this.close()
    }
  }

  Translator.prototype.searchField = function() {
    var self = this
    var field = e("input")
    field.type = "search"
    field.placeholder = "search..."
    field.className = "Modal-search"
    field.onkeyup = function() { self.search(field.value) }
    return field
  }

  Translator.prototype.saveButton = function() {
    var self = this
    var button = e("button")
    button.innerText = "Save"
    button.style = "padding: 1em; background-color: green; color: white; font-weight: bold; cursor: pointer;"
    button.onclick = function() { self.save() }
    return button
  }

  Translator.prototype.openModal = function() {
    this.getTranslations(function(data) { self.addTranslations(data) })
    this.overlay = e("div")
    this.modal = e("div")
    this.modal_close = e("div")
    this.addOverlay()
    this.addModal()
  }

  Translator.prototype.addModal = function() {
    this.modal_header = e("div")
    this.modal_body = e("form")
    this.modal_footer = e("div")
    this.modal.className = "Modal"
    this.modal_body.id = "TranslatorModalBody"
    this.modal_body.className += "Modal-body"
    this.modal_header.className += "Modal-header"
    this.modal_footer.className += "Modal-footer"

    this.modal_close.className += "Modal-close"
    this.modal_close.innerText = "X"
    this.modal_close.style = "color: red; font-weight: bold;"

    this.modal_header.appendChild(this.searchField())
    this.modal_header.appendChild(this.modal_close)
    this.modal_footer.appendChild(this.saveButton())
    this.modal.appendChild(this.modal_header)
    this.modal.appendChild(this.modal_body)
    this.modal.appendChild(this.modal_footer)
    this.overlay.appendChild(this.modal)
  }

  Translator.prototype.getTranslations = function(callback) {
    this.getJson("translator/translations", null, function(data) {
      this.translations = data
      callback(data)
    })
  }

  Translator.prototype.addTranslations = function(translations) {
    for (var locale in translations) {
      this.addTable(locale, translations[locale])
    }
  }

  Translator.prototype.addTable = function(locale, translations) {
    var h2 = e("h2")
    h2.innerText = "Translate: " + locale
    var table = e("div")
    table.className += "Table"

    var header = e("div")
    var key = e("div")
    var value = e("div")
    var options = e("div")
    header.className += "Table-row Table-header"
    key.className += "Table-row-item"
    value.className += "Table-row-item"
    options.className += "Table-row-item"
    key.innerText = "Key"
    value.innerText = "Translation"
    options.innerText = "Options"
    header.appendChild(key)
    header.appendChild(value)
    header.appendChild(options)
    table.appendChild(header)

    for (var prop in translations) {
      var row = e("div")
      var key = e("div")
      var value = e("div")
      var options = e("div")
      var input = e("textarea")

      row.className += "Table-row"
      key.className += "Table-row-item"
      value.className += "Table-row-item"
      options.className += "Table-row-item"

      key.innerText = prop
      input.name = "translations[" + locale + "][" + prop + "]"
      input.setAttribute("data-locale", locale)
      input.setAttribute("data-key", prop)

      // If a value is present insert in the input if not highlight the entire row.
      if (translations[prop].value) {
        input.value = translations[prop].value
      } else {
        row.className += " attention"
      }

      if (Object.getOwnPropertyNames(translations[prop].options).length > 0) {
        for (var option in translations[prop].options) {
          options.innerHTML += "%{" + option + "} = " + translations[prop].options[option] + "</br>"
        }
      }

      value.appendChild(input)
      row.appendChild(key)
      row.appendChild(value)
      row.appendChild(options)
      table.appendChild(row)
    }

    this.modal_body.appendChild(h2)
    this.modal_body.appendChild(table)
  }

  Translator.prototype.getJson = function(path, params, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open("GET", "/" + path + ".json" + this.objectToQuery(params))
    xhr.setRequestHeader("Content-Type", "application/vnd.api+json; charset=UTF-8")
    xhr.send()
  }

  Translator.prototype.postForm = function(path, form, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open("POST", "/" + path)
    xhr.setRequestHeader("X-CSRF-Token", this.csrfToken())
    xhr.send(new FormData(form))
  }

  Translator.prototype.postJson = function(path, params, callback) {
    var xhr = this.xhrJson(callback)
    xhr.open("POST", "/" + path + ".json")
    xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8")
    xhr.setRequestHeader("X-CSRF-Token", this.csrfToken())
    xhr.send(JSON.stringify(params))
  }

  // Looks for the csrf-token and returns it if found.
  Translator.prototype.csrfToken = function() {
    token = d.getElementsByName("csrf-token")
    if (token.length === 1) {
      return token[0].getAttribute("content")
    } else {
      window.alert("CSRF-token could not be found")
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
    var query = ""
    var key = ""

    for (key in params) {
      if (params[key]) {
        if (query !== "") {
          query += "&"
        } else {
          query += "?"
        }
        query += key + "=" + encodeURIComponent(params[key])
      }
    }
    return query
  }
})()
