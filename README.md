# Radiance-Benchmark4

A well-used benchmark scene for the Radiance pseudo-radiosity renderer
=========================================================================

Radiance Benchmark scene version 4.2

'''
    Mark Stock <mstock@umich.edu>
    James Lee <james@blastwave.org>
    Guy Vaessen <guy.vaessen@gmail.com>
    2005-08-24
    2015-02-04
'''

Persian rug from [persia.org](http://persia.org/Images/Persian_Carpet/saruq_jpg1.html) is used without permission

### Linux and OSX

Instructions for serial (one-processor) benchmark:

1. Type "make" in the directory with this README file to run all of the
      steps necessary to render the benchmark scene.

2. Save the "user" time that is reported

Instructions for SMP (multi-processor, same computer) benchmark:

1. Type "make smp" in the directory with this README file to run all of
      the steps necessary to render the benchmark scene on an SMP computer
      with 4 processors.

      To run use a different number or processors, prepend "NCPU=#" to
      the make command. For 8 processors, run "NCPU=8 make smp".

2. Save the "elapsed" time that is reported, it should be the time used
      by the process that took the longest.

Instructions for cluster (multi-computer, networked file system) benchmark:
   *** NOT YET IMPLEMENTED ***

0. Create a ranimate-format file that contains the list of hosts that
      are to be used, and the number of processors on each host, like this:

      host= localhost 2
      host= zeus 2
      host= bacchus 1

1. Type "make cluster" in the directory with this README file to run
      all of the steps necessary to render the benchmark scene.

2. Save the "user" time that is reported

Then, continue with the data collection:

3. using whatever means possible for your system, assemble the following
      information:

      * processor type, number (if symmetric multiprocessor/SMP), and speed
         "cat /proc/cpuinfo" for some Linux flavors
         "sysctl -n machdep.cpu.brand_string" for OSX
      * cache RAM (main RAM isn't important)
         "cat /proc/cpuinfo" for some Linux flavors for cache memory size
         "top" and read the header lines for main memory size
      * operating system name
         "uname -a" for some Unixes
      * radiance version
         "rpict -version"
      * compiler version
         "gcc --version" for Gnu C compiler
      * compiler options (only if you changed them)

4. mail the information to me (mstock@umich.edu)


### Windows

Instructions for serial (one-processor) benchmark:

1. Type "runbench.bat" in the directory with this README file to run
      all of the steps necessary to render the benchmark scene.

2. Save the total time that is reported at the end of the output.

Then, continue with the data collection:

3. using whatever means possible for your system, assemble the following
      information:

      * processor type, number (if symmetric multiprocessor/SMP), and speed
      * cache RAM (main RAM isn't important)
      * operating system name
      * radiance version
      * compiler version
      * compiler options (only if you changed them)

4. mail the information to me (mstock@umich.edu)


Thank you! Changes will appear on the [Radiance Benchmark Results Page](http://markjstock.org/pages/rad_bench.html).

### CHANGES
'''
2010-12-01  MJS  reworked Makefile and options so that same code will
                 work on any version of Radiance going back ~5 years
2011-03-24  MJS  removed "-pm 0.0" from optionsbase because rpiece throws
                 an error in 4R1 
2013-10-14  MJS  Added Windows batch file and "options" file from Guy
                 Vaessen, also converted "cat" commands to "xform".
2015-02-04  MJS  Fixed bug in Makefile on OSX, changed smp defaults to
                 4 cpus and 64 rows, reverted sky back to original
'''

