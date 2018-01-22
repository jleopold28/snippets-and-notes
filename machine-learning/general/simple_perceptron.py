import numpy as np


class Perceptron(object):
    """Perceptron classifier

    params
    float eta: learning rate between 0.0 and 1.0
    int n_iter: passes over the training dataset

    attrs
    array[int] weights: weights after fitting
    array[int] errors: number of misclassifications in epoch
    """

    def __init__(self, eta=0.01, n_iter=10):
        self.eta = eta
        self.n_iter = n_iter
        self.errors = []

    def fit(self, train_vec, target_vec):
        """fit training data"""
        self.weights = np.zeros(1 + train_vec.shape[1])

        # execute training epoch
        for _ in range(self.n_iter):
            num_errors = 0
            for train_elem, target_elem in zip(train_vec, target_vec):
                # attempt classification
                update = self.eta * (target_elem - self.predict(train_elem))
                # adjust weights based on accuracy of classification
                self.weights[1:] += update * train_elem
                self.weights[0] += update
                # increment number of errors if inaccurate
                num_errors += int(update != 0.0)
            # track number of errors for this epoch
            self.errors.append(num_errors)
        return self

    def net_input(self, train_vec):
        """calculate net input"""
        return np.dot(train_vec, self.weights[1:] + self.weights[0])

    def predict(self, train_vec):
        """return class label after unit step"""
        return np.where(self.net_input(train_vec) >= 0.0, 1, -1)
