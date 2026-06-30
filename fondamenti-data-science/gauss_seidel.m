function x = gauss_seidel(A, b, tol, max_iter)
    % Metodo iterativo di Gauss-Seidel per risolvere Ax = b
    % Input:
    %   A        - Matrice dei coefficienti (deve essere a diagonale dominante o SPD)
    %   b        - Vettore dei termini noti
    %   tol      - Tolleranza per il criterio di arresto (default: 1e-6)
    %   max_iter - Numero massimo di iterazioni (default: 100)
    % Output:
    %   x        - Soluzione approssimata del sistema Ax = b

    % Controllo input
    if nargin < 3
        tol = 1e-6;
    end
    if nargin < 4
        max_iter = 100;
    end

    % Dimensione del sistema
    n = length(b);
    
    % Inizializzazione della soluzione con zeri
    x = zeros(n, 1);
    
    % Iterazione di Gauss-Seidel
    for k = 1:max_iter
        x_old = x; % Salviamo la soluzione precedente
        
        for i = 1:n
            sum1 = A(i, 1:i-1) * x(1:i-1); % Somma della parte gia' aggiornata
            sum2 = A(i, i+1:n) * x_old(i+1:n); % Somma della parte ancora vecchia
            x(i) = (b(i) - sum1 - sum2) / A(i, i); % Aggiornamento di Gauss-Seidel
        end
        
        % Controllo del criterio di arresto
        if norm(x - x_old, inf) < tol
            fprintf('Convergenza raggiunta dopo %d iterazioni.\n', k);
            return;
        end
    end

    fprintf('Attenzione: Numero massimo di iterazioni raggiunto senza convergenza.\n');
end
