row     = 32;
column  = 32;
bits    =  8;

a = randi([0, 2^bits-1], [row,column]);
b = randi([0, 2^bits-1], [row,column]);
c = a*b;

f00 = fopen('./vec_a.txt','w');
    for i=1:column
        for j=1:row
            fprintf(f00, '%X \n', a(i,j));
        end
    end
fclose(f00);

f01 = fopen('./vec_b.txt','w');
    for i=1:column
        for j=0:((row/4)-1)
            fprintf(f01, '%02X', b(i,4*j+1));
            fprintf(f01, '%02X', b(i,4*j+2));
            fprintf(f01, '%02X', b(i,4*j+3));
            fprintf(f01, '%02X \n', b(i,4*j+4));
        end
    end
fclose(f01);

f02 = fopen('./vec_c.txt','w');
    for i=1:column
        for j=1:row
            fprintf(f02, '%X \n', c(i,j));
        end
    end
fclose(f02);