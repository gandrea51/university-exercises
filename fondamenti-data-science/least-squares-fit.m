function [x_line, x_parabola] = least_squares_fit(X, Y)
    % Fit di una retta e di una parabola ai dati (X, Y) usando il metodo dei minimi quadrati
    
    % Restituisce i coefficienti della retta e della parabola
    
    % Controlla che X e Y abbiano la stessa dimensione
    if length(X) ~= length(Y)
        error('X e Y devono avere la stessa lunghezza.');
    end
    
    % Matrice per il fit lineare (y = a*x + b)
    A_line = [X(:), ones(length(X), 1)];
    x_line=(A_line'*A_line)^-1*A_line'*Y(:);
    % x_line = A_line \ Y(:);
    
    % Matrice per il fit quadratico (y = a*x^2 + b*x + c)
    A_parabola = [X(:).^2, X(:), ones(length(X), 1)];
    x_parabola=(A_parabola'*A_parabola)^-1*A_parabola'*Y(:);
    % x_parabola = A_parabola \ Y(:);

    % Matrice per il fit quadratico (y = a*x^2 + b*x + c)
    A_p = [X(:).^3,X(:).^2, X(:), ones(length(X), 1)];
    
    x_p=(A_p'*A_p)^-1*A_p'*Y(:);

    % Grafico dei dati e delle curve di best fit
    figure;
    scatter(X, Y, 'filled'); hold on;
    
    % Genera punti per il disegno
    x_fit = linspace(min(X), max(X), 100);
    y_line = x_line(1) * x_fit + x_line(2);
    y_parabola = x_parabola(1) * x_fit.^2 + x_parabola(2) * x_fit + x_parabola(3);
    y_p = x_p(1) * x_fit.^3+x_p(2) * x_fit.^2 + x_p(3) * x_fit + x_p(4);
    
    % Disegna le curve di best fit
    plot(x_fit, y_line, 'r', 'LineWidth', 2, 'DisplayName', 'Retta di best fit');
    plot(x_fit, y_parabola, 'b', 'LineWidth', 2, 'DisplayName', 'Parabola di best fit');
    plot(x_fit, y_p, 'k', 'LineWidth', 2, 'DisplayName', 'Polinomio di best fit');    
    legend;
    xlabel('X'); ylabel('Y');
    title('Minimi Quadrati: Retta e Parabola di Best Fit');
    grid on;
    hold off;
end