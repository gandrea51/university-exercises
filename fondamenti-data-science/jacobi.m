function x = jacobi(A, b, tol, max_iter)
    % Metodo iterativo di Jacobi per risolvere Ax = b
    % Input:
    %   A        - Matrice dei coefficienti (deve essere diagonale dominante)
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
    
    % Estrazione della diagonale e del resto della matrice
    D = diag(A);  % Estrazione degli elementi diagonali
    R = A - diag(D);  % Matrice dei restanti elementi
    
    % Iterazione di Jacobi
    for k = 1:max_iter
        x_new = (b - R * x) ./ D;  % Formula di Jacobi
        
        % Controllo del criterio di arresto
        if norm(x_new - x, inf) < tol
            fprintf('Convergenza raggiunta dopo %d iterazioni.\n', k);
            x = x_new;
            return;
        end
        
        % Aggiornamento della soluzione
        x = x_new;
    end

    fprintf('Attenzione: Numero massimo di iterazioni raggiunto senza convergenza.\n');
end

