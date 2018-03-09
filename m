Return-Path: <prvs=599e16e30=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Makefile: Rerun the configure script if it has been modified
Date: Fri,  9 Mar 2018 08:51:04 -0800
Message-Id: <20180309165104.16860-1-bart.vanassche@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Because of a typo in the Makefile ("config-host-mak") the configure
script is not rerun if the configure script is modified after
config-host.mak has been generated. Merge the two make goals for
rerunning configure into a single goal. This patch relies on the
following make behavior (see also https://www.gnu.org/software/make/manual/make.html#Remaking-Makefiles):

  Sometimes makefiles can be remade from other files, such as RCS or SCCS
  files. If a makefile can be remade from other files, you probably want
  make to get an up-to-date version of the makefile to read in.

  To this end, after reading in all makefiles, make will consider each as a
  goal target and attempt to update it. If a makefile has a rule which says
  how to update it (found either in that very makefile or in another one) or
  if an implicit rule applies to it (see Using Implicit Rules), it will be
  updated if necessary. After all makefiles have been checked, if any have
  actually been changed, make starts with a clean slate and reads all the
  makefiles over again. (It will also attempt to update each of them over
  again, but normally this will not change them again, since they are
  already up to date.)

This patch has been tested by verifying that the commands run by make
were as expected for the following invocations:

rm -f config-host.mak && make
make && touch configure && make
make

Note: fio already requires GNU make because of the use of "ifeq" etc.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 Makefile | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 19ba40a07870..d73b944fa20f 100644
--- a/Makefile
+++ b/Makefile
@@ -4,19 +4,18 @@ endif
 
 VPATH := $(SRCDIR)
 
-ifneq ($(wildcard config-host.mak),)
-all:
-include config-host.mak
-config-host-mak: configure
-	@echo $@ is out-of-date, running configure
-	@sed -n "/.*Configured with/s/[^:]*: //p" $@ | sh
-else
-config-host.mak:
+all: fio
+
+config-host.mak: configure
+	@if [ ! -e "$@" ]; then					\
+	  echo "Running configure ...";				\
+	  ./configure;						\
+	else							\
+	  echo "$@ is out-of-date, running configure";		\
+	  sed -n "/.*Configured with/s/[^:]*: //p" "$@" | sh;	\
+	fi
+
 ifneq ($(MAKECMDGOALS),clean)
-	@echo "Running configure for you..."
-	@./configure
-endif
-all:
 include config-host.mak
 endif
 
-- 
2.16.2


