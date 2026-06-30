% Equation de convection-diffusion: u,t + a u,x- u,xx = 0

lgx = 3.;                   % Longueur du domaine
lgy = 1.;                   % Hauteur du domaine
dx = 0.05;                  % Pas d'espace
dy = 0.05;                  % Pas d'espace
nx = lgx/dx;                % Nombre de mailles en x
ny = lgy/dy;                % Nombre de mailles en y 
cfl = 0.;
ax = 0*1.;                  % Vitesse selon x
ay = 0.;                    % Vitesse selon y
nu = 0.001;                 % Coefficient de diffusion
dt = (cfl/nu)/(1/(dx*dx)+1/(dy*dy));        % Pas de temps
dt = min( dt , dx*0.4/ax );
tfinal =30;                 % 0.5*lgx/1;
nt = floor(tfinal/dt);      % Nombre de pas de temps effectues

% Initialisation
x = zeros(1, nx+1);
y = zeros(1, ny+1);
u0 = zeros(nx+1, ny+1);
for i = 1 : nx+1
  x(i) = (i-1)*dx;
  for j = 1 : ny+1
      y(j) = (j-1)*dy;
      u0(i,j) = max(0.,1.-10*(x(i)-1.5)^2-10*(y(j)-0.5)^2);
  end
end
u = u0;
up = u0;
um = u0;
uexacte = u0;

% tics=[4,16,4,10];
% plotframe([0.,0.,lgx,lgy],tics);
% contour2d(x,y,u0,9,1:9,"000")
% xtitle ('donnee initiale' ,' ',' ');

leg = 'x@y@u';
flag = [0,1,4];
ebox = [0.,lgx,0.,lgy,0.,1.];
% plot3d(x,y,u0,35,45,leg);
% plot3(x,y,u0,35,45,leg,flag,ebox);
% plot3(u0)
surf(u0)
% titre =  sprintf('donnee initiale'); 
% xlabel(titre,' ',' ');

pause ();

% Schema explicite: cfl=0.4, vitesse=1

for n=1:nt
    un = shift2d('n',u);
    us = shift2d('s',u);
    ue = shift2d('e',u);
    uo = shift2d('o',u);

    u = u - ax*dt/(dx)*(u-uo) - ay*dt/(2*dy)*(un-us) + nu*dt/(dx*dx)*(ue+uo-2*u) + nu*dt/(dy*dy)*(un+us-2*u);

    if mod(n,5) == 0
        clf()
        % flag=[0,0,4] ;
        % plot3d(x,y,u,35,45,leg,flag,ebox);
        surf(u)
        % titre =  msprintf('Schema explicite, vitesse=%.2f, temps=%.2f, nombre de pas de temps=%i',ax,n*dt,n); 
        % xtitle(titre,' ',' ');
        % pause(100000);
        drawnow
    end
end

% Ccomparaison au temps final
% titre =  msprintf('Schema explicite, vitesse=%.2f, temps final=%.2f, nombre de pas de temps=%i',ax,tfinal,nt); 
% clf()
% plot3d(x,y,u,35,45,leg,flag,ebox);
surf(u)
% xtitle(titre,' ',' ');

% [xx,yy,uu]=genfac3d(x,y,u);
% plot3d(xx,yy,uu,35,45,leg,flag);