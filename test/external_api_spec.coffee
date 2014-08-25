index = require '../src/index'

describe 'API', ->
  it 'should have a Matrixy entry', ->
    expect(index.Matrixy).to.exist

  it 'should have an Arrays entry', ->
    expect(index.Arrays).to.exist