#ifndef LIBASM_H
#define LIBASM_H

#include <errno.h>
#include <fcntl.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct s_list
{
  void *data;
  struct s_list *next;
} t_list;

// String functions
size_t ft_strlen (const char *s);
char *ft_strcpy (char *dst, const char *src);
int ft_strcmp (const char *s1, const char *s2);

// I/O functions
ssize_t ft_write (int fd, const void *buf, size_t count);
ssize_t ft_read (int fd, void *buf, size_t count);

// mem function
char *ft_strdup (const char *s);

// Linked list functions
int ft_list_size (t_list *begin_list);
void ft_list_push_front (t_list **begin_list, void *data);
void ft_list_sort (t_list **begin_list, int (*cmp) (void *, void *));
void ft_list_remove_if (t_list **begin_list, void *data_ref,
                        int (*cmp) (void *, void *),
                        void (*free_fct) (void *));

#endif // LIBASM_H
