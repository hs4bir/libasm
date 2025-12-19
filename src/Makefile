NASM = nasm
NASM_FLAGS = -f elf64

CC = gcc
CFLAGS = -Wall -Wextra -Werror -g3

AR = ar
ARFLAGS = rcs

NAME = libasm.a

TEST = test_libasm

#SHELL = /usr/bin/sh

ASM_SRCS = ft_strlen.asm \
           ft_strcpy.asm \
           ft_strcmp.asm \
           ft_write.asm \
           ft_read.asm \
           ft_strdup.asm \
           ft_list_size.asm \
           ft_list_push_front.asm \
           ft_list_sort.asm \
           ft_list_remove_if.asm
#ASM_SRC = $(shell find . -name "*.asm")

ASM_OBJS = $(ASM_SRCS:.asm=.o)
#OBJ = $(shell find . -name "*.o")

TEST_SRCS = test_main.c

all: $(NAME)

$(NAME): $(ASM_OBJS)
	$(AR) $(ARFLAGS) $(NAME) $(ASM_OBJS)

%.o: %.asm
	$(NASM) $(NASM_FLAGS) $< -o $@

tests: $(NAME) $(TEST_SRCS)
	$(CC) $(CFLAGS) $(TEST_SRCS) -L. -lasm -o $(TEST)


run_tests: test
	./$(TEST)

clean:
	rm -rf $(ASM_OBJS)

fclean: clean
	rm -rf $(NAME) $(TEST)

re: fclean all

.PHONY: all clean fclean re test run_test
