imuxsock: Unix Socket Input
***************************

.. above, the title header

.. below, the doc "attribution" header

===========================  ===========================================================================
**Module Name:**             **imuxsock**
**Author:**                  `Rainer Gerhards <http://www.gerhards.net/rainer>`_ <rgerhards@adiscon.com>
===========================  ===========================================================================

.. main intro text here


.. 2nd level header

Configuration Parameters
========================

.. note::

   Parameter names are case-insensitive.

.. 3rd level header

Global Parameters
-----------------

.. example of using a label

.. _systemd-details-label:

.. 4th level header

Running under systemd
~~~~~~~~~~~~~~~~~~~~~

.. 3rd level header

Input Parameters
----------------

.. 2nd level section, various content

Statistic Counter
=================

.. another second level section

See Also
========

.. Use sphinx directive here?

-  `What are "trusted
   properties"? <http://www.rsyslog.com/what-are-trusted-properties/>`_
-  `Why does imuxsock not work on
   Solaris? <http://www.rsyslog.com/why-does-imuxsock-not-work-on-solaris/>`_

Caveats/Known Bugs
==================

-  There is a compile-time limit of 50 concurrent sockets. If you need
   more, you need to change the array size in imuxsock.c.

.. todolist::

Examples
========

Example text here
