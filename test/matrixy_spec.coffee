matrixy           = require '../src/matrixy'
{createMatrix}    = require '../src/matrixy'

describe 'matrixy', ->
  describe 'createMatrix', ->
    it 'should take an array of arrays and return a Function', ->
      expect(createMatrix [[5]]).to.be.a 'Function'

    it 'should throw an exception if the arrays are empty'

    it 'should throw an exception for a single-dimension array'

