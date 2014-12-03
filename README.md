SmartLogger
===========

Another PL/SQL Logger.  

 * Logger package to trace code execution and exceptions.  
 * Apex GUI to review results. 
 * AOP Processor to instrument the PL/SQL with the Logger's syntax.
 
This is the product of many years of development of a simple logger and exception handler.  Initial version of the logger
were predicated on the idea that the exception handling should be interwoven with the logger probably due to the desire to 
log exceptions.  This version had no separation exception flow.  Thus the logger could not be removed without reviewing 
the code.

Overtime, i changed my perspective.  I now prefer to allow the developer to create the programs, with their exception  
handling, without considering the effect of the logger.  The logger handles the tracking of code execution path and 
associating messages with the originating program unit.

The aim of the AOP Processor is to instrument the code (for FREE) without programmer effort and in a way that it does 
not alter the execution of the orginal code except to create messages to document the exceution path and contents of 
variables.  The AOP Processor is virtually a PL/SQL Parser written in PL/SQL.  They said it wasn't possible!
It relies heavilly on PL/SQL REGEXP functions, that nearly did my head in.  If you look carefully at the code, you'll find 
a correct method of stripping Comments and Quotes from PL/SQL.

The Apex GUI allows for testing of the AOP Processor.  Testing of the Logger.  Reviewing of the messages produced, and 
controlling to the level of the procedure and function, the verbosity of the messaging system.

The logger also has its own internal logger for debugging itself.  It uses a compiler option to enable this.

The SmartLogger is deployed using patches created by the GitPatcher.  
Indeed you could use the GitPatcher to create your own patches from the repo, if you so desired.
