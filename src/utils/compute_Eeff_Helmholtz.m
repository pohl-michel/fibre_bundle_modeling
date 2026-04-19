function [ Eeff ] = compute_Eeff_Helmholtz( Eb1, Eb2, Et1, Et2, l1, l2, k1, k2, n)
%CALCUL_EEFF Summary of this function goes here
%   Cette fonction renvoie le module de Young effectif Eeff d'un ensemble
%   de n cellules en s�rie caract�ris�es par les valeurs Eb1, Eb2, Et1,
%   Et2, l1, l2, k1 et k2
%% CALCUL DE Aeff

lambda1 = sqrt((k1/Eb1)+(k1/Et1));
lambda2 = sqrt((k2/Eb2)+(k2/Et2));

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

for k=1:n
Aeff = A*Aeff;
end

%% CALCUL DE Eeff

B = zeros (4,4);
B(:,1) = Aeff(:,1);
B(:,3) = Aeff(:,3);
B(1,2) = -1;
B(3,4) = -1;

delta = 1;
DELTA = [0; delta; 0; delta];

X = B\DELTA;
l = l1+l2;

Eeff = (n*l/delta)*(X(2)+X(4));
end