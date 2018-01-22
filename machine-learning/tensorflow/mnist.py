import tensorflow as tf

# construct nodes
NODE1 = tf.constant(3.0, dtype=tf.float32)
NODE2 = tf.constant(4.0)
print('NODE1, NODE2:', NODE1, NODE2)

# run nodes in session
SESS = tf.Session()
print('SESS.run(NODE1, NODE2):', SESS.run([NODE1, NODE2]))

# add combo node
NODE3 = tf.add(NODE1, NODE2)
print('NODE3:', NODE3)
print('SESS.run(NODE3):', SESS.run(NODE3))

# add placeholders and a node for adding
A = tf.placeholder(tf.float32)
B = tf.placeholder(tf.float32)
ADDER_NODE = A + B
print(SESS.run(ADDER_NODE, {A: 3, B: 4.5}))
print(SESS.run(ADDER_NODE, {A: [1, 3], B: [2, 4]}))

# add a node for tripling
ADD_AND_TRIPLE = ADDER_NODE * 3
print(SESS.run(ADD_AND_TRIPLE, {A: 3, B: 4.5}))

# add variables for linear model
SLOPE = tf.Variable([.3], dtype=tf.float32)
INITIAL = tf.Variable([-.3], dtype=tf.float32)
VAL = tf.placeholder(tf.float32)
LINEAR = SLOPE * VAL + INITIAL

# initialize variables
INIT = tf.global_variables_initializer()
SESS.run(INIT)
print(SESS.run(LINEAR, {VAL: [1, 2, 3, 4]}))

# linear regression loss model
RESULT = tf.placeholder(tf.float32)
DELTAS_SQR = tf.square(LINEAR - RESULT)
LOSS = tf.reduce_sum(DELTAS_SQR)
print(SESS.run(LOSS, {VAL: [1, 2, 3, 4], RESULT: [0, -1, -2, -3]}))

# change slope and initial
TRUE_SLOPE = tf.assign(SLOPE, [-1.])
TRUE_INITIAL = tf.assign(INITIAL, [1.])
SESS.run([TRUE_SLOPE, TRUE_INITIAL])
print(SESS.run(LOSS, {VAL: [1, 2, 3, 4], RESULT: [0, -1, -2, -3]}))

# add gradient descent optimizer trainer
OPTIMIZER = tf.train.GradientDescentOptimizer(0.01)
TRAIN = OPTIMIZER.minimize(LOSS)

# run trainer
SESS.run(INIT)
for i in range(1000):
    SESS.run(TRAIN, {VAL: [1, 2, 3, 4], RESULT: [0, -1, -2, -3]})
print(SESS.run([SLOPE, INITIAL]))

# evaluate accuracy
CURR_SLOPE, CURR_INITIAL, CURR_LOSS = SESS.run([SLOPE, INITIAL, LOSS], {VAL: [1, 2, 3, 4], RESULT: [0, -1, -2, -3]})
print("Slope: %s Initial: %s Loss: %s" % (CURR_SLOPE, CURR_INITIAL, CURR_LOSS))
