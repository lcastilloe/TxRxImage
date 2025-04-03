/* Include files */

#include "sdruqpskrx_cgxe.h"
#include "m_kA0EZtdPazV71mY4MBK7zB.h"

unsigned int cgxe_sdruqpskrx_method_dispatcher(SimStruct* S, int_T method, void*
  data)
{
  if (ssGetChecksum0(S) == 712970931 &&
      ssGetChecksum1(S) == 618899846 &&
      ssGetChecksum2(S) == 444953514 &&
      ssGetChecksum3(S) == 4145942403) {
    method_dispatcher_kA0EZtdPazV71mY4MBK7zB(S, method, data);
    return 1;
  }

  return 0;
}
