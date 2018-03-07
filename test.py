import numpy as np
import cyexpokit
from scipy.sparse import coo_matrix
from scipy.linalg import expm

# rate matrix with rows as ancestors and columns as descendants
dense = np.array([[-1,1,0,0],
                  [0,-2,2,0],
                  [0,0,-3,3],
                  [0,0,4,-4]], dtype=np.double)

Q = coo_matrix(dense)
ia = Q.row+1
ja = Q.col+1
data = Q.data

sp = cyexpokit.SparseExpm(Q.shape[0])
sp.expm(ia, ja, data, 0, 1)
