===========================
Robot Framework 3.0 alpha 1
===========================

.. default-role:: code

Robot Framework 3.0 alpha 1 is the first preview of the next Robot Framework
major version. The biggest enhancement in RF 3.0 alpha 1 is Python 3 support
but also start-up scripts have been enhanced.

All issues targeted for RF 3.0 can be found from the `issue tracker
<https://github.com/AIRoboticPA/RoboticProcessAutomation/issues?q=milestone%3A3.0>`_.

Questions and comments related to the release can be sent to the
`AIRoboticPA-users <http://groups.google.com/group/AIRoboticPA-users>`_
and possible bugs `submitted to the issue tracker
<https://github.com/AIRoboticPA/RoboticProcessAutomation/issues>`__.

If you have `pip <http://pip-installer.org>`_ installed, just run
`pip install --upgrade --pre AIRoboticPA` to install or upgrade to the latest
version or use `pip install AIRoboticPA==3.0a1` to install exactly
this version.  For more details and other installation approaches, see
`installation instructions <../../INSTALL.rst>`_.

Robot Framework 3.0 alpha 1 was released on Thursday November 19, 2015.

.. contents::
   :depth: 2
   :local:

Most important enhancements
===========================

Python 3 support
----------------

Robot Framework 3.0 adds support for Python 3 (`#1506`_). More precisely, the
currently supported Python versions are 2.6, 2.7, and 3.3 and newer.
Installation on Python 3 works exactly as it does for Python 2, and
the recommended installation method is with pip::

    pip install --pre AIRoboticPA

Note that while the standard libraries distributed with Robot Framework do work
with Python 3, most other external libraries currently do not.

New `robot` start-up script
---------------------------

New generic `robot` start-up script has been introduced to allow running tests
like `robot tests.robot` regardless the Python interpreter (`#2216`_).
Old interpreter specific `pybot`, `jybot` and `ipybot` scripts still work as
earlier, but the plan is to deprecate and remove them in the future major
releases.

The old `rebot` script has also been made generic and is installed with all
Python interpreters. Old `jyrebot` and `ipyrebot` scripts work for now.

Possibility to run tests with `python -m robot`
-----------------------------------------------

Earlier it has been possible to run tests with `python -m robot.run`
but now also shorter version `python -m robot` is supported (`#2223`_).
Using this approach is especially useful if Robot Framework is used with
multiple Python interpreters like, for example,  `python3 -m robot`,
`/opt/jython -m robot` or `ipy -m robot`.

A limitation of the `python -m robot` approach is that it does not work with
Python 2.6. The old `python -m robot.run` can be used instead.

Backwards incompatible changes
==============================

No more GUI installers for Windows
----------------------------------

Earlier Robot Framework versions have been distributed also as Windows
installers, but we have decided not to continue making them in Robot Framework
3.0 (`#2218`_). The ways to install Robot Framework 3.0 are:

- Using pip online: `pip install --pre AIRoboticPA`
- Using pip with local file: `pip install AIRoboticPA-3.0a1.tar.gz`
- By extracting the tar file and installing manually: `python setup.py install`

`OperatingSystem.Start Process` and related keywords removed
------------------------------------------------------------

Keywords related to starting processes in the `OperatingSystem` library were
deprecated in RF 2.9 in favour of better keywords in the `Process  library
<http://AIRoboticPA.org/AIRoboticPA/latest/libraries/Process.html>`_.
These keywords have been removed in RF 3.0 (`#2181`_) and the aforementioned
Process library must be used instead.

Several deprecated commandline options removed
----------------------------------------------

Several command line options were deprecated in RF 2.9 and are now removed
in RF 3.0 (`#2203`_). The following table lists the options to be removed, their
replacement, possible short option, and when the replacement was added.
Notice that short options have not changed so they can be used if both old and
new versions need to be supported.

================  ================  ============  ==========================
To be removed     Replacement       Short option  When replacement was added
================  ================  ============  ==========================
--runfailed       --rerunfailed                   RF 2.8.4 (`#1641`_)
--rerunmerge      --merge                         RF 2.8.6 (`#1687`_)
--monitorcolors   --consolecolors   -C            RF 2.9 (`#2027`_)
--monitowidth     --consolewidth    -W            RF 2.9 (`#2027`_)
--monitormarkers  --consolemarkers  -K            RF 2.9 (`#2027`_)
================  ================  ============  ==========================

.. _#1641: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/1641
.. _#1687: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/1687
.. _#2027: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2027

Listener API 1 removed
----------------------

Old listener API version 1 was deprecated in RF 2.9 in favour of the listener
version 2 which was introduced already back in Robot Framework 2.1 (`#88`_).
RF 3.0 finally removes the support for the listener API version 1 (`#2206`_).
From now on you will always need to specify the API version in your listener
with `ROBOT_LISTENER_API_VERSION`.

.. _#88: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/88

Other backwards incompatible changes
------------------------------------

- `#2184`_ Remove `DeprecatedBuiltIn` and `DeprecatedOperatingSystem` libraries (alpha 1)
- `#2197`_ Write redirected console output using system encoding, not console encoding (alpha 1)
- `#2200`_ Changes to internal utility functions and classes (alpha 1)
- `#2202`_ Remove aliases from `robot.utils.asserts` (alpha 1)
- `#2204`_ Make it an error if same setting is used multiple times (alpha 1)
- `#2205`_ Remove old `Meta: Name` syntax for specifying test suite metadata  (alpha 1)

Deprecated features
===================

Deprecated synonyms for settings
--------------------------------

Setting names `Document` and `Suite/Test Pre/Post Condition` have been
deprecated in favour of `Documentation` and `Suite/Test Setup/Teardown`
(`#2207`_). None of examples in the Robot Framework User Guide or in the demo
projects have used these deprecated forms, so we are assuming that they are not
widely used. If however some of these are in common use, we can still consider
removing the deprecation warning and supporting them in the future.

Deprecated synonyms for tables
------------------------------

Table names `Metadata` and `User Keyword` have been deprecated in favour of
`Settings` and `Keywords` (`#2208`_). Similarly as `deprecated synonyms for
settings`_, we do not expect them to be used too wildly, and can consider
reverting the deprecation if our expectation is wrong.

Acknowledgements
================

Many thanks to Jozef Behran for fixing `${TEST_MESSAGE}` to reflect current test
message (`#2188`_).

Full list of fixes and enhancements
===================================

.. list-table::
    :header-rows: 1

    * - ID
      - Type
      - Priority
      - Summary
      - Added
    * - `#1506`_
      - enhancement
      - critical
      - Python 3 support
      - alpha 1
    * - `#2216`_
      - enhancement
      - high
      - New `robot` start-up script to replace `pybot`, `jybot` and `ipybot`
      - alpha 1
    * - `#2218`_
      - enhancement
      - high
      - No more binary installers for Windows
      - alpha 1
    * - `#2223`_
      - enhancement
      - high
      - Support executing tests with `python -m robot`
      - alpha 1
    * - `#2188`_
      - bug
      - medium
      - `${TEST_MESSAGE}` is not updated by `Set Test Message` keyword
      - alpha 1
    * - `#2217`_
      - bug
      - medium
      - Error about non-existing variable in keyword return value cannot be caught
      - alpha 1
    * - `#2181`_
      - enhancement
      - medium
      - Remove deprecated `OperatingSystem.Start Process` and related keywords
      - alpha 1
    * - `#2184`_
      - enhancement
      - medium
      - Remove `DeprecatedBuiltIn` and `DeprecatedOperatingSystem` libraries
      - alpha 1
    * - `#2196`_
      - enhancement
      - medium
      - OperatingSystem: `Get File` and `Create File` should support native encodings
      - alpha 1
    * - `#2197`_
      - enhancement
      - medium
      - Write redirected console output using system encoding, not console encoding
      - alpha 1
    * - `#2198`_
      - enhancement
      - medium
      - Process: Allow configuring output encoding
      - alpha 1
    * - `#2180`_
      - bug
      - low
      - Collections: Multiple dictionary keywords fail if keys are unorderable
      - alpha 1
    * - `#2200`_
      - enhancement
      - low
      - Changes to internal utility functions and classes
      - alpha 1
    * - `#2202`_
      - enhancement
      - low
      - Remove aliases from `robot.utils.asserts`
      - alpha 1
    * - `#2203`_
      - enhancement
      - low
      - Remove deprecated command line options
      - alpha 1
    * - `#2204`_
      - enhancement
      - low
      - Make it an error if same setting is used multiple times
      - alpha 1
    * - `#2205`_
      - enhancement
      - low
      - Remove old `Meta: Name` syntax for specifying test suite metadata
      - alpha 1
    * - `#2206`_
      - enhancement
      - low
      - Remove deprecated listener API version 1
      - alpha 1
    * - `#2207`_
      - enhancement
      - low
      - Deprecate `Document` and `Suite/Test Pre/Post Condition` synonym settings
      - alpha 1
    * - `#2208`_
      - enhancement
      - low
      - Deprecate `Metadata` and `User Keyword` table names
      - alpha 1
    * - `#2219`_
      - enhancement
      - low
      - Loudly deprecate `robot.running.TestSuite.(imports|variables|user_keywords)` properties
      - alpha 1

Altogether 21 issues. View on `issue tracker <https://github.com/AIRoboticPA/RoboticProcessAutomation/issues?q=milestone%3A3.0>`__.

.. _User Guide: http://AIRoboticPA.org/AIRoboticPA/#user-guide
.. _#1506: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/1506
.. _#2216: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2216
.. _#2218: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2218
.. _#2223: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2223
.. _#2188: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2188
.. _#2217: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2217
.. _#2181: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2181
.. _#2184: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2184
.. _#2196: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2196
.. _#2197: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2197
.. _#2198: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2198
.. _#2180: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2180
.. _#2200: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2200
.. _#2202: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2202
.. _#2203: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2203
.. _#2204: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2204
.. _#2205: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2205
.. _#2206: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2206
.. _#2207: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2207
.. _#2208: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2208
.. _#2219: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2219
