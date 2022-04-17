Building wOS
============

Building the kernel
-------------------
Use ``make`` to build the kernel.

Default Configurations
----------------------
This kernel was generally created on macOS, so the default compiler is ``i386-elf-gcc``. If you wish to change that value, use ``CC=<compiler>`` before ``make``.

You should probably not change ``CFLAGS``.

Arguments
---------
We recommend using these arguments to build wOS:
``V=1`` enables verbosity (see commands and when make enters directories)
``--always-make`` always make: rebuild files even if they are not changed.

Modules
-------
Almost every directory (except for kernel) has a Makefile, and that means you can build just one module. For example, if you want to build just the ``drivers`` module, you can just use ``make drivers`` in the root directory.
