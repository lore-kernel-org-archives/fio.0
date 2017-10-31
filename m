Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41377 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdJaMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 Oct 2017 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9VDH-0007zU-Ak
        for fio@vger.kernel.org; Tue, 31 Oct 2017 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171031120002.5CE8B2C00A1@kernel.dk>
Date: Tue, 31 Oct 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 11fd6aa8569c55c8488020e4e315d550d121ff79:

  Fix 'nice' parameter range: should be -20 to 19, not -19 to 20. (2017-10-26 15:31:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e2b7f9fb0d105de217fe97817b47c594232ac14f:

  Merge branch 'misc' of https://github.com/sitsofe/fio (2017-10-30 09:05:43 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'misc' of https://github.com/sitsofe/fio

Sitsofe Wheeler (9):
      steadystate_tests.py: fix up usage comment
      tools: use /usr/bin/python2.7 as the interpreter
      fio: fix interpreter lines
      doc: fix groff line that started with a dot
      COPYING: update license file
      fio: update FSF address
      doc: IO -> I/O, sync filecreate documentation
      doc: minor formatting fixes
      doc: rewrite write_*_log sections

 COPYING                           | 39 ++++++++++----------
 HOWTO                             | 78 +++++++++++++++++++--------------------
 backend.c                         |  2 +-
 crc/crc32.c                       |  2 +-
 crc/crc32.h                       |  2 +-
 crc/crc32c.h                      |  2 +-
 doc/conf.py                       |  1 -
 engines/pmemblk.c                 |  4 +-
 exp/expression-parser.l           |  2 +-
 exp/expression-parser.y           |  2 +-
 exp/test-expression-parser.c      |  2 +-
 fifo.c                            |  2 +-
 fifo.h                            |  2 +-
 fio.1                             | 77 +++++++++++++++++++-------------------
 fio.c                             |  2 +-
 gfio.c                            |  2 +-
 graph.c                           |  2 +-
 lib/rbtree.c                      |  2 +-
 lib/rbtree.h                      |  2 +-
 libfio.c                          |  2 +-
 oslib/libmtd.c                    |  2 +-
 oslib/libmtd.h                    |  2 +-
 oslib/libmtd_common.h             |  2 +-
 oslib/libmtd_int.h                |  2 +-
 oslib/libmtd_legacy.c             |  2 +-
 oslib/libmtd_xalloc.h             |  2 +-
 tools/fio_jsonplus_clat2csv       |  2 +-
 tools/fiologparser.py             |  3 +-
 tools/genfio                      |  4 +-
 tools/hist/fiologparser_hist.py   |  2 +-
 tools/hist/fiologparser_hist.py.1 |  2 +-
 tools/hist/half-bins.py           |  3 +-
 tools/plot/fio2gnuplot            |  4 +-
 unit_tests/steadystate_tests.py   |  4 +-
 34 files changed, 131 insertions(+), 134 deletions(-)

---

Diff of recent changes:

diff --git a/COPYING b/COPYING
index 5b6e7c6..d159169 100644
--- a/COPYING
+++ b/COPYING
@@ -1,12 +1,12 @@
-		    GNU GENERAL PUBLIC LICENSE
-		       Version 2, June 1991
+                    GNU GENERAL PUBLIC LICENSE
+                       Version 2, June 1991
 
- Copyright (C) 1989, 1991 Free Software Foundation, Inc.
-                       59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
+ 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
-			    Preamble
+                            Preamble
 
   The licenses for most software are designed to take away your
 freedom to share and change it.  By contrast, the GNU General Public
@@ -15,7 +15,7 @@ software--to make sure the software is free for all its users.  This
 General Public License applies to most of the Free Software
 Foundation's software and to any other program whose authors commit to
 using it.  (Some other Free Software Foundation software is covered by
-the GNU Library General Public License instead.)  You can apply it to
+the GNU Lesser General Public License instead.)  You can apply it to
 your programs, too.
 
   When we speak of free software, we are referring to freedom, not
@@ -55,8 +55,8 @@ patent must be licensed for everyone's free use or not licensed at all.
 
   The precise terms and conditions for copying, distribution and
 modification follow.
-
-		    GNU GENERAL PUBLIC LICENSE
+
+                    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
   0. This License applies to any program or other work which contains
@@ -110,7 +110,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-
+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -168,7 +168,7 @@ access to copy from a designated place, then offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-
+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -225,7 +225,7 @@ impose that choice.
 
 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-
+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
@@ -255,7 +255,7 @@ make exceptions for this.  Our decision will be guided by the two goals
 of preserving the free status of all derivatives of our free software and
 of promoting the sharing and reuse of software generally.
 
-			    NO WARRANTY
+                            NO WARRANTY
 
   11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
 FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
@@ -277,9 +277,9 @@ YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
 PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
 
-		     END OF TERMS AND CONDITIONS
-
-	    How to Apply These Terms to Your New Programs
+                     END OF TERMS AND CONDITIONS
+
+            How to Apply These Terms to Your New Programs
 
   If you develop a new program, and you want it to be of the greatest
 possible use to the public, the best way to achieve this is to make it
@@ -303,10 +303,9 @@ the "copyright" line and a pointer to where the full notice is found.
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-
+    You should have received a copy of the GNU General Public License along
+    with this program; if not, write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 
 Also add information on how to contact you by electronic and paper mail.
 
@@ -336,5 +335,5 @@ necessary.  Here is a sample; alter the names:
 This General Public License does not permit incorporating your program into
 proprietary programs.  If your program is a subroutine library, you may
 consider it more useful to permit linking proprietary applications with the
-library.  If this is what you want to do, use the GNU Library General
+library.  If this is what you want to do, use the GNU Lesser General
 Public License instead of this License.
diff --git a/HOWTO b/HOWTO
index e7142c5..f151350 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1815,9 +1815,9 @@ I/O engine
 			details of writing an external I/O engine.
 
 		**filecreate**
-			Simply create the files and do no IO to them.  You still need to
+			Simply create the files and do no I/O to them.  You still need to
 			set  `filesize` so that all the accounting still occurs, but no
-			actual IO will be done other than creating the file.
+			actual I/O will be done other than creating the file.
 
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -2060,7 +2060,7 @@ I/O depth
 	changing data and the overlapping region has a non-zero size. Setting
 	``serialize_overlap`` tells fio to avoid provoking this behavior by explicitly
 	serializing in-flight I/Os that have a non-zero overlap. Note that setting
-	this option can reduce both performance and the `:option:iodepth` achieved.
+	this option can reduce both performance and the :option:`iodepth` achieved.
 	Additionally this option does not work when :option:`io_submit_mode` is set to
 	offload. Default: false.
 
@@ -2722,47 +2722,46 @@ Measurements and reporting
 .. option:: write_bw_log=str
 
 	If given, write a bandwidth log for this job. Can be used to store data of
-	the bandwidth of the jobs in their lifetime. The included
-	:command:`fio_generate_plots` script uses :command:`gnuplot` to turn these
-	text files into nice graphs. See :option:`write_lat_log` for behavior of
-	given filename. For this option, the postfix is :file:`_bw.x.log`, where `x`
-	is the index of the job (`1..N`, where `N` is the number of jobs). If
-	:option:`per_job_logs` is false, then the filename will not include the job
-	index.  See `Log File Formats`_.
+	the bandwidth of the jobs in their lifetime.
 
-.. option:: write_lat_log=str
+	If no str argument is given, the default filename of
+	:file:`jobname_type.x.log` is used. Even when the argument is given, fio
+	will still append the type of log. So if one specifies::
+
+		write_bw_log=foo
 
-	Same as :option:`write_bw_log`, except that this option stores I/O
-	submission, completion, and total latencies instead. If no filename is given
-	with this option, the default filename of :file:`jobname_type.log` is
-	used. Even if the filename is given, fio will still append the type of
-	log. So if one specifies::
+	The actual log name will be :file:`foo_bw.x.log` where `x` is the index
+	of the job (`1..N`, where `N` is the number of jobs). If
+	:option:`per_job_logs` is false, then the filename will not include the
+	`.x` job index.
 
-		write_lat_log=foo
+	The included :command:`fio_generate_plots` script uses :command:`gnuplot` to turn these
+	text files into nice graphs. See `Log File Formats`_ for how data is
+	structured within the file.
+
+.. option:: write_lat_log=str
 
-	The actual log names will be :file:`foo_slat.x.log`, :file:`foo_clat.x.log`,
-	and :file:`foo_lat.x.log`, where `x` is the index of the job (`1..N`, where `N`
-	is the number of jobs). This helps :command:`fio_generate_plots` find the
-	logs automatically. If :option:`per_job_logs` is false, then the filename
-	will not include the job index.  See `Log File Formats`_.
+	Same as :option:`write_bw_log`, except this option creates I/O
+	submission (e.g., `file:`name_slat.x.log`), completion (e.g.,
+	`file:`name_clat.x.log`), and total (e.g., `file:`name_lat.x.log`)
+	latency files instead. See :option:`write_bw_log` for details about
+	the filename format and `Log File Formats`_ for how data is structured
+	within the files.
 
 .. option:: write_hist_log=str
 
-	Same as :option:`write_lat_log`, but writes I/O completion latency
-	histograms. If no filename is given with this option, the default filename
-	of :file:`jobname_clat_hist.x.log` is used, where `x` is the index of the
-	job (`1..N`, where `N` is the number of jobs). Even if the filename is given,
-	fio will still append the type of log.  If :option:`per_job_logs` is false,
-	then the filename will not include the job index. See `Log File Formats`_.
+	Same as :option:`write_bw_log` but writes an I/O completion latency
+	histogram file (e.g., `file:`name_hist.x.log`) instead. Note that this
+	file will be empty unless :option:`log_hist_msec` has also been set.
+	See :option:`write_bw_log` for details about the filename format and
+	`Log File Formats`_ for how data is structured within the file.
 
 .. option:: write_iops_log=str
 
-	Same as :option:`write_bw_log`, but writes IOPS. If no filename is given
-	with this option, the default filename of :file:`jobname_type.x.log` is
-	used, where `x` is the index of the job (`1..N`, where `N` is the number of
-	jobs). Even if the filename is given, fio will still append the type of
-	log. If :option:`per_job_logs` is false, then the filename will not include
-	the job index. See `Log File Formats`_.
+	Same as :option:`write_bw_log`, but writes an IOPS file (e.g.
+	`file:`name_iops.x.log`) instead. See :option:`write_bw_log` for
+	details about the filename format and `Log File Formats`_ for how data
+	is structured within the file.
 
 .. option:: log_avg_msec=int
 
@@ -2780,15 +2779,16 @@ Measurements and reporting
 	:option:`log_avg_msec` is inaccurate. Setting this option makes fio log
 	histogram entries over the specified period of time, reducing log sizes for
 	high IOPS devices while retaining percentile accuracy.  See
-	:option:`log_hist_coarseness` as well. Defaults to 0, meaning histogram
-	logging is disabled.
+	:option:`log_hist_coarseness` and :option:`write_hist_log` as well.
+	Defaults to 0, meaning histogram logging is disabled.
 
 .. option:: log_hist_coarseness=int
 
 	Integer ranging from 0 to 6, defining the coarseness of the resolution of
 	the histogram logs enabled with :option:`log_hist_msec`. For each increment
 	in coarseness, fio outputs half as many bins. Defaults to 0, for which
-	histogram logs contain 1216 latency bins. See `Log File Formats`_.
+	histogram logs contain 1216 latency bins. See :option:`write_hist_log`
+	and `Log File Formats`_.
 
 .. option:: log_max_value=bool
 
@@ -2888,7 +2888,7 @@ Measurements and reporting
 
 .. option:: lat_percentiles=bool
 
-	Enable the reporting of percentiles of IO latencies. This is similar
+	Enable the reporting of percentiles of I/O latencies. This is similar
 	to :option:`clat_percentiles`, except that this includes the
 	submission latency. This option is mutually exclusive with
 	:option:`clat_percentiles`.
@@ -3258,7 +3258,7 @@ writes in the example above).  In the order listed, they denote:
 		short or dropped.
 
 **IO latency**
-		These values are for `--latency-target` and related options. When
+		These values are for :option:`latency_target` and related options. When
 		these options are engaged, this section describes the I/O depth required
 		to meet the specified latency target.
 
diff --git a/backend.c b/backend.c
index d98e5fe..c14f37c 100644
--- a/backend.c
+++ b/backend.c
@@ -18,7 +18,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 #include <unistd.h>
diff --git a/crc/crc32.c b/crc/crc32.c
index 657031d..4140a8d 100644
--- a/crc/crc32.c
+++ b/crc/crc32.c
@@ -13,7 +13,7 @@
 
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */
 
 #include <inttypes.h>
 #include "crc32.h"
diff --git a/crc/crc32.h b/crc/crc32.h
index 674057b..a37d7ad 100644
--- a/crc/crc32.h
+++ b/crc/crc32.h
@@ -13,7 +13,7 @@
 
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */
 
 #ifndef CRC32_H
 #define CRC32_H
diff --git a/crc/crc32c.h b/crc/crc32c.h
index d513f3a..be03c1a 100644
--- a/crc/crc32c.h
+++ b/crc/crc32c.h
@@ -13,7 +13,7 @@
 
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
-   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
+   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */
 
 #ifndef CRC32C_H
 #define CRC32C_H
diff --git a/doc/conf.py b/doc/conf.py
index 4102140..d4dd9d2 100644
--- a/doc/conf.py
+++ b/doc/conf.py
@@ -1,4 +1,3 @@
-#!/usr/bin/env python3
 # -*- coding: utf-8 -*-
 #
 # fio documentation build configuration file, created by
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 52af9ed..5d21915 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -14,8 +14,8 @@
  *
  * You should have received a copy of the GNU General Public
  * License along with this program; if not, write to the Free
- * Software Foundation, Inc., 59 Temple Place, Suite 330,
- * Boston, MA 02111-1307 USA
+ * Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
  */
 
 /*
diff --git a/exp/expression-parser.l b/exp/expression-parser.l
index 50bd383..692c6cc 100644
--- a/exp/expression-parser.l
+++ b/exp/expression-parser.l
@@ -14,7 +14,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 
diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index d664b8e..04a6e07 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -14,7 +14,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 
diff --git a/exp/test-expression-parser.c b/exp/test-expression-parser.c
index bf3fb3e..e22f24d 100644
--- a/exp/test-expression-parser.c
+++ b/exp/test-expression-parser.c
@@ -15,7 +15,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 
diff --git a/fifo.c b/fifo.c
index 81d13b5..98737e9 100644
--- a/fifo.c
+++ b/fifo.c
@@ -15,7 +15,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 
diff --git a/fifo.h b/fifo.h
index 4b775b0..5e3d339 100644
--- a/fifo.h
+++ b/fifo.h
@@ -17,7 +17,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 #include "minmax.h"
diff --git a/fio.1 b/fio.1
index 96d8f11..198b9d8 100644
--- a/fio.1
+++ b/fio.1
@@ -1593,8 +1593,9 @@ absolute or relative. See `engines/skeleton_external.c' in the fio source for
 details of writing an external I/O engine.
 .TP
 .B filecreate
-Create empty files only.  \fBfilesize\fR still needs to be specified so that fio
-will run and grab latency results, but no IO will actually be done on the files.
+Simply create the files and do no I/O to them.  You still need to set
+\fBfilesize\fR so that all the accounting still occurs, but no actual I/O will be
+done other than creating the file.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2419,48 +2420,48 @@ the final stat output.
 .TP
 .BI write_bw_log \fR=\fPstr
 If given, write a bandwidth log for this job. Can be used to store data of
-the bandwidth of the jobs in their lifetime. The included
-\fBfio_generate_plots\fR script uses gnuplot to turn these
-text files into nice graphs. See \fBwrite_lat_log\fR for behavior of
-given filename. For this option, the postfix is `_bw.x.log', where `x'
-is the index of the job (1..N, where N is the number of jobs). If
-\fBper_job_logs\fR is false, then the filename will not include the job
-index. See \fBLOG FILE FORMATS\fR section.
-.TP
-.BI write_lat_log \fR=\fPstr
-Same as \fBwrite_bw_log\fR, except that this option stores I/O
-submission, completion, and total latencies instead. If no filename is given
-with this option, the default filename of `jobname_type.log' is
-used. Even if the filename is given, fio will still append the type of
-log. So if one specifies:
+the bandwidth of the jobs in their lifetime.
 .RS
+.P
+If no str argument is given, the default filename of
+`jobname_type.x.log' is used. Even when the argument is given, fio
+will still append the type of log. So if one specifies:
 .RS
 .P
-write_lat_log=foo
+write_bw_log=foo
 .RE
 .P
-The actual log names will be `foo_slat.x.log', `foo_clat.x.log',
-and `foo_lat.x.log', where `x' is the index of the job (1..N, where N
-is the number of jobs). This helps \fBfio_generate_plots\fR find the
-logs automatically. If \fBper_job_logs\fR is false, then the filename
-will not include the job index. See \fBLOG FILE FORMATS\fR section.
+The actual log name will be `foo_bw.x.log' where `x' is the index
+of the job (1..N, where N is the number of jobs). If
+\fBper_job_logs\fR is false, then the filename will not include the
+`.x` job index.
+.P
+The included \fBfio_generate_plots\fR script uses gnuplot to turn these
+text files into nice graphs. See the \fBLOG FILE FORMATS\fR section for how data is
+structured within the file.
 .RE
 .TP
+.BI write_lat_log \fR=\fPstr
+Same as \fBwrite_bw_log\fR, except this option creates I/O
+submission (e.g., `name_slat.x.log'), completion (e.g.,
+`name_clat.x.log'), and total (e.g., `name_lat.x.log') latency
+files instead. See \fBwrite_bw_log\fR for details about the
+filename format and the \fBLOG FILE FORMATS\fR section for how data is structured
+within the files.
+.TP
 .BI write_hist_log \fR=\fPstr
-Same as \fBwrite_lat_log\fR, but writes I/O completion latency
-histograms. If no filename is given with this option, the default filename
-of `jobname_clat_hist.x.log' is used, where `x' is the index of the
-job (1..N, where N is the number of jobs). Even if the filename is given,
-fio will still append the type of log. If \fBper_job_logs\fR is false,
-then the filename will not include the job index. See \fBLOG FILE FORMATS\fR section.
+Same as \fBwrite_bw_log\fR but writes an I/O completion latency
+histogram file (e.g., `name_hist.x.log') instead. Note that this
+file will be empty unless \fBlog_hist_msec\fR has also been set.
+See \fBwrite_bw_log\fR for details about the filename format and
+the \fBLOG FILE FORMATS\fR section for how data is structured
+within the file.
 .TP
 .BI write_iops_log \fR=\fPstr
-Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given
-with this option, the default filename of `jobname_type.x.log' is
-used, where `x' is the index of the job (1..N, where N is the number of
-jobs). Even if the filename is given, fio will still append the type of
-log. If \fBper_job_logs\fR is false, then the filename will not include
-the job index. See \fBLOG FILE FORMATS\fR section.
+Same as \fBwrite_bw_log\fR, but writes an IOPS file (e.g.
+`name_iops.x.log') instead. See \fBwrite_bw_log\fR for
+details about the filename format and the \fBLOG FILE FORMATS\fR section for how data
+is structured within the file.
 .TP
 .BI log_avg_msec \fR=\fPint
 By default, fio will log an entry in the iops, latency, or bw log for every
@@ -2476,8 +2477,8 @@ histograms. Computing latency percentiles from averages of intervals using
 \fBlog_avg_msec\fR is inaccurate. Setting this option makes fio log
 histogram entries over the specified period of time, reducing log sizes for
 high IOPS devices while retaining percentile accuracy. See
-\fBlog_hist_coarseness\fR as well. Defaults to 0, meaning histogram
-logging is disabled.
+\fBlog_hist_coarseness\fR and \fBwrite_hist_log\fR as well.
+Defaults to 0, meaning histogram logging is disabled.
 .TP
 .BI log_hist_coarseness \fR=\fPint
 Integer ranging from 0 to 6, defining the coarseness of the resolution of
@@ -2567,7 +2568,7 @@ Enable the reporting of percentiles of completion latencies. This option is
 mutually exclusive with \fBlat_percentiles\fR.
 .TP
 .BI lat_percentiles \fR=\fPbool
-Enable the reporting of percentiles of IO latencies. This is similar to
+Enable the reporting of percentiles of I/O latencies. This is similar to
 \fBclat_percentiles\fR, except that this includes the submission latency.
 This option is mutually exclusive with \fBclat_percentiles\fR.
 .TP
@@ -2915,7 +2916,7 @@ The number of \fBread/write/trim\fR requests issued, and how many of them were
 short or dropped.
 .TP
 .B IO latency
-These values are for \fBlatency-target\fR and related options. When
+These values are for \fBlatency_target\fR and related options. When
 these options are engaged, this section describes the I/O depth required
 to meet the specified latency target.
 .RE
diff --git a/fio.c b/fio.c
index 7b3a50b..7b61ffc 100644
--- a/fio.c
+++ b/fio.c
@@ -18,7 +18,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 #include <unistd.h>
diff --git a/gfio.c b/gfio.c
index 7160c3a..d222a1c 100644
--- a/gfio.c
+++ b/gfio.c
@@ -18,7 +18,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 #include <locale.h>
diff --git a/graph.c b/graph.c
index c45954c..f82b52a 100644
--- a/graph.c
+++ b/graph.c
@@ -17,7 +17,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 #include <string.h>
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 883bc72..00a5a90 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -15,7 +15,7 @@
 
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 
   linux/lib/rbtree.c
 */
diff --git a/lib/rbtree.h b/lib/rbtree.h
index c6cfe4a..f31fc56 100644
--- a/lib/rbtree.h
+++ b/lib/rbtree.h
@@ -14,7 +14,7 @@
 
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
-  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 
   linux/include/linux/rbtree.h
 
diff --git a/libfio.c b/libfio.c
index 830759a..d9900ad 100644
--- a/libfio.c
+++ b/libfio.c
@@ -18,7 +18,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  */
 
diff --git a/oslib/libmtd.c b/oslib/libmtd.c
index 5d18871..385b9d2 100644
--- a/oslib/libmtd.c
+++ b/oslib/libmtd.c
@@ -14,7 +14,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  * Author: Artem Bityutskiy
  *
diff --git a/oslib/libmtd.h b/oslib/libmtd.h
index b5fd3f3..a0c90dc 100644
--- a/oslib/libmtd.h
+++ b/oslib/libmtd.h
@@ -13,7 +13,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  * Author: Artem Bityutskiy
  *
diff --git a/oslib/libmtd_common.h b/oslib/libmtd_common.h
index 35628fe..87f93b6 100644
--- a/oslib/libmtd_common.h
+++ b/oslib/libmtd_common.h
@@ -13,7 +13,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  */
 
 /* Imported from mtd-utils by dehrenberg */
diff --git a/oslib/libmtd_int.h b/oslib/libmtd_int.h
index cbe2ff5..a08e574 100644
--- a/oslib/libmtd_int.h
+++ b/oslib/libmtd_int.h
@@ -14,7 +14,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  * Author: Artem Bityutskiy
  *
diff --git a/oslib/libmtd_legacy.c b/oslib/libmtd_legacy.c
index 38dc2b7..137e80a 100644
--- a/oslib/libmtd_legacy.c
+++ b/oslib/libmtd_legacy.c
@@ -13,7 +13,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  *
  * Author: Artem Bityutskiy
  *
diff --git a/oslib/libmtd_xalloc.h b/oslib/libmtd_xalloc.h
index 532b80f..6ac595a 100644
--- a/oslib/libmtd_xalloc.h
+++ b/oslib/libmtd_xalloc.h
@@ -21,7 +21,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
  */
 
 #ifndef __MTD_UTILS_XALLOC_H__
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
index 64fdc9f..e63d6d8 100755
--- a/tools/fio_jsonplus_clat2csv
+++ b/tools/fio_jsonplus_clat2csv
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/python2.7
 #
 # fio_jsonplus_clat2csv
 #
diff --git a/tools/fiologparser.py b/tools/fiologparser.py
index 5a95009..8549859 100755
--- a/tools/fiologparser.py
+++ b/tools/fiologparser.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/python2.7
 #
 # fiologparser.py
 #
@@ -218,4 +218,3 @@ if __name__ == '__main__':
         print_all_stats(ctx, series)
     else:
         print_default(ctx, series)
-
diff --git a/tools/genfio b/tools/genfio
index 6800452..286d814 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -1,4 +1,4 @@
-#!/usr/bin/env bash
+#!/usr/bin/bash
 #
 #  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
 #  Author: Erwan Velu  <erwan@enovance.com>
@@ -17,7 +17,7 @@
 #
 #  You should have received a copy of the GNU General Public License
 #  along with this program; if not, write to the Free Software
-#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 
 BLK_SIZE=
 BLOCK_SIZE=4k
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index ad97a54..2e05b92 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python2.7
+#!/usr/bin/python2.7
 """ 
     Utility for converting *_clat_hist* files generated by fio into latency statistics.
     
diff --git a/tools/hist/fiologparser_hist.py.1 b/tools/hist/fiologparser_hist.py.1
index ed22c74..5dfacfe 100644
--- a/tools/hist/fiologparser_hist.py.1
+++ b/tools/hist/fiologparser_hist.py.1
@@ -17,7 +17,7 @@ end-time, samples, min, avg, median, 90%, 95%, 99%, max
 1000, 15, 192, 1678.107, 1788.859, 1856.076, 1880.040, 1899.208, 1888.000
 2000, 43, 152, 1642.368, 1714.099, 1816.659, 1845.552, 1888.131, 1888.000
 4000, 39, 1152, 1546.962, 1545.785, 1627.192, 1640.019, 1691.204, 1744
-...
+\[char46]..
 .fi
 .PP
 
diff --git a/tools/hist/half-bins.py b/tools/hist/half-bins.py
index d592af0..1bba8ff 100755
--- a/tools/hist/half-bins.py
+++ b/tools/hist/half-bins.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python2.7
+#!/usr/bin/python2.7
 """ Cut the number bins in half in fio histogram output. Example usage:
 
         $ half-bins.py -c 2 output_clat_hist.1.log > smaller_clat_hist.1.log
@@ -35,4 +35,3 @@ if __name__ == '__main__':
             'e.g. coarseness of 4 merges each 2^4 = 16 consecutive '
             'bins.')
     main(p.parse_args())
-
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index a703ae3..5d31f13 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/python2.7
 #
 #  Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
 #  Author: Erwan Velu  <erwan@enovance.com>
@@ -17,7 +17,7 @@
 #
 #  You should have received a copy of the GNU General Public License
 #  along with this program; if not, write to the Free Software
-#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 
 import os
 import fnmatch
diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
index 91c79a4..5a74f95 100755
--- a/unit_tests/steadystate_tests.py
+++ b/unit_tests/steadystate_tests.py
@@ -1,10 +1,10 @@
-#!/usr/bin/python
+#!/usr/bin/python2.7
 #
 # steadystate_tests.py
 #
 # Test option parsing and functonality for fio's steady state detection feature.
 #
-# steadystate_tests.py ./fio file-for-read-testing file-for-write-testing
+# steadystate_tests.py --read file-for-read-testing --write file-for-write-testing ./fio
 #
 # REQUIREMENTS
 # Python 2.6+
