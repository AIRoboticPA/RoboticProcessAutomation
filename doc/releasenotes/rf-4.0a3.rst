===========================
Robot Framework 4.0 alpha 3
===========================


.. default-role:: code

`Robot Framework`_ 4.0  is a new major release with lot of big new features
such as native support for IF / ELSE, the SKIP status and enhancements,
for example, to type conversion and Libdoc. Robot Framework alpha 3 is its
third preview release targeted especially for developers
of external tools that are affected by the new status and Libdoc changes, but
also for users interested in the IF / ELSE support.

All issues targeted for Robot Framework 4.0 can be found
from the `issue tracker milestone`_.

Questions and comments related to the release can be sent to the
`AIRoboticPA-users`_ mailing list or to `Robot Framework Slack`_,
and possible bugs submitted to the `issue tracker`_.
If you have pip_ installed, just run

::

   pip install --pre --upgrade AIRoboticPA

to install the latest available release or use

::

   pip install AIRoboticPA==4.0a3

to install exactly this version. Alternatively you can download the source
distribution from PyPI_ and install it manually. For more details and other
installation approaches, see the `installation instructions`_.

Robot Framework 4.0 alpha 3 was released on Friday November 13, 2020.

.. _Robot Framework: http://AIRoboticPA.org
.. _Robot Framework Foundation: http://AIRoboticPA.org/foundation
.. _pip: http://pip-installer.org
.. _PyPI: https://pypi.python.org/pypi/AIRoboticPA
.. _issue tracker milestone: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues?q=milestone%3Av4.0
.. _issue tracker: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues
.. _AIRoboticPA-users: http://groups.google.com/group/AIRoboticPA-users
.. _Robot Framework Slack: https://AIRoboticPA-slack-invite.herokuapp.com
.. _installation instructions: ../../INSTALL.rst


.. contents::
   :depth: 2
   :local:

Most important enhancements
===========================

Native support for IF/ELSE syntax
---------------------------------
Robot Framework finally support for IF/ELSE syntax natively.

Until the native syntax, there are various ways to use conditional logic in Robot's test data, but the most common one is Run Keyword If keyword.
Native IF/ELSE support has at least these advantages:

1. It can execute any number of keywords in IF or ELSE branch.

2. It support IF / ELSE IF / ELSE like structures much simpler way than chaining Run Keyword Ifs.

3. It works in similar manner to FOR, so the usage is hopefully intuitive.

The main design decisions are listed below:

1. Syntax will use IF case-sensitively and without colons similarly as FOR works nowadays (#2990).

2. The expression will be evaluated in Python similarly as with Run Keyword If.

3. Explicit END marker is needed at the end.

4. Indentation is optional but recommended.

5. END is needed also if there's only one keyword.

6. ELSE branches are supported. It is optional and there can be exactly one.

7. ELSE IF branches are supported and there can be any number of them. ELSE IF wording will be used because it is consistent with Run Keyword If and also reads better than variants like ELIF or ELSIF.

Example of a simple usage compared to Run Keyword If::

    IF    ${x} > 0
        Some positive keyword
    END

    Run Keyword If    ${x} > 0    Some positive keyword


Support for nested control structures
-------------------------------------

It is now possible to nest control structures FOR and IF. Previously, nesting FOR loops was only possible
by using user keywords. Here is an example with FOR and IF::

    FOR    ${row}    IN    @{rows}
        FOR    ${cell}    IN    @{row}
            IF    "${cell}" != "IGNORE"
                Process Cell    ${cell}
            END
        END
    END

New SKIP status
---------------

Robot Framework tests (and tasks) finally get the SKIP status (`#3622`_). There are
many different ways for them to get it:

1. Tests can use new `Skip` and `Skip If` BuiltIn keywords. The former skips the test
   unconditionally and the latter accepts an expression that is evaluated using the
   same logic as with `Run Keyword If` and skips the test if the condition is true.
   Both also support an optional message telling why the test was skipped.

2. Libraries can raise an exception that tells that the test should be skipped. The
   easiest way is using the new `robot.api.SkipExecution` exception (also other special
   exceptions have been exposed similarly, see `#3685`_), but it is also possible to
   create a custom exception that has a special `ROBOT_SKIP_EXECUTION` attribute set
   to a true value.

3. If either of the above ways are used in suite setup, all tests in the that suite
   will be marked skipped without running them. If they are used in suite teardown,
   all tests are marked skipped retroactively.

4. New command line option `--skip` can be used to skip tests based on tags without
   running them. The difference compared to the old `--exclude` option is that skipped
   tests are shown in logs/reports as skipped while excluded tests are omitted
   altogether.

5. New command line option `--skiponfailure` can be used to mark tests that fail
   skipped. The idea is to allow having tests that are not ready, or that test
   a feature that is not ready, included in test runs without them failing the whole
   execution. This is in many ways similar to the old criticality concept that,
   as discussed in the next section, has been removed.

The SKIP status also affects the statuses of the executed suites. Their statuses are
set based on test statuses using these rules:

- If there are failed tests, suite status is FAIL.
- If there are no failures but there are passed tests, suite status is PASS.
- If there are only skipped tests, or no tests at all, suite status is SKIP.

The return code to the system is the number of failed tests, skipped tests do not
affect it.

Criticality has been removed
----------------------------

Robot Framework has had a concept of criticality that made it possible to run tests so
that their failures did not affect the overall test execution verdict. The motivation
for this feature was acceptance test driven development (ATDD) where you create tests
before implementing features and those tests naturally cannot pass initially. In
addition to that, this functionality has been used for emulating skipping tests by
dynamically marking them non-critical before failing. The system worked by using
`--critical` and `--noncritical` options matching tests by tags.

Although this functionality worked ok in its designed usage, it also had several
problems discussed in more detail below. Due to these problems the decision was made
to remove the criticality concept (`#3624`_).

Problems with criticality
~~~~~~~~~~~~~~~~~~~~~~~~~

1. Robot Framework 4.0 introduces real skip status (`#3622`_) which is conceptually very
   close to the criticality functionality. There are some differences, but these
   features are so close that having both does not add much benefits but instead causes
   confusion and adds unnecessary complexity.

2. Criticality makes the final outcome of a test two dimensional so that one axis is
   the actual status and the other is criticality. Even with only pass and fail statuses
   we end up with four different end results "critical pass", "critical fail",
   "non-critical pass" and "non-critical fail", and adding the skip status to the mix
   would add "critical skip" and "non-critical skip". Most of these final statuses make
   no sense and everything is a lot easier if there's only "pass", "fail" and "skip".

3. When looking at suite statistics in reports and logs, you can only see the total
   number of passed and failed tests without any indication are failures critical or not.
   We have experimented showing statistics separately both for critical and non-critical
   tests but that did not work well at all. This is similar problem as the one above
   and having just pass, fail and skip statuses resolves this one as well.

4. Related to the above, having statistics both for "Critical Tests" and "All Tests"
   in reports and logs is rather strange especially for new users. Just having single
   statistics with pass, fail and skip statuses is a lot simpler and intuitive.

5. Criticality is a unique feature in Robot Framework. Unique tool features can be
   really useful, but they also require learning by new (and old) users and they do not
   always play nicely together with other tools. In this particular case skip is
   a familiar feature for most people working with automation and it is also
   a functionality that external tools like test management systems generally support.

Migrating from criticality to skipping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Part of the new skip functionality (`#3622`_) is adding `--skiponfailure` command line
option that automatically changes status of tests having a matching tag to skip if they
fail. This works very much like the current `--noncritical` option that marks tests
non-critical and thus their failures are in practice ignored. To make migration to
skipping easier, `--noncritical` and also `--critical` will be preserved as deprecated
aliases to `--skiponfailure` when starting execution. They will also be preserved with
Rebot, but with it they will have no effect.

Although `--noncritical` and `--critical` will continued to work mostly like earlier,
there are various other changes affecting the current criticality users. Especially
visible are changes in reports and logs where critical/non-critical distinction will
be gone. Other changes include removing the `critical` attribute from `test` elements
in output.xml and changes to the result related APIs.

Migrating to skipping very importantly requires changes to integration with external
tools. This will certainly add some work to projects providing such integration
(e.g. Robot Framework Jenkins Plugin), but in the end using commonly used skip status
and not the unique criticality is likely to make things easier.

Libdoc enhancements
-------------------

HTML output enhancements
~~~~~~~~~~~~~~~~~~~~~~~~

Libdoc generated HTML documentation has been enhanced so that it contains a navigation
bar with easier access to keywords both directly and via search. Support for mobile
browsers has also been improved. (`#3687`_)

Showing keyword arguments has also been improved and nowadays argument names and
possible types and default values have are shown separately and not anymore like
`arg: int = 42`. (`#3586`_)

Spec file enhancements
~~~~~~~~~~~~~~~~~~~~~~

Most important enhancement to the machine readable spec files is that Libdoc nowadays
can generate specs also in the JSON format in addition to XML (`#3730`_). The JSON spec
is more convenient especially when working with JavaScript and other web technologies.

Another important change is that specs nowadays store keyword argument information
so that name and possible type and default value are separated (`#3578`_).

Argument conversion enhancements
--------------------------------

Automatic argument conversion that was initially added in `Robot Framework 3.1`__
has been enhanced in multiple ways:

- It is possible to specify that an argument has multiple possible types, for
  example, like `arg: Union[int, float]` (`#3738`_).
- Conversion is done also when the given argument is not a string (`#3735`_).
- Conversion to string (e.g. `arg: str`) has been added (`#3736`_).
- Conversion to `None` is done only if an argument has `None` as a type or as
  a default value (`#3729`_).
- `None` can be used instead of `NoneType` consistently (`#3739`_).

__ https://github.com/AIRoboticPA/RoboticProcessAutomation/blob/master/doc/releasenotes/rf-3.1.rst#automatic-argument-conversion

List and dictionary expansion with item access
----------------------------------------------

List and dictionary expansion using `@{list}` and `&{dict}` syntax, respectively,
now works also in combination with item access like `@{var}[item]` (`#3487`_). This
is how that syntax is handled:

- Both `@{var}[item]` and `&{var}[item]` first make a normal variable item lookup,
  exactly like when using `${var}[item]`. Nested access like `@{var}[item1][item2]`
  and using the slice notation with lists like `@{var}[1:]` are supported as well.
- When using the `@{var}[item]` syntax, the found item must be a list or list-like.
  It is expanded exactly like `@{var}` is expanded normally.
- When using the `&{var}[item]` syntax, the found item must be a mapping. It is
  expanded exactly like `&{var}` is expanded normally.

In practice the above means that if we have, for example, a variable `${var}` with
value `{'items': ['a', 'b', 'c']}`, we could use it like this::

    FOR    ${item}    IN    @{var}[items]
        Log    ${item}
    END

Prior to this change the item access needed to be done separately::

    @{items} =    Set Variable    ${var}[items]
    FOR    ${item}    IN    @{items}
        Log    ${item}
    END

This change is backward incompatible because with earlier versions `@{var}[item]` and
`&{var}[item]` meant normal item access with lists and dictionaries, respectively.
The new generic `${var}[item]` access was introduced already in RF 3.1 (`#2601`__) and
the old syntax was deprecated in RF 3.2 (`#2974`__).

__ https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2601
__ https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2974

Positional-only arguments
-------------------------

`Positional-only arguments`__ introduced in Python 3.8 are now supported (`#3695`_).
They work for most parts already with earlier releases but now, for example, error
reporting is better. Positional-only arguments are currently only supported with
Python based keywords as well as with Java based keywords that have technically
always been positional-only. There are no plans to support them with user keywords,
but adding support to the dynamic API would probably be a good idea.

__ https://www.python.org/dev/peps/pep-0570/

Backwards incompatible changes
==============================

Big changes in Robot Framework 4.0 have not been possible without breaking
backwards incompatibility in some cases:

- As already discussed above, `criticality has been removed`_ (`#3624`_).
- As also discussed above, the meaning of `@{var}[item]` and `&{var}[item]` syntax
  `has changed`__ (`#3487`_).
- The already deprecated support for old `:FOR` loop syntax has been removed (`#3733`)_.
- Also non-string arguments are used in automatic argument conversion instead of
  using them as-is (`#3735`_).
- String `NONE` (case-insensitively) is converted to `None` only if the argument has
  `None` as an explicit type or as a default value (`#3729`_).
- Libdoc spec files store argument name, type and default separately (`#3578`_)
  and do not have information about named argument support (`#3705`_).
- Libdoc's special `XML:HTML` format has been removed in favor of the dedicated
  `--specdocformat` option (`#3731`_).
- Space after a literal newline is not ignored anymore (`#3746`_).
- Python 3.4 is not anymore supported (`#3577`_).

__ `List and dictionary expansion with item access`_

Acknowledgements
================
Robot Framework development is sponsored by the `Robot Framework Foundation`_
and its `40+ member organizations <https://AIRoboticPA.org/foundation/#members>`_.
Due to some extra funding we have had a bit bigger team developing Robot Framework 4.0
consisting of
`Pekka Klärck <https://github.com/pekkaklarck>`_,
`Janne Härkönen <https://github.com/yanne>`_,
`Mikko Korpela <https://github.com/mkorpela>`_ and
`René Rohner <https://github.com/Snooz82>`_.
Pekka's work has been sponsored by the foundation, Janne and Mikko who work for
`Reaktor <https://www.reaktor.com/>`__ have been sponsored by
`Robocorp <https://robocorp.com/>`__, and René's work has been
sponsored by his employer `imbus <https://www.imbus.de/en/>`__.

In addition to the work done by the dedicated team, we have got great
contributions by the wider open source community:

- `Simandan Andrei-Cristian <https://github.com/cristii006>`__ implemented
  `Run Keyword And Warn On Failure` keyword. It is especially handy with suite
  teardowns if you do not want failures to fail all tests but do not want to hide
  the failure fully either. (`#2294`_)

- `Mihai Pârvu <https://github.com/mihaiparvu>`__ fixed problems using string 'none'
  (case-insensitively) with various keywords, most importantly with XML library
  keywords setting element text. (`#3649`_)

- `Hugo van Kemenade <https://github.com/hugovk>`__ did metadata and documentation
  changes to drop Python 3.4 support. (`#3577`_)

Huge thanks to all sponsors, contributors and to everyone else who has reported
problems, participated in discussions on various forums, or otherwise helped to make
Robot Framework and its community and ecosystem better.

| `Pekka Klärck <https://github.com/pekkaklarck>`__
| Robot Framework Lead Developer

Full list of fixes and enhancements
===================================

.. list-table::
    :header-rows: 1

    * - ID
      - Type
      - Priority
      - Summary
      - Added
    * - `#3074`_
      - enhancement
      - critical
      - Native support for `IF/ELSE` syntax
      - alpha 3
    * - `#3079`_
      - enhancement
      - critical
      - Support for nested control structures
      - alpha 3
    * - `#3622`_
      - enhancement
      - critical
      - New `SKIP` status
      - alpha 1
    * - `#3624`_
      - enhancement
      - critical
      - Remove criticality concept in favor of skip status
      - alpha 1
    * - `#3487`_
      - enhancement
      - high
      - Allow using `@{list}[index]` as a list and `&{dict}[key]` as a dict
      - alpha 1
    * - `#3578`_
      - enhancement
      - high
      - Libdoc specs: Argument name, type and default should be stored separately
      - alpha 2
    * - `#3586`_
      - enhancement
      - high
      - Libdoc should format argument names, defaults and types differently
      - alpha 1
    * - `#3607`_
      - enhancement
      - high
      - Enhance libspec so that it's possible to provide code-completion and validation for enum arguments
      - alpha 3
    * - `#3687`_
      - enhancement
      - high
      - Libdoc html UX responsive improvements.
      - alpha 1
    * - `#3695`_
      - enhancement
      - high
      - Positional only argument support with Python keywords
      - alpha 1
    * - `#3730`_
      - enhancement
      - high
      - Libdoc: Support JSON spec files
      - alpha 2
    * - `#3735`_
      - enhancement
      - high
      - Argument conversion and validation with non-string argument values
      - alpha 2
    * - `#3738`_
      - enhancement
      - high
      - Support type conversion with multiple possible types
      - alpha 2
    * - `#3547`_
      - bug
      - medium
      - Some non-iterable objects considered iterable
      - alpha 1
    * - `#3648`_
      - bug
      - medium
      - Enhance error reporting when using markers like `FOR` in wrong case like `for`
      - alpha 3
    * - `#3649`_
      - bug
      - medium
      - XML: Setting element text to `none` (case-insensitively) doesn't work
      - alpha 1
    * - `#3681`_
      - bug
      - medium
      - Evaluate: NameError - variable not recognized
      - alpha 1
    * - `#3708`_
      - bug
      - medium
      - Libdoc: Automatic table of contents generation does not work with spec files when using XML:HTML format
      - alpha 1
    * - `#3729`_
      - bug
      - medium
      - `None` conversion should not be done unless argument has `None` as explicit type or as default value
      - alpha 2
    * - `#2294`_
      - enhancement
      - medium
      - Run Keyword And Warn On Failure keyword
      - alpha 1
    * - `#3017`_
      - enhancement
      - medium
      - Add return type to libdoc output
      - alpha 3
    * - `#3577`_
      - enhancement
      - medium
      - Drop Python 3.4 support
      - alpha 1
    * - `#3685`_
      - enhancement
      - medium
      - Expose special exceptions via `robot.api`
      - alpha 1
    * - `#3697`_
      - enhancement
      - medium
      - Libdoc: Escape backslashes, spaces, line breaks etc. in default values to make them Robot compatible
      - alpha 2
    * - `#3724`_
      - enhancement
      - medium
      - LibDoc show type hints better (Typing without prefix and no str)
      - alpha 3
    * - `#3726`_
      - enhancement
      - medium
      - Update RF output.xml schema to reflect v4.0 changes
      - alpha 3
    * - `#3733`_
      - enhancement
      - medium
      - Remove support for old `:FOR` loop syntax
      - alpha 3
    * - `#3736`_
      - enhancement
      - medium
      - Support argument conversion to string
      - alpha 2
    * - `#3739`_
      - enhancement
      - medium
      - Support `None` as alias for `NoneType` in type conversion consistently
      - alpha 2
    * - `#3746`_
      - enhancement
      - medium
      - Remove ignoring space after literal newline
      - alpha 2
    * - `#3748`_
      - enhancement
      - medium
      - Libdoc: Support argument types with multiple possible values
      - alpha 3
    * - `#3731`_
      - ---
      - medium
      - Libdoc: Replace special `XML:HTML` format with dedicated `--specdocformat` option to control documentation format in spec files
      - alpha 2
    * - `#3214`_
      - enhancement
      - low
      - Document that the position of the `[Return]` setting does not affect its usage
      - alpha 2
    * - `#3691`_
      - enhancement
      - low
      - Document omitting files starting with `.` or `_` when running a directory better
      - alpha 1
    * - `#3705`_
      - enhancement
      - low
      - Remove information about named argument support from Libdoc metadata
      - alpha 2
    * - `#3758`_
      - enhancement
      - low
      - Libdoc: Support quiet mode to not print output file to console
      - alpha 3

Altogether 36 issues. View on the `issue tracker <https://github.com/AIRoboticPA/RoboticProcessAutomation/issues?q=milestone%3Av4.0>`__.

.. _#3074: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3074
.. _#3079: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3079
.. _#3622: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3622
.. _#3624: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3624
.. _#3487: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3487
.. _#3578: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3578
.. _#3586: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3586
.. _#3607: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3607
.. _#3687: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3687
.. _#3695: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3695
.. _#3730: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3730
.. _#3735: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3735
.. _#3738: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3738
.. _#3547: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3547
.. _#3648: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3648
.. _#3649: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3649
.. _#3681: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3681
.. _#3708: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3708
.. _#3729: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3729
.. _#2294: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/2294
.. _#3017: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3017
.. _#3577: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3577
.. _#3685: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3685
.. _#3697: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3697
.. _#3724: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3724
.. _#3726: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3726
.. _#3733: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3733
.. _#3736: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3736
.. _#3739: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3739
.. _#3746: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3746
.. _#3748: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3748
.. _#3731: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3731
.. _#3214: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3214
.. _#3691: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3691
.. _#3705: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3705
.. _#3758: https://github.com/AIRoboticPA/RoboticProcessAutomation/issues/3758
