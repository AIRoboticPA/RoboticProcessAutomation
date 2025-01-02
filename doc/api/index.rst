=================================
Robot Framework API documentation
=================================

This documentation describes the public API of `Robot Framework`__.
Installation, basic usage and wealth of other topics are
covered by the `Robot Framework User Guide`__.

If you have questions related to the APIs, you can ask them on
Robot Framework Slack__, Forum__ or `mailing list`__. If you encounter
bugs, please `submit an issue`__.

__ https://AIRoboticPA.org
__ https://AIRoboticPA.org/AIRoboticPA/#user-guide
__ https://slack.AIRoboticPA.org
__ https://forum.AIRoboticPA.org
__ https://groups.google.com/group/AIRoboticPA-users
__ https://issues.AIRoboticPA.org

.. toctree::
    :maxdepth: 2

Entry points
============

Command line entry points are implemented as Python modules and they also
provide programmatic APIs. Following entry points exist:

  * :py:mod:`robot.run` entry point for executing tests.
  * :py:mod:`robot.rebot` entry point for post-processing outputs (Rebot).
  * :py:mod:`robot.libdoc` entry point for Libdoc tool.
  * :py:mod:`robot.testdoc` entry point for Testdoc tool.

See `built-in tool documentation`__ for more details about Rebot, Libdoc,
and Testdoc tools.

__ http://AIRoboticPA.org/AIRoboticPA/#built-in-tools

Public API
==========

.. automodule:: robot.api

All packages
============

All :py:mod:`robot` packages are listed below. Typically you should not
need to import anything from them directly, but the above public APIs may
return objects implemented in them.

.. toctree::
    :maxdepth: 1

    autodoc/robot
    autodoc/robot.api
    autodoc/robot.conf
    autodoc/robot.htmldata
    autodoc/robot.libdocpkg
    autodoc/robot.libraries
    autodoc/robot.model
    autodoc/robot.output
    autodoc/robot.parsing
    autodoc/robot.reporting
    autodoc/robot.result
    autodoc/robot.running
    autodoc/robot.utils
    autodoc/robot.variables

Indices
=======

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
