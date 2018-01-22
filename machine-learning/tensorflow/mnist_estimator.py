import numpy as np
import tensorflow as tf

# declare feature column array
FEATURE_COLUMNS = [tf.feature_column.numeric_column('VAL', shape=[1])]
# initialize estimator
ESTIMATOR = tf.estimator.LinearRegressor(feature_columns=FEATURE_COLUMNS)

# setup training and eval data sets
VAL_TRAIN = np.array([1., 2., 3., 4.])
TRUE_TRAIN = np.array([0., -1., -2., -3.])
VAL_EVAL = np.array([2., 5., 8., 1.])
TRUE_EVAL = np.array([-1.01, -4.1, -7., 0.])

# setup input functions
input_fn = tf.estimator.inputs.numpy_input_fn({'VAL': VAL_TRAIN}, TRUE_TRAIN, batch_size=4, num_epochs=None, shuffle=True)
train_input_fn = tf.estimator.inputs.numpy_input_fn({'VAL': VAL_TRAIN}, TRUE_TRAIN, batch_size=4, num_epochs=1000, shuffle=False)
eval_input_fn = tf.estimator.inputs.numpy_input_fn({'VAL': VAL_EVAL}, TRUE_EVAL, batch_size=4, num_epochs=1000, shuffle=False)

# thousand training steps
ESTIMATOR.train(input_fn=input_fn, steps=1000)

# estimate training and evaluation data loss
train_metrics = ESTIMATOR.evaluate(input_fn=train_input_fn)
eval_metrics = ESTIMATOR.evaluate(input_fn=eval_input_fn)
print("Train Metrics: %r" % train_metrics)
print("Eval Metrics: %r" % eval_metrics)
