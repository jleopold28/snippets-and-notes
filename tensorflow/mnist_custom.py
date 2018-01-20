import numpy as np
import tensorflow as tf


# define a linear model function for the estimator
def model_fn(features, labels, mode):
    # variable initialization: y = mx + b
    slope = tf.get_variable('slope', [1], dtype=tf.float64)
    initial = tf.get_variable('initial', [1], dtype=tf.float64)
    result = slope * features['val'] + initial
    # loss sub graph
    loss = tf.reduce_sum(tf.square(result - labels))
    # training sub graph
    global_step = tf.train.get_global_step()
    optimizer = tf.train.GradientDescentOptimizer(0.01)
    train = tf.group(optimizer.minimize(loss),
                     tf.assign_add(global_step, 1))
    # EstimatorSpec connects subgraphs to appropriate functionality
    return tf.estimator.EstimatorSpec(
        mode=mode,
        predictions=result,
        loss=loss,
        train_op=train)


# setup estimator using linear model defined above
ESTIMATOR = tf.estimator.Estimator(model_fn=model_fn)
# define data sets
VAL_TRAIN = np.array([1., 2., 3., 4.])
TRUE_TRAIN = np.array([0., -1., -2., -3.])
VAL_EVAL = np.array([2., 5., 8., 1.])
TRUE_EVAL = np.array([-1.01, -4.1, -7., 0.])
# setup input functions
input_fn = tf.estimator.inputs.numpy_input_fn({'VAL': VAL_TRAIN}, TRUE_TRAIN, batch_size=4, num_epochs=None, shuffle=True)
train_input_fn = tf.estimator.inputs.numpy_input_fn({'VAL': VAL_TRAIN}, TRUE_TRAIN, batch_size=4, num_epochs=1000, shuffle=False)
eval_input_fn = tf.estimator.inputs.numpy_input_fn({'VAL': VAL_EVAL}, TRUE_EVAL, batch_size=4, num_epochs=1000, shuffle=False)
# estimate training and evaluation data loss
train_metrics = ESTIMATOR.evaluate(input_fn=train_input_fn)
eval_metrics = ESTIMATOR.evaluate(input_fn=eval_input_fn)
print("Train Metrics: %r" % train_metrics)
print("Eval Metrics: %r" % eval_metrics)
