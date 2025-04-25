/* Include files */

#include "sdruqpskrx_cgxe.h"
#include "m_Q8opVWfbZH29SAoIAcajpD.h"

unsigned int cgxe_sdruqpskrx_method_dispatcher(SimStruct* S, int_T method, void*
  data)
{
  if (ssGetChecksum0(S) == 2982070982 &&
      ssGetChecksum1(S) == 2029045236 &&
      ssGetChecksum2(S) == 2698523004 &&
      ssGetChecksum3(S) == 1314455974) {
    method_dispatcher_Q8opVWfbZH29SAoIAcajpD(S, method, data);
    return 1;
  }

  return 0;
}
