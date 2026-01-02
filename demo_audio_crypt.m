% Enregistrement (optionnel)
% system('sox -d audio.wav trim 0 10'); % ou utiliser Record_Article.txt adapté

% Chiffrement
encrypt_audio('audio.wav', 'crypty.wav', 'chokri nouar');

% Déchiffrement
decrypt_audio('crypty.wav', 'clair.wav', 'chokri nouar');

% Vérification
[y1, fs1] = audioread('audio.wav');
[y2, fs2] = audioread('clair.wav');
if isequal(int16(y1), int16(y2))
    disp('✅ Déchiffrement correct !');
else
    disp('❌ Erreur de déchiffrement');
end
