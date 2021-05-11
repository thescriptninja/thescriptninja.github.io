---
title: "Exploring CPython"
description: "Studying the Python Virtual machine"
date: 2021-01-18
tags: [tech]
---


Inspiration
-----------

Last year, I came across [this](https://github.com/vasanthk/how-web-works) GitHub repo, which describes how the internet works in great detail by going through everything that happens from when the user enters a character in the browser to when the web page is displayed. I liked the idea of taking something commonplace and going very deep into its workings. I wondered if the same could be done for a user running a very simple Python script. What followed was a deep dive into the [CPython](https://github.com/python/cpython) project (the most popular Python implementation written in C) and a few months later, I have _some_ idea as to what happens behind the scenes. I have also gained further understanding by drawing parallels between the CPython concepts and the coursework in my current semester. I shall elaborate my understanding in this blog post.

The Python _Virtual Machine_?
-----------------------------

The Python virtual machine is a program that acts like a _virtual CPU_.

A CPU loads instructions from memory and executes them. These instructions are in the form of a series of binary machine codes that are produced after [Assembly](https://en.wikipedia.org/wiki/Assembly_language) code is [assembled](https://en.wikipedia.org/wiki/Assembly_language#Assembler). The set of all instructions a processor is able to execute is called its `Instruction Set`, which is unique to each family of processors (x86, ARM, etc). All code written finally boils down to a series of basic instructions that is placed in memory and is executed by the CPU in a very small amount of time (in the order of nanoseconds, governed by the clock speed).

So how is this related to how Python works? (It is assumed from this point that we are talking about CPython)

[CPython](https://github.com/python/cpython) implements a virtual CPU using C. Python code is first compiled (yes, compiled, not interpreted) into a bytecode (binary) that consists of a series of ‘opcodes’ (which can be understood as the Assembly language of the Python VM). As in the case of an actual CPU, these opcodes are executed one-by-one. This compiled code can some times be found in the `.pyc` files created in the annoying little `__pycache__` folder you might find in your project directory (ends up in `.gitignore` mostly).

Show me the code!
-----------------

You can inspect bytecode in Python yourself too.

Let us write a simple function `add_nums`
```python
def add_nums(a, b):
   c = a + b
   return c
```

Save this in a file called `add.py` and run it in interactive mode. Try inspecting the `add_nums` object as shown below:
```shell
$ python -i add.py
>> add_nums.__code__.co_code
``` 

Some bytes are printed out.
```
b'|\x00|\x01\x17\x00}\x02|\x02S\x00'
``` 

This is the compiled bytecode that the Python VM runs when it executes this particular function. You can call this is the ‘machine language’ of the CPython VM. (This is NOT the binary code run by the CPU. Only the CPython VM understands this).

But you may ask now that if _this_ is the machine code, where are the Assembly language equivalent instructions, that are understandable by humans. To get this in a readable format, we use the [dis](https://docs.python.org/3/library/dis.html) module in Python, which is used as a [disassembler](https://en.wikipedia.org/wiki/Disassembler).

In the same interactive shell above, run the following code
```python
>>> import dis
>>> dis.dis(add_nums.__code__.co_code)
``` 

You will see this output:

    0 LOAD_FAST                0 (0)
    2 LOAD_FAST                1 (1)
    4 BINARY_ADD
    6 STORE_FAST               2 (2)
    8 LOAD_FAST                2 (2)
    10 RETURN_VALUE 

Now perhaps, it will start making some sense. If you have read some Assembly code before, the above will look somewhat familiar. Instructions like `LOAD_FAST`, `BINARY_ADD` are called `opcodes`. The numbers to the right are arguments given to them. The leftmost numbers are offsets from the start of the bytecode in number of bytes. Opcodes and their arguments are each 1 byte long, thus causing the offset to increase by 2 after each line.

Opcodes are made human-readable by the dis module. A list of opcodes can be found in the [Include/opcode.h](https://github.com/python/cpython/blob/master/Include/opcode.h) file. This can be understood as the Instruction Set of the CPython VM. All code that is run in Python comes down to executing a series of these opcodes.

Stack ‘em up
------------

I won’t go into how Python code is compiled into bytecode (done in [Python/compile.c](https://github.com/python/cpython/blob/master/Python/compile.c)). I’ll try elaborating a little about the runtime and the interpreter loop.

The CPython VM is a [stack machine](https://en.wikipedia.org/wiki/Stack_machine), which means that temporary values used during execution like variables and constants are stored and accessed from a stack (in LIFO manner). The stack pointer points to the top of the stack, which is manipulated when values are pushed or popped from the stack. The pointer is defined [here](https://github.com/python/cpython/blob/998ae1fa3fb05a790071217cf8f6ae3a928da13f/Python/ceval.c#L995).[These lines](https://github.com/python/cpython/blob/master/Python/ceval.c#L1190-L1236) define macros for some common stack operations.

The main interpreter loop can be found on [this](https://github.com/python/cpython/blob/master/Python/ceval.c#L1507) line in the `Python/ceval.c` file. The loop takes in one opcode at a time from the thread and executes it. [This](https://github.com/python/cpython/blob/master/Python/ceval.c#L1606) switch statement defines the behavior for each opcode. For example, the code for the `BINARY_MULTIPLY` opcode (which multiplies two numbers) is:

    case TARGET(BINARY_MULTIPLY): {
        // Values to be multiplied are the two topmost elements on the stack
        PyObject *right = POP(); // Pops value from the top of the stack
        PyObject *left = TOP(); // Copies the top value from stack without popping
        PyObject *res = PyNumber_Multiply(left, right);
        Py_DECREF(left); // Decrements reference count for garbage collection
        Py_DECREF(right); // Decrements reference count for garbage collection
        SET_TOP(res); // Sets the top of the stack to the multiplied value (Overwrite)
        if (res == NULL)
            goto error;
        DISPATCH(); // continue to the next opcode
    }
    

More examples
-------------

Let us see some more examples.

Modify the `add_nums` function to include a conditional:
```python
def add_nums(a, b):
    c = a + b
    if c % 2 == 0 and c % 3 == 0:
        return 0
    return c
```

As in the earlier example, we look at the disassembled bytecode.

    	      0 LOAD_FAST                0 (0)
              2 LOAD_FAST                1 (1)
              4 BINARY_ADD
              6 STORE_FAST               2 (2)
              8 LOAD_FAST                2 (2)
             10 LOAD_CONST               1 (1)
             12 BINARY_MODULO
             14 LOAD_CONST               2 (2)
             16 COMPARE_OP               2 (==)
             18 POP_JUMP_IF_FALSE       36
             20 LOAD_FAST                2 (2)
             22 LOAD_CONST               3 (3)
             24 BINARY_MODULO
             26 LOAD_CONST               2 (2)
             28 COMPARE_OP               2 (==)
             30 POP_JUMP_IF_FALSE       36
             32 LOAD_CONST               2 (2)
             34 RETURN_VALUE
        >>   36 LOAD_FAST                2 (2)
             38 RETURN_VALUE
    
    

While this looks pretty scary, the important part to note is the two `POP_JUMP_IF_FALSE` statements. These statements tell the VM to make a jump to a particular instruction and pop the boolean from top of the stack. The first `POP_JUMP_IF_FALSE` instruction evaluates the boolean value on top of the stack (produced by `COMPARE_OP`) and directly makes a jump to the instruction with offset `36`, that is the penultimate instruction in this series. This is an optimization as the needless evaluation of the second boolean expression is saved (if the first value is false in AND, there is no need to evaluate the second value).

Let us include a loop in the function and see what happens
```python
def add_nums(a, b):
    c = a + b
    while c > a / 2:
        c = c - 1
    return c
```    

The disassembled bytecode is:
```
    		0 LOAD_FAST                0 (0)
              2 LOAD_FAST                1 (1)
              4 BINARY_ADD
              6 STORE_FAST               2 (2)
        >>    8 LOAD_FAST                2 (2)
             10 LOAD_FAST                0 (0)
             12 LOAD_CONST               1 (1)
             14 BINARY_TRUE_DIVIDE
             16 COMPARE_OP               4 (>)
             18 POP_JUMP_IF_FALSE       30
             20 LOAD_FAST                2 (2)
             22 LOAD_CONST               2 (2)
             24 BINARY_SUBTRACT
             26 STORE_FAST               2 (2)
             28 JUMP_ABSOLUTE            8
        >>   30 LOAD_FAST                2 (2)
             32 RETURN_VALUE
```
    

Again, this looks very tedious to read. However, if you go through each line, you will see that most operations are just simple stack operations like loading, pop, store, etc. It is interesting to see how the loop has been implemented using `JUMP` opcodes. The `POP_JUMP_IF_FALSE` governs the exit condition of the loop, where it jumps out of the loop to offset `30` if the boolean after the comparison is evaluated to be false. `JUMP_ABSOLUTE` causes the ‘looping’ behavior, by returning control to the top of the loop again (offset `8`).

## Conclusion

If you made it this far, you might be wondering, “This is all nice, but I will never put this to actual use. What’s the use of knowing this?”. To be honest, even I haven’t found the answer to that question :P. The best I can offer is some relief to the curiosity about the internal workings of Python :D

A few good resources I have found related to this:

[PyCon 2012 talk by Larry Hastings](https://www.youtube.com/watch?v=XGF3Qu4dUqk)

[This StackOverflow answer](https://stackoverflow.com/a/2998544) about compiled vs interpreted

The book “Inside the Python Virtual Machine” by Obi Ike-Nwosu

[This series of blogposts](https://tech.blog.aknin.name/2010/04/02/pythons-innards-introduction/)

Leave any critique/thoughts/suggestions in the comments or DMs. I would really appreciate it :)
