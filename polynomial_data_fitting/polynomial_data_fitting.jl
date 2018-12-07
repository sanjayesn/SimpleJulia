
using Plots

# Example vectors for t and y = f(t)

t_vec = collect(1:0.1:9)

y_vec = [-45.1023, -40.733, -35.0169, -35.929, -31.3725, -27.6436,
    -25.1255, -20.028, -20.7196, -16.7401, -15.0204, -11.8489, -13.3749,
    -11.7127, -8.01923, -3.31351, -5.26084, -3.60641, -4.79639, -2.39263,
    3.60539, -1.3707, -0.186708, 6.85056, -2.26242, 0.470248, 0.101752,
    -0.506656, -0.408132, -6.67199, -0.519249, 1.04816, -0.00202571,
    8.79154, 2.92139, 5.74395, 2.72592, 2.88573, 3.83866, -2.56143,
    -2.33699, -1.82118, -5.10429, -0.397297, -0.28478, -0.829663,
    -3.53671, -5.07868, -1.57493, -4.43866, -4.01298, -4.11831,
    -7.08308, -6.92464, -2.68027, 0.373049, -4.93889, -1.88211,
    2.58014, -5.87993, -1.72377, 0.865834, 2.76258, 5.63751,
    0.431958, 6.05016, 10.1573, 10.3851, 5.56374, 9.77606, 
    11.8734, 19.282, 21.9524, 24.1106, 26.218, 29.7307, 25.4638, 31.0959, 
    41.1888, 37.9732, 50.1633]

scatter(t_vec, y_vec, label="Raw data")

# Outputs polynomial vector [1; t; t^2; ... t^(degree)] 
function poly_vec(t, degree)
    result = zeros(degree+1)
    
    result[1] = 1
    # Loop over degree and populate result
    for k = 1:degree
        result[k+1] = t^k
    end
    
    return result
end
;

# Generates estimate of kth degree polynomial with coefficient vector c
function gen_est(k, c)
    est = zeros(length(t_vec))
    
    # Form estimate vector for data
    for i = 1:length(est)
        est[i] = poly_vec(t_vec[i], k)' * c
    end
    
    return est
end
;

# Fits a kth degree polynomial using least squares
function poly_fit(k)
    c = zeros(k+1)
    B = zeros(length(t_vec), k+1)
    
    # Populate matrix whose rows are polynomial vectors for an input value
    for i = 1:length(t_vec)
        B[i, :] = poly_vec(t_vec[i], k)
    end
    
    return B \ y_vec
end
;

# Plot estimates of degrees 1-5

plt = scatter(t_vec, y_vec, label="Raw data", legend=:topleft)

for degree = 1:5
    c = poly_fit(degree)
    println(string("Coefficients, k=", degree, " "), c)
    plt = plot!(t_vec, gen_est(degree, c),
                label=string("Estimate, k=", degree))
end
display(plt)

# Compute mean square error (MSE) for each polynomial of degree 1-5 and plot

mse = zeros(5)

for degree = 1:5
    c = poly_fit(degree)
    mse[degree] = norm(gen_est(degree, c) - y_vec)^2
end

plt = plot([1:5], mse, label="MSE", legend=:topright, xlabel="Degree", ylabel="MSE")
display(plt)
