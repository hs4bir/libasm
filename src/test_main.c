#include "libasm.h"
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define GREEN "\033[0;32m"
#define RED "\033[0;31m"
#define BLUE "\033[0;34m"
#define RESET "\033[0m"

int test_count = 0;
int test_passed = 0;

void
print_test_header (const char *test_name)
{
  printf ("\n" BLUE "Testing %s" RESET "\n", test_name);
}

void
assert_test (int condition, const char *test_name)
{
  test_count++;
  if (condition)
    {
      printf (GREEN "PASS" RESET " - %s\n", test_name);
    }
  else
    {
      printf (RED "FAIL" RESET " - %s\n", test_name);
    }
}

// string functions
void
test_strlen (void)
{
  print_test_header ("ft_strlen");

  assert_test (ft_strlen ("") == 0, "Empty string");
  assert_test (ft_strlen ("Hello") == 5, "Normal string");
  assert_test (ft_strlen ("Hello World!") == 12, "String with spaces");
  assert_test (ft_strlen ("a") == 1, "Single character");
}

void
test_strcpy (void)
{
  print_test_header ("ft_strcpy");

  char dst[50];
  char *ret;

  ret = ft_strcpy (dst, "Hello");
  assert_test (strcmp (dst, "Hello") == 0 && ret == dst, "Normal copy");

  ret = ft_strcpy (dst, "");
  assert_test (strcmp (dst, "") == 0 && ret == dst, "Empty string copy");

  ret = ft_strcpy (dst, "Test123");
  assert_test (strcmp (dst, "Test123") == 0 && ret == dst,
               "Alphanumeric copy");
}

void
test_strcmp (void)
{
  print_test_header ("ft_strcmp");

  assert_test (ft_strcmp ("abc", "abc") == 0, "Equal strings");
  assert_test (ft_strcmp ("abc", "abd") < 0, "First string smaller");
  assert_test (ft_strcmp ("abd", "abc") > 0, "First string larger");
  assert_test (ft_strcmp ("", "") == 0, "Both empty");
  assert_test (ft_strcmp ("abc", "ab") > 0, "First string longer");
  assert_test (ft_strcmp ("ab", "abc") < 0, "Second string longer");
}

void
test_strdup (void)
{
  print_test_header ("ft_strdup");

  char *dup;

  dup = ft_strdup ("Hello");
  assert_test (dup != NULL && strcmp (dup, "Hello") == 0, "Normal duplicate");
  free (dup);

  dup = ft_strdup ("");
  assert_test (dup != NULL && strcmp (dup, "") == 0, "Empty string duplicate");
  free (dup);

  dup = ft_strdup ("Long string with many characters");
  assert_test (dup != NULL
                   && strcmp (dup, "Long string with many characters") == 0,
               "Long string duplicate");
  free (dup);
}

// I/O functions
void
test_write (void)
{
  print_test_header ("ft_write");

  int fd;
  ssize_t ret;

  printf ("Testing ft_write to stdout: ");
  fflush (stdout);
  ret = ft_write (1, "OK\n", 3);
  assert_test (ret == 3, "Write to stdout");

  fd = open ("test_write.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
  assert_test (fd >= 0, "Open file for writing");

  ret = ft_write (fd, "Test data\n", 10);
  assert_test (ret == 10, "Write to file");
  close (fd);
  unlink ("test_write.txt");

  errno = 0;
  ret = ft_write (-1, "test", 4);
	printf("ERRNO: %d\n", errno);
  assert_test (ret == -1 && errno == EBADF, "Write with bad fd sets errno");
}

void
test_read (void)
{
  print_test_header ("ft_read");

  int fd;
  char buf[100];
  ssize_t ret;

  fd = open ("test_read.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
  write (fd, "Hello World", 11);
  close (fd);

  fd = open ("test_read.txt", O_RDONLY);
  assert_test (fd >= 0, "Open file for reading");

  memset (buf, 0, sizeof (buf));
  ret = ft_read (fd, buf, 11);
  assert_test (ret == 11 && strcmp (buf, "Hello World") == 0,
               "Read from file");
  close (fd);
  unlink ("test_read.txt");

  errno = 0;
  ret = ft_read (-1, buf, 10);
  assert_test (ret == -1 && errno == EBADF, "Read with bad fd sets errno");
}

// Linked list tests

int
int_cmp (void *a, void *b)
{
  int ia = *(int *)a;
  int ib = *(int *)b;
  return ia - ib;
}

void
free_int (void *data)
{
  free (data);
}

void
test_list_size (void)
{
  print_test_header ("ft_list_size");

  t_list *list = NULL;

  assert_test (ft_list_size (list) == 0, "Empty list size");

  int *val1 = malloc (sizeof (int));
  int *val2 = malloc (sizeof (int));
  int *val3 = malloc (sizeof (int));
  *val1 = 1;
  *val2 = 2;
  *val3 = 3;

  t_list node3 = { val3, NULL };
  t_list node2 = { val2, &node3 };
  t_list node1 = { val1, &node2 };
  list = &node1;

  assert_test (ft_list_size (list) == 3, "List with 3 elements");

  free (val1);
  free (val2);
  free (val3);
}

void
test_list_push_front (void)
{
  print_test_header ("ft_list_push_front");

  t_list *list = NULL;
  int *val1 = malloc (sizeof (int));
  int *val2 = malloc (sizeof (int));
  *val1 = 42;
  *val2 = 24;

  ft_list_push_front (&list, val1);
  assert_test (list != NULL && *(int *)list->data == 42, "Push to empty list");

  ft_list_push_front (&list, val2);
  assert_test (*(int *)list->data == 24 && ft_list_size (list) == 2,
               "Push to non-empty list");

  while (list)
    {
      t_list *tmp = list;
      list = list->next;
      free (tmp->data);
      free (tmp);
    }
}

void
test_list_sort (void)
{
  print_test_header ("ft_list_sort");

  t_list *list = NULL;
  int values[] = { 5, 2, 8, 1, 9 };

  for (int i = 0; i < 5; i++)
    {
      int *val = malloc (sizeof (int));
      *val = values[i];
      ft_list_push_front (&list, val);
    }

  ft_list_sort (&list, int_cmp);

  int expected[] = { 1, 2, 5, 8, 9 };
  t_list *current = list;
  int is_sorted = 1;
  for (int i = 0; i < 5 && current; i++)
    {
      if (*(int *)current->data != expected[i])
        {
          is_sorted = 0;
          break;
        }
      current = current->next;
    }

  assert_test (is_sorted, "List sorted correctly");

  while (list)
    {
      t_list *tmp = list;
      list = list->next;
      free (tmp->data);
      free (tmp);
    }
}

void
test_list_remove_if (void)
{
  print_test_header ("ft_list_remove_if");

  t_list *list = NULL;
  int values[] = { 1, 2, 3, 2, 4, 2, 5 };

  for (int i = 2; i >= 0; i--)
    {
      int *val = malloc (sizeof (int));
      *val = values[i];
      ft_list_push_front (&list, val);
    }

  int to_remove = 2;
  ft_list_remove_if (&list, &to_remove, int_cmp, free_int);

  t_list *current = list;
  int has_two = 0;
  while (current)
    {
      if (*(int *)current->data == 2)
        {
          has_two = 1;
          break;
        }
      current = current->next;
    }

  assert_test (!has_two && ft_list_size (list) == 4,
               "Removed all matching elements");

  while (list)
    {
      t_list *tmp = list;
      list = list->next;
      free (tmp->data);
      free (tmp);
    }
}

int
main (void)
{
  printf (BLUE "LIBASM UNIT TESTS\n" RESET);

  // String functions tests
  test_strlen ();
  test_strcpy ();
  test_strcmp ();
  test_strdup ();

  // I/O functions tests
   test_write ();
   test_read ();

  // Linked list tests
   test_list_size ();
   test_list_push_front ();
  // test_list_sort ();
  //test_list_remove_if ();

  printf (BLUE "Test Results: " RESET);
  if (test_passed == test_count)
    {
      printf (GREEN "%d/%d tests passed ✓\n" RESET, test_passed, test_count);
    }
  else
    {
      printf (RED "%d/%d tests passed\n" RESET, test_passed, test_count);
    }
  return (test_passed == test_count) ? 0 : 1;
}
