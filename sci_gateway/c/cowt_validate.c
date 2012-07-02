/*
 * -------------------------------------------------------------------------
 * cowt_validate.c -- Complex Wavelet Transform Validation
 * SWT - Scilab wavelet toolbox
 * Copyright (C) 2005-2006  Roger Liu
 * Copyright (C) 20010-2012  Holger Nahrstaedt
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * -------------------------------------------------------------------------
 */

#include "swt_common.h"
#include "cwt.h"

void
dualtree_form_validate (int *errCode, int *flow)
{
  *errCode = SUCCESS;
  if ((Rhs==4) && sci_matrix_vector_real(1)  && 
      sci_matrix_scalar_real(2) && sci_matrix_matrix_real(3) &&
      sci_matrix_matrix_real(4) && vector_length_check(3,4) &&
      matrix_row_length_check(3,4) && matrix_row_length_check(4,4))
    *flow = 1;
  else 
    *errCode = UNKNOWN_INPUT_ERR;
  return;
}

// void
// dualtree_content_validate (int *errCode, int flow, int l1, int l2,
// 			   int l3, int l4, int l5, int l6)
// {
//   int type;
//   *errCode = SUCCESS;
//   if (istk(l2)[0]<=0)
// 	*errCode = POSITIVE_INTEGER_ONLY;
//   switch (flow) {
//   case 1:
//     {
//       break;
//     }
//   default:
//     break;
//   }
//   return;
// }

void
idualtree_form_validate (int *errCode, int *flow)
{
  *errCode = SUCCESS;
  if ((Rhs==4) && sci_matrix_vector_complex(1)  && 
      sci_matrix_vector_real(2) && sci_matrix_matrix_real(3) &&
      sci_matrix_matrix_real(4) && vector_length_check(3,4) &&
      matrix_row_length_check(3,4) && matrix_row_length_check(4,4))
    *flow = 1;
  else 
    *errCode = UNKNOWN_INPUT_ERR;
  return;
}


void
dualtree2D_form_validate (int *errCode, int *flow)
{
  *errCode = SUCCESS;
  if ((Rhs==4) && sci_matrix_matrix_real(1)  && 
      sci_matrix_scalar_real(2) && sci_matrix_matrix_real(3) &&
      sci_matrix_matrix_real(4) && vector_length_check(3,4) &&
      matrix_row_length_check(3,4) && matrix_row_length_check(4,4))
    *flow = 1;
  else 
    *errCode = UNKNOWN_INPUT_ERR;
  return;
}

void
idualtree2D_form_validate (int *errCode, int *flow)
{
  *errCode = SUCCESS;
  if ((Rhs==4) && sci_matrix_vector_complex(1)  && 
      sci_matrix_matrix_real(2) && sci_matrix_matrix_real(3) &&
      sci_matrix_matrix_real(4) && vector_length_check(3,4) &&
      matrix_row_length_check(3,4) && matrix_row_length_check(4,4) &&
      matrix_col_length_check(2,2))
    *flow = 1;
  else 
    *errCode = UNKNOWN_INPUT_ERR;
  return;
}

void
icplxdual2D_form_validate (int *errCode, int *flow)
{
  *errCode = SUCCESS;
  if ((Rhs==5) && sci_matrix_vector_complex(1)  && 
      sci_matrix_vector_complex(2)  && vector_length_check(1,2) &&
      sci_matrix_matrix_real(3) && sci_matrix_matrix_real(4) &&
      sci_matrix_matrix_real(5) && vector_length_check(4,5) &&
      matrix_row_length_check(4,4) && matrix_row_length_check(5,4) &&
      matrix_col_length_check(3,2))
    *flow = 1;
  else 
    *errCode = UNKNOWN_INPUT_ERR;
  return;
}
