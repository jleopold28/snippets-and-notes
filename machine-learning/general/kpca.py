import scipy.spatial.distance as dist
import scipy.linalg as linalg
import numpy as np


def rbf_kernel_pca(data, gamma, n_components):
    """
    rbf kernel pca implementation

    params -
    numpy ndarray data: shape = [n_samples, n_features]
    float gamma: tuning param of rbf kernel
    int n_components: num components to return

    returns -
    numpy ndarray projected data, list eigvals: shape = [n_samples, k_features]
    """

    # calc pairwise squared euclidean distances in MxN dataset
    sq_dists = dist.pdist(data, 'sqeuclidean')
    # convert pairwise distances into square matrix
    mat_sq_dists = dist.squareform(sq_dists)
    # compute symmetric kernel matrix
    k_mat = np.exp(-gamma * mat_sq_dists)
    # center kernel matrix
    flat = k_mat.shape[0]
    one_flat = np.ones((flat, flat)) / flat
    k_mat = (k_mat - one_flat.dot(k_mat) -
             k_mat.dot(one_flat) + one_flat.dot(k_mat).dot(one_flat))
    # obtain eigpairs from centered kernel matrix
    # scipy.eigh returns them sorted
    eigvals, eigvecs = linalg.eigh(k_mat)
    # collect top k eigvecs (projected samples, eigvals)
    # these are informally alphas and lambdas
    return (np.column_stack((eigvecs[:, -index]
                             for index in range(1, n_components + 1))),
            [eigvals[-index] for index in range(1, n_components + 1)])


def project_data(data_proj, data, gamma, alphas, lambdas):
    """project a data point"""
    pair_dist = np.array([(np.sum(data_proj - row)**2) for row in data])
    return np.exp(-gamma * pair_dist).dot(alphas / lambdas)
