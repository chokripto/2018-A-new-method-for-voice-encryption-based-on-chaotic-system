function decrypt_audio(input_file, output_file, password)
% Déchiffrement audio – inverse exact de encrypt_audio

[yc, fs] = audioread(input_file, 'native');
size_ya = size(yc, 1);

ks = genere(3 * size_ya, password);
yc = int16(yc);

yc2 = zeros(size_ya, 2, 'int16');
yc1 = zeros(size_ya, 2, 'int16');
ya  = zeros(size_ya, 2, 'int16');

for k = 1:size_ya
    % Étape 3 inversée
    yc2(k,1) = bitxor(yc(k,1), ks(2*size_ya + k,1));
    yc2(k,2) = bitxor(yc(k,2), ks(2*size_ya + k,2));
    % Étape 2 inversée
    yc1(k,2) = bitxor(yc2(k,1), ks(size_ya + k,1));
    yc1(k,1) = bitxor(yc2(k,2), ks(size_ya + k,2));
    % Étape 1 inversée
    ya(k,1) = bitxor(yc1(k,1), ks(k,1));
    ya(k,2) = bitxor(yc1(k,2), ks(k,2));
end

audiowrite(output_file, ya, fs);
disp(['Audio déchiffré enregistré : ', output_file]);
end
