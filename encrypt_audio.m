function encrypt_audio(input_file, output_file, password)
% Chiffrement audio conforme à Encryption_Article.txt (corrigé)

[ya, fs] = audioread(input_file, 'native');
size_ya = size(ya, 1);

% Générer 3*size_ya clés (2 colonnes)
ks = genere(3 * size_ya, password);

% Conversion en int16 (si nécessaire)
ya = int16(ya);

% Chiffrement en 3 étapes
yc1 = zeros(size_ya, 2, 'int16');
yc2 = zeros(size_ya, 2, 'int16');
yc  = zeros(size_ya, 2, 'int16');

for k = 1:size_ya
    % Étape 1
    yc1(k,1) = bitxor(ya(k,1), ks(k,1));
    yc1(k,2) = bitxor(ya(k,2), ks(k,2));
    % Étape 2
    yc2(k,1) = bitxor(yc1(k,2), ks(size_ya + k,1));
    yc2(k,2) = bitxor(yc1(k,1), ks(size_ya + k,2));
    % Étape 3
    yc(k,1) = bitxor(yc2(k,1), ks(2*size_ya + k,1));
    yc(k,2) = bitxor(yc2(k,2), ks(2*size_ya + k,2));
end

audiowrite(output_file, yc, fs);
disp(['Audio chiffré enregistré : ', output_file]);
end
