#include <sys/ioctl.h>
#include <stdio.h>
#include <sys/unistd.h>
#include <string.h>
#include <stdlib.h>

#define ANSI_COLOR_MAGENTA  "\x1b[1;35m"
#define ANSI_COLOR_RESET    "\x1b[1;0m"
#define ANSI_COLOR_CYAN     "\x1b[1;36m"
int main() {
  struct winsize w;
  ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
  char hostname[128];
  char clean_hostname[128];
  char username[128];
  char buffer[1024];
  int i;

  getlogin_r(username, sizeof username);

  gethostname(hostname, sizeof hostname);

  int c = 0;
  while(hostname[c] != '\0' && hostname[c] != '.') {
    clean_hostname[c] = hostname[c];
    c++;
  }

  char dashes[1024];
  snprintf(buffer, sizeof(buffer), "--(" ANSI_COLOR_MAGENTA "%s" ANSI_COLOR_RESET "@" ANSI_COLOR_CYAN "%s" ANSI_COLOR_RESET ")-", username, clean_hostname);


  for (i = 0; i < w.ws_col; i++) {
    dashes[i] = '-';
  }

  int output_length = strlen(buffer);

  strcat(buffer, dashes);

  int offset = w.ws_col + 2* sizeof(ANSI_COLOR_RESET) + sizeof(ANSI_COLOR_MAGENTA) +  sizeof(ANSI_COLOR_CYAN)-4;

  buffer[offset] = '\0';
  printf(buffer);
  printf("\n");
  return 0;
}


