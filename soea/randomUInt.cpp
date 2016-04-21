#include <iostream>

unsigned int randomUInt(unsigned int limit) {
  if (limit == 0)
    return 0;
  FILE *f = fopen("/dev/urandom", "r");
  if (!f) {
    std::cerr << "Error opening /dev/urandom" << std::endl;
    return 0;
  }
  unsigned int r = limit, bits = 0;
  while (r) {
    bits++;
    r >>= 1;
  }
  unsigned int bytes = (bits+7) >> 3;
  unsigned int mask = (1U << bits) - 1;
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
  fread(&r, 1, bytes, f);
#else
  fread(&r, 4, 1, f);
#endif
  if (limit == mask) {
    fclose(f);
    return r & mask;
  }
  while ((r & mask) > limit)
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    fread(&r, 1, bytes, f);
#else
    fread(&r, 4, 1, f);
#endif
  fclose(f);
  return r & mask;
}
