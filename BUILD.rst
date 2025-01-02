Creating Robot Framework releases
=================================

These instructions cover steps needed to create new Robot Framework releases.
Many individual steps are automated, but we don't want to automate
the whole procedure because it would be hard to react if something goes
terribly wrong. When applicable, the steps are listed as commands that can
be copied and executed on the command line.

.. contents::
   :depth: 1

Preconditions
-------------

Operating system and Python requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generating releases has only been tested on Linux, but it ought to work the
same way also on OSX and other unixes. Generating releases on Windows may
work but is not tested, supported, or recommended.

Creating releases is only supported with Python 3.6 or newer. If you are
using Ubuntu or one of its derivatives and don't have Python 3.6 in the
official package repository, you may consider using the

The ``pip`` and ``invoke`` commands below are also expected to run on Python
3.6+. Alternatively, it's possible to use the ``python3.6 -m pip`` approach
to run these commands.

Python dependencies
~~~~~~~~~~~~~~~~~~~

A pre-condition is
installing all these, and that's easiest done using `pip
<http://pip-installer.org>`_ and the provided `<requirements-dev.txt>`_ file::

    pip install -r requirements-dev.txt

Using Invoke
~~~~~~~~~~~~

Invoke tasks are defined in the `<tasks.py>`_ file and they are executed from
the command line like::

    inv[oke] task [options]

Run ``invoke`` without arguments for help. All tasks can be listed using
``invoke --list`` and each task's usage with ``invoke --help task``.

Different Git workflows
~~~~~~~~~~~~~~~~~~~~~~~

Git commands used below always expect that ``origin`` is the project main
repository. If that's not the case, and instead ``origin`` is your personal
fork, you probably still want to push to the main repository. In that case
you need to add ``upstream`` or similar to ``git push`` commands before
running them.

Testing
-------

Make sure that adequate tests are executed before releases are created.
See `<atest/README.rst>`_ for details.

If output.xml `schema <doc/schema/README.rst>`_ has changed, remember to
run tests also with `full schema validation`__ enabled::

    atest/run.py --schema-validation

Preparation
-----------

1. Check that you are on the right branch and have nothing left to commit,
   pull, or push::

      git branch
      git status
      git pull --rebase
      git push

2. Clean up::

      invoke clean

3. Set version information to a shell variable to ease copy-pasting further
   commands. Add ``aN``, ``bN`` or ``rcN`` postfix if creating a pre-release::

      VERSION=<version>

   For example, ``VERSION=7.1.1`` or ``VERSION=7.2a2``. No ``v`` prefix!

Release notes
-------------

1. Create a personal `GitHub access token`__ to be able to access issue tracker
   programmatically. The token needs only the ``repo/public_repo`` scope.

2. Set GitHub user information into shell variables to ease running the
   ``invoke release-notes`` command in the next step::

      GITHUB_USERNAME=<username>
      GITHUB_ACCESS_TOKEN=<token>

   ``<username>`` is your normal GitHub user name and ``<token>`` is the personal
   access token generated in the previous step. Alternatively this information can
   be given when running the command in the next step.

3. Generate a template for the release notes::

      invoke release-notes -w -v $VERSION -u $GITHUB_USERNAME -p $GITHUB_ACCESS_TOKEN

   The ``-v $VERSION`` option can be omitted if `version is already set
   <Set version_>`__. Omit the ``-w`` option if you just want to get release
   notes printed to the console, not written to a file.

   When generating release notes for a preview release like ``7.2rc1``,
   the list of issues is only going to contain issues with that label
   (e.g. ``rc1``) or with a label of an earlier preview release (e.g.
   ``alpha1``, ``beta2``).

4. Fill the missing details in the generated release notes template.

5. Make sure that issues have correct information:

   - All issues should have type (bug, enhancement or task) and priority set.
     Notice that issues with the task type are automatically excluded from
     the release notes.
   - Issue priorities should be consistent.
   - Issue titles should be informative. Consistency is good here too, but
     no need to overdo it.

   If information needs to be added or edited, its better to edit it in the
   issue tracker than in the generated release notes. This allows re-generating
   the list of issues later if more issues are added.

6. Add, commit and push::

      git add doc/releasenotes/rf-$VERSION.rst
      git commit -m "Release notes for $VERSION" doc/releasenotes/rf-$VERSION.rst
      git push

7. Update later if necessary. Writing release notes is typically the biggest
   task when generating releases, and getting everything done in one go is
   often impossible.

