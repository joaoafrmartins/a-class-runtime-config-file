{ writeFileSync } = require 'fs'

{ resolve } = require 'path'

Mixto = require 'mixto'

class AClassRuntimeConfigFile extends Mixto

  constructor: (@options={}) ->

    super @options

  extended: () ->

    @options ?= {}

    @options.runtimeConfigFileReadOnly ?= false

    @options.runtimeConfigFileNamespace ?= "runtime-config"

    @options.runtimeConfigFile ?= resolve process.cwd(), "package"

    namespace = null

    runtimeConfig = null

    readonly = @options.runtimeConfigFileReadOnly

    Object.defineProperty @, "runtimeConfig",

      writeable: false

      get: () ->

        if runtimeConfig is null

          file = @options.runtimeConfigFile

          runtimeConfig = require file.replace /\.[a-z]+/, ''

          if namespace = @options.runtimeConfigFileNamespace

            runtimeConfig[namespace] ?= {}

        if namespace then return runtimeConfig[namespace]

        return runtimeConfig

      set: (write) ->

        if readonly then return false

        if write is true

          file = @options.runtimeConfigFile

          writeFileSync file, JSON.stringify runtimeConfig, null, 2

          return true

        return false

module.exports = AClassRuntimeConfigFile
