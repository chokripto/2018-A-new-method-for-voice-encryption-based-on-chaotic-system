function [x0, y0, r0] = initialization(pw)
% INITIALIZATION - Calcule x0, y0, r0 à partir du mot de passe pw
% Conforme à l'Algorithme 1 de l'article IJNS 2019

if isempty(pw)
    error('Mot de passe vide');
end

% Conversion en bits ASCII
pw_bytes = unicode2native(pw, 'ASCII');
n = length(pw_bytes) * 8;  % nombre total de bits
Pw = zeros(1, n);
for i = 1:length(pw_bytes)
    bits = dec2bin(pw_bytes(i), 8) - '0';
    Pw((i-1)*8 + 1:i*8) = bits;
end

% Initialisation du pointeur Z
Z = floor(n / 4);
A = 0; B = 0; C = 0;

% Extraire 64 bits via le pointeur linéaire congruentiel
for i = 0:63
    Z = mod((n^2 + 1) * Z + 1, n);
    if Z == 0, Z = n; end  % MATLAB indexe à partir de 1
    bit_val = Pw(Z);
    
    % Selon l'article : A, B, C reçoivent TOUS le même bit à chaque itération
    % (le pseudo-code est ambigu mais les formules sont identiques)
    A = A + bit_val * 2^(63 - i);
    B = B + bit_val * 2^(63 - i);
    C = C + bit_val * 2^(63 - i);
end

% Correction selon l'article : on utilise 192 bits distincts (plus réaliste)
% Réinitialisation du pointeur
Z = floor(n / 4);
A = 0; B = 0; C = 0;
for i = 0:63
    Z = mod((n^2 + 1) * Z + 1, n); if Z == 0, Z = n; end; A = A + Pw(Z) * 2^(63 - i);
end
for i = 0:63
    Z = mod((n^2 + 1) * Z + 1, n); if Z == 0, Z = n; end; B = B + Pw(Z) * 2^(63 - i);
end
for i = 0:63
    Z = mod((n^2 + 1) * Z + 1, n); if Z == 0, Z = n; end; C = C + Pw(Z) * 2^(63 - i);
end

x0 = A / 2^63;
y0 = B / 2^63;
r0 = C / 2^63 + 2;
end
