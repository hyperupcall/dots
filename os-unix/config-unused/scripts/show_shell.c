#include <libgen.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define BUFSIZE 128

static void debug(const char *str, ...) {
  va_list ap;
  va_start(ap, str);

  if (getenv("DEBUG")) {
    vprintf(str, ap);
  }

  va_end(ap);
}

static void get_process_name(pid_t pid, char *name) {
  char procfile[BUFSIZ];
  sprintf(procfile, "/proc/%d/cmdline", pid);
  FILE *f = fopen(procfile, "r");

  if (f) {
    size_t size;
    size = fread(name, sizeof(char), sizeof(procfile), f);
    if (size > 0) {
      if ('\n' == name[size - 1])
        name[size - 1] = '\0';
    }
    fclose(f);
  }
}

int main(int argc, char *argv[]) {
  pid_t pid = getppid();
  if (pid == 0) {
    printf("%s", "[? PID]");
    return 0;
  }

  char name[BUFSIZ];
  get_process_name(pid, name);
  debug("name: %s\n", name);

  char *shell = basename(name);
  debug("shell: %s\n", shell);

  if (strcmp(shell, "bash") == 0) {
    printf("%s", "🥊");
  } else if (strcmp(shell, "csh") == 0) {
    printf("%s", "[csh] 🧓");
  } else if (strcmp(shell, "dash") == 0) {
    printf("%s", "🦌");
  } else if (strcmp(shell, "elvish") == 0) {
    printf("%s", "[elvish] 🧝");
  } else if (strcmp(shell, "eshell") == 0) {
    printf("%s", "[eshell] 🐃");
  } else if (strcmp(shell, "fish") == 0) {
    printf("%s", "🐟");
  } else if (strcmp(shell, "ion") == 0) {
    printf("%s", "⚛️");
  } else if (strcmp(shell, "ksh") == 0) {
    printf("%s", "🌽");
  } else if (strcmp(shell, "oh") == 0) {
    printf("%s", "[oh] 😮");
  } else if (strcmp("%s", "rc") == 0) {
    printf("%s", "[rc] 🧓");
  } else if (strcmp(shell, "scsh") == 0) {
    printf("%s", "scsh 🧓");
  } else if (strcmp(shell, "sh") == 0) {
    printf("%s", "[sh] 🍦");
  } else if (strcmp(shell, "tcsh") == 0) {
    printf("%s", "[tcsh] 🧓");
  } else if (strcmp(shell, "xonsh") == 0) {
    printf("%s", "[xonsh] 🐍");
  } else if (strcmp(shell, "zsh") == 0) {
    printf("%s", "🚀");
  } else {
    printf("%s", "[? SHELL]");
  }

  return 0;
}
