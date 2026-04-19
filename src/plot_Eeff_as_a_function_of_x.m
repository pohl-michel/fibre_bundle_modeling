%% DESCRIPTION DU FICHIER
% Ce fichier .m renvoie la courbe Eeff/Ebeta en fonction de X dans le cas
% d'une fibre de la forme suivante :
%
%    ---Ealpha--/---Ebeta---// ---Ealpha--/---Ebeta---//  ...
%          k          k             k           k
%    ---Ebeta---/---Ealpha--//---Ebeta---/---Ealpha--//   ...
%
% On se contente du cas de Helmholtz.
% Les diff�rentes courbes correspondent aux diff�rentes valeurs de n.
% Einfini est �galement trac�.

%% PARAMETRES

l=1;
% Attention ici l=l1=l2
% ne pas confondre avec l'autre programme o� l'on avait pos� l=l1+l2;

K=[1,10,100];

E_beta = 1;

Xmin = 1;
Xmax = 10;
points = 100;
% nombres de points dans l'intervalle [0, Xmax] sur lesquels on trace 

N = [1,2,5];
% N est le tableau des valeurs de n pour lesquelles on trace les courbes.


%% CALCUL DU TABLEAU DES Eeff

longueurN = 1+length(N);
longueurK = length(K);
Eeff = zeros(points,longueurN,longueurK);
% Les colonnes correspondent chacune � une valeur de n
% (la derni�re colonne correspond � n = + infini)
% les lignes correspondent � une valeur de X particuli�re.

x = linspace (Xmin, Xmax, points);

% Valeurs de n enti�res
for k=1:longueurK
    for j=1:(longueurN-1)
        for i=1:points
            Eeff(i,j,k)= compute_Eeff_Helmholtz_simple_case( K(k), l, E_beta, x(i), N(j));
        end
    end 
end

% n infini
for k=1:longueurK
    for i=1:points
        E_alpha = x(i)*E_beta;
        Eeff(i,longueurN,k) = compute_Eeff_infinite( E_beta, E_alpha, E_alpha, E_beta, l, l, K(k), K(k) );
    end
end
% k = 0
y = @(u) 4./(1+1./u) ;
E_y = y(x);

z = @(u) 1+x ;
E_z = z(x);

%% GRAPHE

figure(3)
hold on

for k=1:longueurK
    for j=1:(longueurN-1)
        plot (x, Eeff(:,j,k));
    end
    plot (x, Eeff(:,longueurN,k), 'k- ')
end

% Cas k=0
plot(x,E_y, 'r- ');
plot(x,E_z, 'r- ');

hold off
