import numpy as np


class AdalineGD(object):
    """Adaptive Linear Neuron classifier

    params
    float eta: learning rate between 0.0 and 1.0
    int n_iter: passes over the training dataset

    attrs
    array[int] weights: weights after fitting
    array[int] cost: sum of squared errors in epoch
    bool shuffle: whether to shuffle data per epoch
    rdm_state: set random state for shuffle and weight init
    """

    def __init__(self, eta=0.01, n_iter=50, shuffle=True,
                 rdm_state=None, stochastic=False):
        self.eta = eta
        self.n_iter = n_iter
        self.cost = []
        self.do_shuffle = shuffle
        self.rdm_state = rdm_state
        self.weight_init = False
        self.stochastic = stochastic

    def fit(self, train_vec, target_vec):
        """fit training data"""
        self.initialize_weights(train_vec.shape[1])

        for _ in range(self.n_iter):
            if self.stochastic:
                # randomly permute training and target data
                if self.do_shuffle:
                    train_vec, target_vec = self.shuffle(train_vec, target_vec)
                cost = []
                # classify and adjust weights based on accuracy
                # calculate gradient descent
                for elem, target in zip(train_vec, target_vec):
                    # determine unit cost based on accuracy
                    cost.append(self.update_weights(elem, target))
                # determine and track epoch cost
                avg_cost = sum(cost) / len(target_vec)
                self.cost.append(avg_cost)
            else:
                output = self.net_input(train_vec)
                # alternatively net_input = self.net_input(train_vec) and
                # output = self.activation(net_input), but the activation
                # method is an identity function
                errors = (target_vec - output)
                # classify and adjust weights based on accuracy
                # calculate gradient descent
                self.weights[1:] += self.eta * train_vec.T.dot(errors)
                self.weights[0] += self.eta * errors.sum()
                # calculate cost (sum of squared deltas)
                cost = (errors**2).sum() / 2.0
                # track cost for this epoch
                self.cost.append(cost)
        return self

    def partial_fit(self, train_vec, target_vec):
        """fit training data without weight re-init"""
        if not self.weight_init:
            self.initialize_weights(train_vec.shape[1])
        # reformat data before updating weights if necessary
        if target_vec.ravel().shape[0] > 1:
            for elem, target in zip(train_vec, target_vec):
                self.update_weights(elem, target)
        else:
            self.update_weights(train_vec, target_vec)
        return self

    def shuffle(self, train_vec, target_vec):
        """shuffle training data"""
        rdm = np.random.permutation(len(target_vec))
        return train_vec[rdm], target_vec[rdm]

    def initialize_weights(self, slope):
        """initialize weights to zero"""
        self.weights = np.zeros(1 + slope)
        self.weight_init = True

    def update_weights(self, elem, target):
        """apply adaline learning rule to update weights"""
        output = self.net_input(elem)
        error = target - output
        self.weights[1:] += self.eta * elem.dot(error)
        self.weights[0] += self.eta * error
        cost = 0.5 * error**2
        return cost

    def net_input(self, train_vec):
        """calculate net input"""
        return np.dot(train_vec, self.weights[1:] + self.weights[0])

    def activation(self, train_vec):
        """compute linear activation"""
        return self.net_input(train_vec)

    def predict(self, train_vec):
        """return class label after unit step (unnecessary)"""
        return np.where(self.activation(train_vec) >= 0.0, 1, -1)
