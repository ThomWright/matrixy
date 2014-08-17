arrays = require '../src/arrays'

describe 'Array Functions', ->
  describe 'getNumOfColumns', ->
    it 'should return the correct number of columns', ->
      expect(arrays.getNumOfColumns [[1,2,3]] ).to.equal(3)
