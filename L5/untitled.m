% ======Вхідні параметри ==========
V=126;  T1=4;  T2=6;  q=0.3;  T3=0.8;  K1=0.3;  K2=0.2;  Un=100;  % задані параметри згідно варіанту
K=11; % параметр K - який будемо змінювати в процесі виконання роботи 
% =================================

clc; % очистити екран


Ts = 0.1* (T1 + T2 + T3);
disp (['Період дискретизації, згідно варіанту: Ts=', num2str(Ts), ', сек.']);
fs = 1/Ts;
disp (['Частота дискретизації  fs=1/Ts=', num2str(fs), ', Гц.']);
fn = 0.5*fs;
disp (['Частота Найквіста  fn=0.5*fs=', num2str(fn), ', Гц.']);
disp (' ' );



b = K1*K2*[T3 1]
a = conv([T1 1], [T2*T2 2*T2*q 1])
%Wp = tf (K1*K2*[T3 1],  conv([T1 1], [T2*T2 2*T2*q 1]) )
Wp = tf (b,a)

bp = Wp.Numerator{1};
ap = Wp.Denominator{1};

disp( [ 'bp = [ ',num2str(bp,8), ' ]' ])
disp( [ 'ap = [ ',num2str(ap,8), ' ]' ])
disp( ['  ']);


% C2. Еквівалента передавальна функція замкненої системи з П-регулятором
% Знайдемо чисельник та знаменик 
bcs = K*bp;
acs = ap+K*bp;
disp( [ 'bcs = [ ',num2str(bcs,8), ' ]' ])
disp( [ 'acs = [ ',num2str(acs,8), ' ]' ])
disp (' ' );


% D1
% Знайдемо еквівалентну дискретну передавальну функцією (ZOH+plant)
Wpzoh = c2d (Wp,Ts,'zoh') 
np = Wpzoh.Numerator{1};
mp = Wpzoh.Denominator{1};
disp( [ 'np = [ ',num2str(np,8), ' ]' ])
disp( [ 'mp = [ ',num2str(mp,8), ' ]' ])
disp( ['  ']);

%D2. Еквівалента дискретна передавальна функція замкненої системи з П-регулятором
% Знайдемо чисельник та знаменик 
ncs = K*np;
mcs = mp+K*np;
disp( [ 'ncs = [ ',num2str(ncs,8), ' ]' ])
disp( [ 'mcs = [ ',num2str(mcs,8), ' ]' ])
disp( '  ' );
disp( '  ' );

ps=roots (acs);
disp( [ 'Полюси (корені характеристичного поліному) неперервної замкненої системи ps:' ])
disp ([num2str(ps,5)])
disp( '  ' );


pz=roots (mcs);
Abspz = abs (pz);
disp( [ 'Полюси (корені характеристичного поліному) дискретної замкненої системи pz:' ])
disp ([num2str(pz,5)])
disp( '  ' );
disp( [ 'Abs (pz):' ])
disp ([num2str(Abspz,5)])




%nyquist (Wp,Wpzoh, K*Wp, K*Wpzoh); legend ('Wp','Wpzoh','K*Wp','K*Wpzoh')
nyquist (K*Wp, K*Wpzoh); legend ('K*Wp','K*Wpzoh')


%bode (Wp,Wpzoh); legend ('Wp','Wpzoh'); grid on
