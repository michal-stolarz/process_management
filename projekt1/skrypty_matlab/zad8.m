%Michał Stolarz
%Zad nr 8

% Ciągłe ----------------------------------------

Numerator = [0 1 9 8];
Denominator = [1 12 -79 -990];
sys = tf(Numerator,Denominator) % transmitancja ciągła

% Dyskretne --------------------------------------

Ts = 0.25; % czas próbkowania
Tp= 0.25;
Ini = 0;
sysd = c2d(sys,Ts,'zoh') % transmitancja dyskretna, otrzymana przez ektrapolator zerowego rzędu

a_b = pole(sysd) % bieguny transmitancji dyskretnej
b_z = zero(sysd) % zera transmitancji dyskretnej

[num,den] = tfdata(sysd)

[A2,B2,C2,D2] = tf2ss(num{1},den{1}) %1 wariant metody bezpośredniej

% współczynniki dla 2 wariantu metody bezpośredniej
A3=A2.'
B3 = C2.'
C3 = B2.'


[b2,a2] = ss2tf(A3,B3,C3,D2) % przestrzń stanów dla drugiej metody

% Regulator
a=0.3
b=0.1
z1 = a + b*j
z2 = a - b*j

k=0.3
K = acker(A3,B3,[k z1 z2])
%K = acker(A3,B3,[k k k])
%obserwator
l1=0.6
l2=0.6
A3_11=A3(1,1)
A3_21=A3(2:3,1)
A3_22 = A3(2:3,2:3)
A3_12 = A3(1,2:3)
B3_1 = B3(1)
B3_2 = B3(2:3)
L = acker(A3_22',A3_12',[l1 l2])% obliczenie parametrów obserwatora
L=L'