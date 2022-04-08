Building wOS
============

Building the Whole OS
---------------------
Generally, if you want to build the operating system, just use ``make``.

Default Configurations
----------------------
This kernel was generally created on macOS, so the default compiler is ``i386-elf-gcc``. If you wish to change that value, use ``CC=<compiler>`` before ``make``.

You should probably not change ``CFLAGS``.

Modules
-------
Almost every directory (except for kernel) has a Makefile, and that means you can build just one module. For example, if you want to build just the ``drivers`` module, you can just use ``make drivers`` in the root directory.
