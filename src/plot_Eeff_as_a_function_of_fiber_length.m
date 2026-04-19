function [ Eeff ] = plot_Eeff_as_a_function_of_fiber_length
%% DESCRIPTION DU FICHIER
% Ce fichier .m calcule les modules de Young effectifs associ�s � uns
% structure cellulaire de param�tres Eb1, Eb2, Et1, Et2, l1, l2, k1, k2
% compos�e de n cellules. Les r�sultats sont affich�s sous la forme d'un
% graphe Eeff en fonction de n


%% PARAMETRES
% � modifier selon chaque graphe

% Modules d'Young en Pascals
Eb1 = 1; 
Eb2 = 5;
Et1 = 5;
Et2 = 1;

% Longueurs en m�tres
l1 = 1;
l2 = 1;

% Coefficients d'interaction �lastiques en N.m^-4
k1 = 1.5;
k2 = 1.5;

% Nombre de cellules
n = 11;


%% FONCTIONS AUXILIAIRES

l = l1+l2;
lambda1 = sqrt((k1/Eb1)+(k1/Et1));
lambda2 = sqrt((k2/Eb2)+(k2/Et2));

Eeff= zeros(n,3);
% La matrice Eff contient les valeurs qui vont �tre trac�es :
% la ligne k correspond � la cellule k
% la colonne 1 correspond au cas de Helmholtz (delta impos�)
% la colonne 2 correspond au cas de Gibbs (t1 impos�)
% la colonne 3 correspond � E infini

function M1 = M1(x)
    M1 = zeros (4,4);
    M1(1,2) = Et1;
    M1(1,3) = -Et1*lambda1*exp(-lambda1*x);
    M1(1,4) = Et1*lambda1*exp(lambda1*x);
    M1(2,1) = 1;
    M1(2,2) = x;
    M1(2,3) = exp(-lambda1*x);
    M1(2,4) = exp(lambda1*x);
    M1(3,2) = Eb1;
    M1(3,3) = Et1*lambda1*exp(-lambda1*x);
    M1(3,4) = -Et1*lambda1*exp(lambda1*x);
    M1(4,1) = 1;
    M1(4,2) = x;
    M1(4,3) = -(Et1/Eb1)*exp(-lambda1*x);
    M1(4,4) = -(Et1/Eb1)*exp(lambda1*x);
end
function M2 = M2(x)
    M2 = zeros (4,4);
    M2(1,2) = Et2;
    M2(1,3) = -Et2*lambda2*exp(-lambda2*x);
    M2(1,4) = Et2*lambda2*exp(lambda2*x);
    M2(2,1) = 1;
    M2(2,2) = x;
    M2(2,3) = exp(-lambda2*x);
    M2(2,4) = exp(lambda2*x);
    M2(3,2) = Eb2;
    M2(3,3) = Et2*lambda2*exp(-lambda2*x);
    M2(3,4) = -Et2*lambda2*exp(lambda2*x);
    M2(4,1) = 1;
    M2(4,2) = x;
    M2(4,3) = -(Et2/Eb2)*exp(-lambda2*x);
    M2(4,4) = -(Et2/Eb2)*exp(lambda2*x);    
end

A = M2(l2)*inv(M2(0))*M1(l1)*inv(M1(0));
Aeff = eye(4);

% Cas de Helmholtz
B = zeros (4,4);
B(1,2) = -1;
B(3,4) = -1;

delta = 1;
DELTA = [0; delta; 0; delta];

% Cas de Gibbs
C = zeros (4,4);
C(2,2) = -1;
C(4,4) = -1;

t_imp = 1;
T = [t_imp; 0; t_imp; 0];

%% CALCUL DU tableau des Eeff pour les valeurs de Helmholtz et Gibbs 

% Cas de Helmholtz et de Gibbs

for k=1:n
    
    Aeff = A*Aeff;
    
    % Cas de Helmholtz (1�re ligne) 
    B(:,1) = Aeff(:,1);
    B(:,3) = Aeff(:,3);
    X = B\DELTA;
    Eeff(k,1) = (k*l/delta)*(X(2)+X(4));
    
    % Cas de Gibbs (2�me ligne)

    C(:,1) = Aeff(:,1);
    C(:,3) = Aeff(:,3);
    X = C\T;
    Eeff(k,2) = (4*k*l*t_imp)/(X(2)+X(4));
    
end

% Eeff_infini

Eeff_infini = compute_Eeff_infinite( Eb1, Eb2, Et1, Et2, l1, l2, k1, k2 );

for k=1:n
    Eeff(k,3) = Eeff_infini;
end

%% GRAPHE 

hold on
figure(1)
plot (Eeff(:,1), 'ro-');
plot (Eeff(:,2), 'bo-');
plot (Eeff(:,3), 'k- ');
hold off

end