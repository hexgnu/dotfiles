#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define ANSI_COLOR_MAGENTA  "\x1b[1;35m"
#define ANSI_COLOR_RESET    "\x1b[1;0m"
#define ANSI_COLOR_CYAN     "\x1b[1;36m"
#define ANSI_COLOR_GREY     "\x1b[0;37m"
#define ANSI_COLOR_YELLOW   "\x1b[1;33m"

int main() {
  struct winsize w;
  ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);

  char hostname[128];
  char clean_hostname[128];

  char username[128];

  char buffer[1024];
  char dashes[1024];
  int i;

  getlogin_r(username, sizeof username);

  gethostname(hostname, sizeof hostname);

  int c = 0;
  while(hostname[c] != '\0' && hostname[c] != '.') {
    clean_hostname[c] = hostname[c];
    c++;
  }

  snprintf(buffer, sizeof(buffer), ANSI_COLOR_GREY "--(" ANSI_COLOR_CYAN "%s" ANSI_COLOR_GREY "@" ANSI_COLOR_MAGENTA "%s" ANSI_COLOR_GREY ")-", username, clean_hostname);


  for (i = 0; i < w.ws_col; i++) {
    dashes[i] = '-';
  }

  int output_length = strlen(buffer);

  strcat(buffer, dashes);

  int offset = w.ws_col + 3*sizeof(ANSI_COLOR_GREY) + sizeof(ANSI_COLOR_MAGENTA) + sizeof(ANSI_COLOR_CYAN) - 5;

  buffer[offset] = '\0';
  printf(buffer);
  printf("\n");
  return 0;
}


