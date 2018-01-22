import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap


def plot_decision_regions(train_vec, target_vec, classifier, resolution=0.02):
    """plot decision boundaries for classifier"""

    # setup marker generator and color map
    markers = ('s', 'x', 'o', '^', 'v')
    colors = ('red', 'blue', 'lightgreen', 'gray', 'cyan')
    cmap = ListedColormap(colors[:len(np.unique(target_vec))])

    # create grid arrays for training data
    elem1_min, elem1_max = train_vec[:, 0].min() - 1, train_vec[:, 0].max() + 1
    elem2_min, elem2_max = train_vec[:, 1].min() - 1, train_vec[:, 1].max() + 1
    train_grid1, train_grid2 = np.meshgrid(np.arange(elem1_min,
                                                     elem1_max,
                                                     resolution),
                                           np.arange(elem2_min,
                                                     elem2_max,
                                                     resolution))
    # determine classification labels and flatten grids
    labels = classifier.predict(np.array([train_grid1.ravel(),
                                          train_grid2.ravel()]).T)
    labels = labels.reshape(train_grid1.shape)
    # draw contour plot
    plt.contourf(train_grid1, train_grid2, labels, alpha=0.4, cmap=cmap)
    plt.xlim(train_grid1.min(), train_grid1.max())
    plt.ylim(train_grid2.min(), train_grid2.max())
    # plot decision surface
    for elem_id, class_label in enumerate(np.unique(target_vec)):
        plt.scatter(x=train_vec[target_vec == class_label, 0],
                    y=train_vec[target_vec == class_label, 1],
                    alpha=0.8,
                    c=cmap(elem_id),
                    marker=markers[elem_id],
                    label=class_label)
