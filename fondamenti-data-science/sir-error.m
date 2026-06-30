function err = sir_error(params, t_data, S_data, I_data, R_data, y0)
    beta = params(1);
    gamma = params(2);

    sir_ode = @(t, y) [
        -beta * y(1) * y(2);
         beta * y(1) * y(2) - gamma * y(2);
         gamma * y(2)
    ];

    [~, y] = ode45(sir_ode, t_data, y0);

    % Calcolo errore quadratico totale
    err = sum((y(:,1) - S_data).^2 + (y(:,2) - I_data).^2 + (y(:,3) - R_data).^2);
end