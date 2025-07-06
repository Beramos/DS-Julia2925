import numpy as np

def gradient_descent(P, q, x0,
            alpha=0.01, beta=0.8, maxiter=1000, eps=1e-5):
    x = np.copy(x0)
    nabla_f = lambda x : P.dot(x) + q
    Dx = nabla_f(x)
    for iter in range(maxiter):
        x += alpha * Dx
        Dx = beta * Dx - (1-beta) * nabla_f(x)
        if np.linalg.norm(Dx) < eps:
            break
    return x

P = np.array([[10, -1, 0],
              [-1, 1, 0],
              [0, 0, 5]])

q = np.array([0, -10, 20])

x0 = np.zeros(3)

gradient_descent(P, q, x0)


# %timeit gradient_descent(P, q, x0)
