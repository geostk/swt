// -------------------------------------------------------------------------
// SWT - Scilab wavelet toolbox
// Copyright (C) 2010-2014  Holger Nahrstaedt
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//-------------------------------------------------------------------------
//
//  <-- NO CHECK ERROR OUTPUT -->


// filter Test
// biorfilt

function y = rot90 (x, k)
 [nargout,nargin]=argn(0);
  if (nargin == 1 | nargin == 2)
    if (nargin < 2)
      k = 1;
    end

    if (ndims (x) > 2)
      error ("rot90: Only works with 2-D arrays");
    end

    if (imag (k) ~= 0 | fix (k) ~= k)
      error ("rot90: k must be an integer");
    end

    k = modulo (k, 4);

    if (k < 0)
      k = k + 4;
    end

    if (k == 0)
      y = x;
    elseif (k == 1)
      y = flipud (x.');
    elseif (k == 2)
      y = flipud (fliplr (x));
    elseif (k == 3)
      y = (flipud (x)).';
    else
      error ("rot90: internal error!");
    end
  else
    error("wrong usage!");
  end

endfunction



function b=flipud(a)
b=a($:-1:1,:);
endfunction

function b=fliplr(a)
b=a(:,$:-1:1)
endfunction

function [h_0,h_1] = daubcqf(N,TYPE)
//    [h_0,h_1] = daubcqf(N,TYPE);
//
//    Function computes the Daubechies' scaling and wavelet filters
//    (normalized to sqrt(2)).
//
//    Input:
//       N    : Length of filter (must be even)
//       TYPE : Optional parameter that distinguishes the minimum phase,
//              maximum phase and mid-phase solutions ('min', 'max', or
//              'mid'). If no argument is specified, the minimum phase
//              solution is used.
//
//    Output:
//       h_0 : Minimal phase Daubechies' scaling filter
//       h_1 : Minimal phase Daubechies' wavelet filter
//
//    Example:
//       N = 4;
//       TYPE = 'min';
//       [h_0,h_1] = daubcqf(N,TYPE)
//       h_0 = 0.4830 0.8365 0.2241 -0.1294
//       h_1 = 0.1294 0.2241 -0.8365 0.4830
//
//    Reference: "Orthonormal Bases of Compactly Supported Wavelets",
//                CPAM, Oct.89
//

//File Name: daubcqf.m
//Last Modification Date: 01/02/96	15:12:57
//Current Version: daubcqf.m	2.4
//File Creation Date: 10/10/88
//Author: Ramesh Gopinath  <ramesh@dsp.rice.edu>
//
//Copyright (c) 2000 RICE UNIVERSITY. All rights reserved.
//Created by Ramesh Gopinath, Department of ECE, Rice University.
//
//This software is distributed and licensed to you on a non-exclusive
//basis, free-of-charge. Redistribution and use in source and binary forms,
//with or without modification, are permitted provided that the following
//conditions are met:
//
//1. Redistribution of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//2. Redistribution in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//3. All advertising materials mentioning features or use of this software
//   must display the following acknowledgment: This product includes
//   software developed by Rice University, Houston, Texas and its contributors.
//4. Neither the name of the University nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY WILLIAM MARSH RICE UNIVERSITY, HOUSTON, TEXAS,
//AND CONTRIBUTORS AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
//BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL RICE UNIVERSITY
//OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//OR BUSINESS INTERRUPTIONS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
//OTHERWISE), PRODUCT LIABILITY, OR OTHERWISE ARISING IN ANY WAY OUT OF THE
//USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//For information on commercial licenses, contact Rice University's Office of
//Technology Transfer at techtran@rice.edu or (713) 348-6173
[nargout,nargin]=argn(0);

if(nargin < 2),
  TYPE = 'min';
end;
if(modulo(N,2) ~= 0),
  error('No Daubechies filter exists for ODD length');
end;
K = N/2;
a = 1;
p = 1;
q = 1;
h_0 = [1 1];
for j  = 1:K-1,
  a = -a * 0.25 * (j + K - 1)/j;
  h_0 = [0 h_0] + [h_0 0];
  p = [0 -p] + [p 0];
  p = [0 -p] + [p 0];
  q = [0 q 0] + a*p;
end;
q = mtlb_sort(roots(q));
qt = q(1:K-1);
if TYPE=='mid',
  if modulo(K,2)==1,
    qt = q([1:4:N-2 2:4:N-2]);
  else
    qt = q([1 4:4:K-1 5:4:K-1 N-3:-4:K N-4:-4:K]);
  end;
end;

w = real(poly(qt,'s'));
w=coeff(w);
w=w($:-1:1)

// h_0 = conv(h_0,real(poly(qt)));
h_0 = conv(h_0,w);
h_0 = sqrt(2)*h_0/sum(h_0); 	//Normalize to sqrt(2);


if(TYPE=='max'),
  h_0 = fliplr(h_0);
end;
if(abs(sum(h_0 .^ 2))-1 > 1e-4)
  error('Numerically unstable for this value of N.');
end;
h_1 = rot90(h_0,2);
h_1(1:2:N)=-h_1(1:2:N);



endfunction



function w = dbaux(N)

lon = 2*N-1;
sup = [-N+1:N];
a = zeros(1,N);
for k = 1:N
    nok  = sup(sup ~= k);
    a(k) = prod(0.5-nok)/prod(k-nok);
end
P = zeros(1,lon);
P(1:2:lon) = a;
if N==1 then
  P = [P,1,P];
else
  P = [wrev(P),1,P];
end;
//if nargout>1
    R = roots(P);
    [s,K] = mtlb_sort(abs(R+1));
    R = R(K(lon+2:2*lon));
    [s,K] = mtlb_sort(abs(R));
    R = R(K);
//end
w = real(poly([R(abs(R)<1);-ones(N,1)],'s'));
w=coeff(w);
w=w($:-1:1)/sum(w);
endfunction

// db1
N=1;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );

// db2
N=2;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );

// db3
N=3;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );
// db4
N=4;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );
// db5
N=5;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );
// db6
N=6;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );

// db7
N=7;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );
// db8
N=8;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10 );

// db9
N=9;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*100 );

// db10
N=10;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*100 );

// db11
N=11;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*1000 );

// db12
N=12;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*1000 );

// db13
N=13;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));;
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*1000 );

// db14
N=14;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));;
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*1000 );

// db15

N=15;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*1000 );
// db16
N=16;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10000 );

// db17
N=17;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10000 );

// db18
N=18;
w = dbaux(N);
w2=dbwavf("db"+sprintf("%d",N));
w2=w2/sqrt(2);
assert_checkalmostequal ( w , w2 , %eps, %eps*10000 );


// db20
for N=19:36
  w = dbaux(N);
  w2=dbwavf("db"+sprintf("%d",N));
  w2=w2/sqrt(2);
  assert_checkalmostequal ( w , w2 , %eps, 1e-6 );

end;


// db20
for N=1:36
  w=dbwavf("db"+sprintf("%d",N));
  assert_checkalmostequal ( sum(w)-sqrt(2),0 , %eps, %eps*10 );

end;

//    - sumEven = sum_k^{N-1} h_{2k} = 1/sqrt(2);
//    - sumOdd  = sum_k^{N-1} h_{2k+1} = 1/sqrt(2);
//    - For each integer m = 0, 1, ..., N-1:
//         sum_{k=2m}^{2N-1+2m} h_{k} h_{k-2m}
//         = 1 if m=0,
//         = 0 otherwise.

// db2- 36
for N=1:29	

  w=dbwavf("db"+sprintf("%d",N));
  assert_checkalmostequal(sum(w(1:2:$)),1. /sqrt(2),%eps,%eps);
  assert_checkalmostequal(sum(w(2:2:$)),1. /sqrt(2),%eps,%eps);
  m=0;
  assert_checkalmostequal(sum(w(2*m+1:(2*N+2*m)).*w(1:2*N)),1,%eps,%eps);
  for m = 1:N-2
    assert_checkalmostequal(sum(w(2*m+1:(2*N)).*w(1:2*(N)-2*m)),0,%eps,%eps);
  end;
 end;
 for N=30:36

  w=dbwavf("db"+sprintf("%d",N));
  assert_checkalmostequal(sum(w(1:2:$)),1. /sqrt(2),%eps,%eps*10);
  assert_checkalmostequal(sum(w(2:2:$)),1. /sqrt(2),%eps,%eps*10);
  m=0;
  assert_checkalmostequal(sum(w(2*m+1:(2*N+2*m)).*w(1:2*N)),1,%eps,%eps);
  for m = 1:N-2
    assert_checkalmostequal(sum(w(2*m+1:(2*N)).*w(1:2*(N)-2*m)),0,%eps,%eps);
  end;
 end;
