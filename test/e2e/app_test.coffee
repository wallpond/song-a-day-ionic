TestHelper = require './test_helper'

describe 'app init', ->

  it 'should land on the songs page', ->
    expect(browser.getLocationAbsUrl()).toMatch '/tab/songs'
