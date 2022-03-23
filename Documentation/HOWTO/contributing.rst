Contributing
============
You probably read the syntax howto in sending-mails.

Creating a new shell command
----------------------------
To create a new shell command you should add a function
definition in the ``kernel/kernel.h`` file, and then create
them in the ``kernel/kernel.c`` file. If the function is rather large, you can put it in a different file in ``commands/`` or ``kernel/``.

After you created the command, you must add a new line to the ``usage()`` command which describes the command in one line.

happy contributing <3
