function us=shift2d(typ,u)
switch typ
   case 'n' 
           [m,n] = size(u) ;
           us(1:m,1:n-1) = u(1:m,2:n) ;
           us(1:m,n) = 0. ;
   case 's' 
           [m,n] = size(u) ;
           us(1:m,2:n) = u(1:m,1:n-1) ;
           us(1:m,1) = 0. ;
   case 'e' 
           [m,n] = size(u) ;
           us(1:m-1,1:n) = u(2:m,1:n) ;
           us(m,1:n) = 0. ;
   case 'o' 
           [m,n] = size(u) ;
           us(2:m,1:n) = u(1:m-1,1:n) ;
           us(1,1:n) = 0. ;
    otherwise 
           error('error')
end;
end
