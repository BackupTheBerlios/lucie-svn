#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]){
  
  setuid(0);
  setenv("USER","root",1);
  system ("vmlucie-setup.pl");

  return 0;
}
