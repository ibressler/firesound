// stdbuf.c
// from http://torsten-traenkner.de/cyanogenmod/hacks/button.php
// Author: Torsten Tränkner
// License: GPLv3

#include <stdio.h>

__attribute__ ((constructor)) void
stdbuffer () {
  setvbuf (stdout, NULL, _IOLBF, 0);
}

