Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgHHMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Aug 2020 08:00:08 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A965C061756
        for <fio@vger.kernel.org>; Sat,  8 Aug 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k4NW7-0002eB-U3
        for fio@vger.kernel.org; Sat, 08 Aug 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200808120001.A63CD1BC004F@kernel.dk>
Date: Sat,  8 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 87622bf5295880682bfad5ba14116cf5facbaf2c:

  Merge branch 'master' of https://github.com/bvanassche/fio into master (2020-08-01 15:07:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f0ed01ed095cf1ca7c1945a5a0267e8f73b7b4a9:

  Merge branch 'master' of https://github.com/donny372/fio into master (2020-08-07 18:21:52 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/donny372/fio into master

donny372 (1):
      Add support for reading iolog from stdin.

 HOWTO   |  3 +++
 fio.1   |  4 +++-
 init.c  | 12 ++++++++++++
 iolog.c |  2 ++
 4 files changed, 20 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 35ead0cb..e0403b08 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2625,6 +2625,9 @@ I/O replay
 	character. See the :option:`filename` option for information on how to
 	escape ':' characters within the file names. These files will
 	be sequentially assigned to job clones created by :option:`numjobs`.
+	'-' is a reserved name, meaning read from stdin, notably if
+	:option:`filename` is set to '-' which means stdin as well, then
+	this flag can't be set to '-'.
 
 .. option:: read_iolog_chunked=bool
 
diff --git a/fio.1 b/fio.1
index a3d348b2..cdd105d7 100644
--- a/fio.1
+++ b/fio.1
@@ -2336,7 +2336,9 @@ replay, the file needs to be turned into a blkparse binary data file first
 You can specify a number of files by separating the names with a ':' character.
 See the \fBfilename\fR option for information on how to escape ':'
 characters within the file names. These files will be sequentially assigned to
-job clones created by \fBnumjobs\fR.
+job clones created by \fBnumjobs\fR. '-' is a reserved name, meaning read from
+stdin, notably if \fBfilename\fR is set to '-' which means stdin as well,
+then this flag can't be set to '-'.
 .TP
 .BI read_iolog_chunked \fR=\fPbool
 Determines how iolog is read. If false (default) entire \fBread_iolog\fR will
diff --git a/init.c b/init.c
index 3710e3d4..84325f1e 100644
--- a/init.c
+++ b/init.c
@@ -2068,6 +2068,18 @@ static int __parse_jobs_ini(struct thread_data *td,
 		}
 
 		ret = fio_options_parse(td, opts, num_opts);
+
+		if (!ret) {
+			if (!strcmp(file, "-") && td->o.read_iolog_file != NULL) {
+				char *fname = get_name_by_idx(td->o.read_iolog_file,
+							      td->subjob_number);
+				if (!strcmp(fname, "-")) {
+					log_err("fio: we can't read both iolog "
+						"and job file from stdin.\n");
+					ret = 1;
+				}
+			}
+		}
 		if (!ret) {
 			if (dump_cmdline)
 				dump_opt_list(td);
diff --git a/iolog.c b/iolog.c
index 4af10da3..7f21be51 100644
--- a/iolog.c
+++ b/iolog.c
@@ -620,6 +620,8 @@ static bool init_iolog_read(struct thread_data *td)
 		fd = open_socket(fname);
 		if (fd >= 0)
 			f = fdopen(fd, "r");
+	} else if (!strcmp(fname, "-")) {
+		f = stdin;
 	} else
 		f = fopen(fname, "r");
 

