###*
 * @module functional_utils
###

# @private
# Internal reference to module.exports.
t = @

# @param f [Function]
# @param g [Function]
@compose = (f, g) ->
  ->
    args = Array::slice.call arguments
    f g.apply @, args

@createLiftFunctions = ({wrap, unwrap} ) ->
  # (x -> y) -> z -> y
  liftInput: (f) ->
    (i) ->
      f unwrap i

  # (x -> x) -> y -> y
  lift1: (f1) ->
    (i) ->
      wrap \
        f1 unwrap(i)

  # (x, x -> x) -> (y, y -> y)
  lift2: (f1) ->
    (i1, i2) ->
      wrap \
        f1 unwrap(i1), unwrap(i2)

  # (x, x -> x) -> y -> y -> y
  lift2Infix: (f2) ->
    (i2) ->
      (i1) ->
        wrap \
          f2 unwrap(i1), unwrap(i2)

  liftAllOutputs: (f) ->
    (i) ->
      outputs = f unwrap i
      wrappedOutputs = {}
      for k, v of outputs
        wrappedOutputs[k] = wrap v
      wrappedOutputs