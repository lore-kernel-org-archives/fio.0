Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbbCSMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Mar 2015 08:00:09 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YYZ7Q-0004tH-NY
	for fio@vger.kernel.org; Thu, 19 Mar 2015 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150319120005.4EA6440300@lyth.info>
Date: Thu, 19 Mar 2015 06:00:05 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7d1bb70f3d85d041b4b7dd926e98054fea980bdc:

  Scramble IO buffers unless explicitly told not (2015-03-17 18:11:07 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d8f1f7d4ef536ea04a6a5fbd0399d46f69ff4e60:

  Pack io_u/fio_file (2015-03-18 16:17:41 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Update documentation for zero_buffers
      Revert "Scramble IO buffers unless explicitly told not"
      Pack io_u/fio_file

Luca Maranzano (1):
      Addedd -z option to specify file size for filepaths fio files

 HOWTO        |    2 --
 file.h       |    2 +-
 fio.1        |    2 --
 io_u.c       |    3 +--
 ioengine.h   |    6 +++++-
 tools/genfio |    8 +++++++-
 6 files changed, 14 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0f7909d..f43f3ec 100644
--- a/HOWTO
+++ b/HOWTO
@@ -578,8 +578,6 @@ bs_is_seq_rand	If this option is set, fio will use the normal read,write
 
 zero_buffers	If this option is given, fio will init the IO buffers to
 		all zeroes. The default is to fill them with random data.
-		The resulting IO buffers will not be completely zeroed,
-		unless scramble_buffers is also turned off.
 
 refill_buffers	If this option is given, fio will refill the IO buffers
 		on every submit. The default is to only fill it at init
diff --git a/file.h b/file.h
index f7a1eae..fc47310 100644
--- a/file.h
+++ b/file.h
@@ -75,9 +75,9 @@ struct fio_file {
 	/*
 	 * filename and possible memory mapping
 	 */
-	char *file_name;
 	unsigned int major, minor;
 	int fileno;
+	char *file_name;
 
 	/*
 	 * size of the file, offset into file, and io size from that offset
diff --git a/fio.1 b/fio.1
index 84d71a0..3859753 100644
--- a/fio.1
+++ b/fio.1
@@ -462,8 +462,6 @@ blocksize setting.
 .TP
 .B zero_buffers
 Initialize buffers with all zeros. Default: fill buffers with random data.
-The resulting IO buffers will not be completely zeroed, unless
-\fPscramble_buffers\fR is also turned off.
 .TP
 .B refill_buffers
 If this option is given, fio will refill the IO buffers on every submit. The
diff --git a/io_u.c b/io_u.c
index a45dd40..975d242 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1484,8 +1484,7 @@ struct io_u *get_io_u(struct thread_data *td)
 				io_u_fill_buffer(td, io_u,
 					td->o.min_bs[DDIR_WRITE],
 					io_u->xfer_buflen);
-			}
-			if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
+			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
 			if (td->flags & TD_F_VER_NONE) {
diff --git a/ioengine.h b/ioengine.h
index 85923fc..f9a0235 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -46,11 +46,15 @@ struct io_u {
 	enum fio_ddir acct_ddir;
 
 	/*
+	 * Write generation
+	 */
+	unsigned short numberio;
+
+	/*
 	 * Allocated/set buffer and length
 	 */
 	unsigned long buflen;
 	unsigned long long offset;
-	unsigned short numberio;
 	void *buf;
 
 	/*
diff --git a/tools/genfio b/tools/genfio
index 4d32d13..6800452 100755
--- a/tools/genfio
+++ b/tools/genfio
@@ -54,6 +54,8 @@ show_help() {
 					Default is $IODEPTH
 -d disk1[,disk2,disk3,..]	: Run the tests on the selected disks
 					Separated each disk with a comma
+-z filesize                     : Specify the working file size, if you are passing filepaths to -d
+                                        Disabled by default
 -r seconds			: Time in seconds per benchmark
 					0 means till the end of the device
 					Default is $RUNTIME seconds
@@ -203,7 +205,7 @@ esac
 }
 
 parse_cmdline() {
-while getopts "hacpsd:b:r:m:x:D:A:B:" opt; do
+while getopts "hacpsd:b:r:m:x:z:D:A:B:" opt; do
   case $opt in
     h)
 	show_help
@@ -260,6 +262,10 @@ while getopts "hacpsd:b:r:m:x:D:A:B:" opt; do
     A)
 	echo "exec_postrun=$OPTARG" >> $TEMPLATE
       ;;
+    z)
+	FSIZE=$OPTARG
+	echo "size=$FSIZE" >> $TEMPLATE
+      ;;
     \?)
       echo "Invalid option: -$OPTARG" >&2
       ;;
