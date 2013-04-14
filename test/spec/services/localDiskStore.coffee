'use strict'

describe 'Service: localDiskStore', () ->

  # load the service's module
  beforeEach module 'docularApp'

  # instantiate service
  localDiskStore = {}
  beforeEach inject (_localDiskStore_) ->
    localDiskStore = _localDiskStore_

  it 'should do something', () ->
    expect(!!localDiskStore).toBe true;
