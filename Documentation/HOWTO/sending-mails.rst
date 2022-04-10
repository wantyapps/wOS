Sending Mails
=============
As you have probably read, we accept contributions via mail.

Your subject should look like the following:
``Subject: Contribution to wOS: <feature name/summary>``

OR: The subject could be the default (numbered) subject
created by ``git-send-mail``

The body must have an explanation of what the feature is and
the files changed (or just a diff)

We are working on a mailing list, but it's still not perfect.

Creating Patches
----------------
Much like the Linux patch-mailing way, use the following commands to
create and send a patch:

Create a commit with the following command-line arguments:
``git commit -s -v``

These arguments do the following:
``-s``: Create a signed-off-by line
``-v``: Show the diff before committing to verify the changes

Then use the following command to create a local patch directory
and create a patch:
``git format-patch -o patch/ <commit>``

To create patchsets use the following commands:
``git format-patch -o patch/ -n --cover-letter <commit1>..<commit2>``

Now, you need to replace ``***SUBJECT HERE***`` with the subject
and ``***BLURB HERE***`` with a description.

You can now send the patch/patchset to a contributor.

Sending Patches with Mutt
-------------------------
To send a patch (assuming you have one ready) use the
following commands:
(assuming you have mutt configured)
``mutt -H path/to/patch/patch.patch``

``-H``: Use the file as a draft.

Sending Patches with Git-send-mail
----------------------------------
You can also send patches with ``scripts/send_all_patches.sh``.

Usage:
``./make_scripts/send_all_patches.sh``

This will send all patches to Uri Arev (me@wantyapps.xyz).
