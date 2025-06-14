module fulladder(input a,input b, input cin, output s,output cout);

xor(s,a,b,cin);

xor(t1,a,b);
and(t2,a,b);
and(t3,t1,cin);
or(cout,t2,t3);


endmodule



module RCA_n #(parameter n=16)(input [n-1:0]a, input [n-1:0] b,  output [n-1:0]sum);

genvar i;
 
wire [n-1:0]carr;
 generate
    for(i=0;i<n;i=i+1) begin
        if(i==0) begin
          fulladder fi(a[0],b[0],1'b0,sum[0],carr[0]);  
        end
        else begin
        
            fulladder f(a[i],b[i],carr[i-1],sum[i],carr[i]);
        end
    end
  
    endgenerate


endmodule


 
 module N_bit_mul #(parameter N=8) (input[N-1:0] op1,op2, output[2*N-1:0] res);

if(N==1)begin
   assign res[0]=op1[0]&op2[0];
   assign res[1]=0;
end
else begin
  //partial products
  wire [N-1:0] p[N-1:0];
  wire [2*N-1:0]sum [N-2:0];   
  genvar i;
   
     for(i=0;i<N;i=i+1) begin
        genvar j;
            for(j=0;j<N;j=j+1) begin
                and(p[i][j],op1[i],op2[j]);
            end
    end
  
 
  

RCA_n #(2*N) rca1(.a({{N{1'b0}},p[0]}), .b({{N-1{1'b0}},p[1],1'b0}),   .sum(sum[0]));

 
    for(i=2;i<N;i=i+1) begin
        
        RCA_n #(2*N) rca (.a(sum[i-2]), .b({{N-i{1'b0}},p[i],{i{1'b0}}}),.sum(sum[i-1]));
     
    end
 

    assign res=sum[N-2];

end
 endmodule