Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35166 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfLVNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 22 Dec 2019 08:00:04 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ij0q4-0002qj-Br
        for fio@vger.kernel.org; Sun, 22 Dec 2019 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191222130001.922131BC016F@kernel.dk>
Date: Sun, 22 Dec 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8d853d0bbf4487af9445f7253c1951970ce75200:

  Merge branch 'mine/patch-2' of https://github.com/hannesweisbach/fio (2019-12-19 05:38:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ab1665679b00fd2b3f955596da837d9694732b24:

  Merge branch 'doc_fixes' of https://github.com/sitsofe/fio (2019-12-21 07:04:58 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'travis' of https://github.com/sitsofe/fio
      Merge branch 'doc_fixes' of https://github.com/sitsofe/fio

Sitsofe Wheeler (5):
      travis: remove duplicate xcode image and add comments
      travis: switch to ubuntu 18.04 and install more libraries
      doc: stop saying backslashes need escaping
      HOWTO: fix up broken formatting in registerfiles section
      doc: fix up sphinx warnings

 .travis.yml |  9 ++++-----
 HOWTO       | 13 +++++++------
 doc/conf.py |  2 +-
 fio.1       |  8 ++++----
 4 files changed, 16 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/.travis.yml b/.travis.yml
index eee31988..77c31b77 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,4 +1,5 @@
 language: c
+dist: bionic
 os:
   - linux
 compiler:
@@ -12,13 +13,11 @@ env:
     - MAKEFLAGS="-j 2"
 matrix:
   include:
+    # Default xcode image
     - os: osx
       compiler: clang # Workaround travis setting CC=["clang", "gcc"]
       env: BUILD_ARCH="x86_64"
-    - os: osx
-      compiler: clang
-      osx_image: xcode9.4
-      env: BUILD_ARCH="x86_64"
+    # Latest xcode image (needs periodic updating)
     - os: osx
       compiler: clang
       osx_image: xcode11.2
@@ -33,7 +32,7 @@ matrix:
 before_install:
   - EXTRA_CFLAGS="-Werror"
   - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
-        pkgs=(libaio-dev libnuma-dev libz-dev librbd-dev libibverbs-dev librdmacm-dev libcunit1 libcunit1-dev);
+        pkgs=(libaio-dev libcunit1 libcunit1-dev libgoogle-perftools4 libibverbs-dev libiscsi-dev libnuma-dev librbd-dev librdmacm-dev libz-dev);
         if [[ "$BUILD_ARCH" == "x86" ]]; then
             pkgs=("${pkgs[@]/%/:i386}");
             pkgs+=(gcc-multilib python-scipy);
diff --git a/HOWTO b/HOWTO
index 41a667af..41d32c04 100644
--- a/HOWTO
+++ b/HOWTO
@@ -765,8 +765,8 @@ Target file/device
 	`filename` semantic (which generates a file for each clone if not
 	specified, but lets all clones use the same file if set).
 
-	See the :option:`filename` option for information on how to escape "``:``" and
-	"``\``" characters within the directory path itself.
+	See the :option:`filename` option for information on how to escape "``:``"
+	characters within the directory path itself.
 
 	Note: To control the directory fio will use for internal state files
 	use :option:`--aux-path`.
@@ -785,10 +785,10 @@ Target file/device
 	by this option will be :option:`size` divided by number of files unless an
 	explicit size is specified by :option:`filesize`.
 
-	Each colon and backslash in the wanted path must be escaped with a ``\``
+	Each colon in the wanted path must be escaped with a ``\``
 	character.  For instance, if the path is :file:`/dev/dsk/foo@3,0:c` then you
 	would use ``filename=/dev/dsk/foo@3,0\:c`` and if the path is
-	:file:`F:\\filename` then you would use ``filename=F\:\\filename``.
+	:file:`F:\\filename` then you would use ``filename=F\:\filename``.
 
 	On Windows, disk devices are accessed as :file:`\\\\.\\PhysicalDrive0` for
 	the first device, :file:`\\\\.\\PhysicalDrive1` for the second etc.
@@ -2046,6 +2046,7 @@ with the caveat that when used on the command line, they must come after the
 	IO latency as well.
 
 .. option:: registerfiles : [io_uring]
+
 	With this option, fio registers the set of files being used with the
 	kernel. This avoids the overhead of managing file counts in the kernel,
 	making the submission and completion part more lightweight. Required
@@ -2564,7 +2565,7 @@ I/O replay
 	(``blkparse <device> -o /dev/null -d file_for_fio.bin``).
 	You can specify a number of files by separating the names with a ':'
 	character. See the :option:`filename` option for information on how to
-	escape ':' and '\' characters within the file names. These files will
+	escape ':' characters within the file names. These files will
 	be sequentially assigned to job clones created by :option:`numjobs`.
 
 .. option:: read_iolog_chunked=bool
@@ -3990,7 +3991,7 @@ only file passed to :option:`read_iolog`. An example would look like::
 	$ fio --read_iolog="<file1>:<file2>" --merge_blktrace_file="<output_file>"
 
 Creating only the merged file can be done by passing the command line argument
-:option:`merge-blktrace-only`.
+:option:`--merge-blktrace-only`.
 
 Scaling traces can be done to see the relative impact of any particular trace
 being slowed down or sped up. :option:`merge_blktrace_scalars` takes in a colon
diff --git a/doc/conf.py b/doc/conf.py
index 087a9a11..10b72ecb 100644
--- a/doc/conf.py
+++ b/doc/conf.py
@@ -177,7 +177,7 @@ html_theme = 'alabaster'
 # Add any paths that contain custom static files (such as style sheets) here,
 # relative to this directory. They are copied after the builtin static files,
 # so a file named "default.css" will overwrite the builtin "default.css".
-html_static_path = ['_static']
+# html_static_path = ['_static']
 
 # Add any extra paths that contain custom files (such as robots.txt or
 # .htaccess) here, relative to this directory. These files are copied
diff --git a/fio.1 b/fio.1
index a60863f6..cf5dd853 100644
--- a/fio.1
+++ b/fio.1
@@ -536,7 +536,7 @@ set fio will use the first listed directory, and thereby matching the
 specified, but lets all clones use the same file if set).
 .RS
 .P
-See the \fBfilename\fR option for information on how to escape ':' and '\\'
+See the \fBfilename\fR option for information on how to escape ':'
 characters within the directory path itself.
 .P
 Note: To control the directory fio will use for internal state files
@@ -557,10 +557,10 @@ by this option will be \fBsize\fR divided by number of files unless an
 explicit size is specified by \fBfilesize\fR.
 .RS
 .P
-Each colon and backslash in the wanted path must be escaped with a '\\'
+Each colon in the wanted path must be escaped with a '\\'
 character. For instance, if the path is `/dev/dsk/foo@3,0:c' then you
 would use `filename=/dev/dsk/foo@3,0\\:c' and if the path is
-`F:\\filename' then you would use `filename=F\\:\\\\filename'.
+`F:\\filename' then you would use `filename=F\\:\\filename'.
 .P
 On Windows, disk devices are accessed as `\\\\.\\PhysicalDrive0' for
 the first device, `\\\\.\\PhysicalDrive1' for the second etc.
@@ -2277,7 +2277,7 @@ to replay a workload captured by blktrace. See
 replay, the file needs to be turned into a blkparse binary data file first
 (`blkparse <device> \-o /dev/null \-d file_for_fio.bin').
 You can specify a number of files by separating the names with a ':' character.
-See the \fBfilename\fR option for information on how to escape ':' and '\'
+See the \fBfilename\fR option for information on how to escape ':'
 characters within the file names. These files will be sequentially assigned to
 job clones created by \fBnumjobs\fR.
 .TP

