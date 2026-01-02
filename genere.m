function keys = genere(F, pw)
% GENERE - Génère F paires de clés (int16) à partir de pw
% Utilise NMGM conforme à l'article IJNS 2019

[x, y, r] = initialization(pw);
n = length(pw);          % longueur en caractères (comme dans l'article)
M = floor(r * n);        % période transitoire

keys = zeros(F, 2, 'int16');
k = 1;
i = 0;

while k <= F
    % Carte NMGM
    x_next = 1 - y + abs(x);
    y_next = x + r * sin(y);
    x = x_next;
    y = y_next;
    
    if i >= M
        if mod(i, n) ~= 0
            % Extraire parties fractionnaires
            x_frac = x - floor(x);
            y_frac = y - floor(y);
            
            % Convertir en entiers 16 bits (comme utilisé dans les scripts audio)
            X = int16(floor(x_frac * 2^16));
            Y = int16(floor(y_frac * 2^16));
            
            keys(k, 1) = bitxor(X, Y);
            keys(k, 2) = bitxor(X + Y, X - Y);
            k = k + 1;
        else
            % Mise à jour de r
            r = mod((r + 1)^2, 2) + 2;
        end
    end
    i = i + 1;
end
end
