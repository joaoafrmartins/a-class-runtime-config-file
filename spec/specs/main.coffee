describe 'AClassRuntimeConfigFile', () ->

  it 'before', () ->

    kosher.shell

    kosher.alias 'fixture', kosher.spec.fixtures.rc

    kosher.tmp = "rc"

    kosher.alias "rcfile", resolve kosher.tmp, "rcfile.json"

    """ { "hello": "world" } """.to kosher.rcfile

    expect(test("-f", kosher.rcfile)).to.be.ok

  describe 'properties', () ->

    describe 'runtimeConfig', () ->

      it 'should be able to read rcfile data', () ->

        kosher.alias 'instance', new kosher.fixture.A

          runtimeConfigFile: kosher.rcfile

          runtimeConfigFileNamespace: false

        kosher.instance.runtimeConfig.hello.should.eql "world"

      it 'should be used as a common object', () ->

        kosher.instance.runtimeConfig.test = "value"

        kosher.instance.runtimeConfig.test.should.eql "value"

      it 'should be persiste changes when set with true', () ->

        kosher.instance.runtimeConfig = true

        JSON.parse(cat(kosher.rcfile)).should.eql

          "hello": "world",

          "test": "value"

      it 'should namespace variables by default', () ->

        kosher.alias 'instance', new kosher.fixture.A

          runtimeConfigFile: kosher.rcfile

        kosher.instance.runtimeConfig.namespaced = "var"

        kosher.instance.runtimeConfig.should.eql

          "namespaced": "var"

        kosher.instance.runtimeConfig = true

        JSON.parse(cat(kosher.rcfile)).should.eql

          "hello": "world",

          "test": "value"

          "runtime-config":

            "namespaced": "var"

      it 'should allow custom namespaces', () ->

        kosher.alias 'instance', new kosher.fixture.A

          runtimeConfigFile: kosher.rcfile

          runtimeConfigFileNamespace: "custom"

        kosher.instance.runtimeConfig.customized = "namespace"

        kosher.instance.runtimeConfig = true

        JSON.parse(cat(kosher.rcfile)).should.eql

          "hello": "world",

          "test": "value"

          "runtime-config":

            "namespaced": "var"

          "custom":

            "customized": "namespace"

      it 'after', () ->

        kosher.tmp = null
