Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.oss.co.nz ([202.37.225.46]:32923 "EHLO mail.oss.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbZJ3CZX (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 29 Oct 2009 22:25:23 -0400
Date: Fri, 30 Oct 2009 15:25:21 +1300 (NZDT)
From: Glen Ogilvie <gogilvie@oss.co.nz>
Message-ID: <336580134.59771256869521664.JavaMail.root@zimbra.oss.co.nz>
In-Reply-To: <321292794.59661256869305878.JavaMail.root@zimbra.oss.co.nz>
Subject: fio-1.34.1, what we are doing with it and some patches we use.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2214_296709324.1256869521662"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>

------=_Part_2214_296709324.1256869521662
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Dear Jens Axboe and the FIO mailing list.

I have been working with Mike O'Sullivan, a senior lecturer at the University of
Auckland, New Zealand. He has been adapting fio 1.34.1 to work with
iolog files and also to be able to read a "wait" command to allow the iolog file to
specify a wait (in millisecs) before the next io. Mike's not completely
confident that his changes are correct in the overall fio picture, but
they are working with the iolog files we are using. What we did:

1) We incorporated wait into iolog file reading;
2) We made some modifications so that read_iolog worked.

We have attached a patch for fio-1.34.1.tar.bz2 along with some demonstration fio config files and
iolog files.

We are doing this so we can use an open source SPC-1 emulator to
generate SPC-1 like workloads and then run them in fio.

Hope some of this work is useful.   Feed back is welcome, we are not experts in FIO and SPC-1, so this may have problems.

Kind regards, Mike & Glen
------=_Part_2214_296709324.1256869521662
Content-Type: text/x-patch; name=fio-1.34.1-wait.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=fio-1.34.1-wait.patch

diff -urN fio-1.34.1-mike/fio.c fio-1.34.1/fio.c
--- fio-1.34.1-mike/fio.c	2009-10-25 17:09:12.000000000 +1300
+++ fio-1.34.1/fio.c	2009-10-02 06:45:31.000000000 +1300
@@ -581,8 +581,7 @@
 	else
 		td_set_runstate(td, TD_RUNNING);
 
-	while ( (td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
-	        ((td->this_io_bytes[0] + td->this_io_bytes[1]) < td->o.size) ) {
+	while ((td->this_io_bytes[0] + td->this_io_bytes[1]) < td->o.size) {
 		struct timeval comp_time;
 		unsigned long bytes_done[2] = { 0, 0 };
 		int min_evts = 0;
@@ -620,7 +619,6 @@
 			td_set_runstate(td, TD_RUNNING);
 
 		ret = td_io_queue(td, io_u);
-
 		switch (ret) {
 		case FIO_Q_COMPLETED:
 			if (io_u->error) {
diff -urN fio-1.34.1-mike/io_ddir.h fio-1.34.1/io_ddir.h
--- fio-1.34.1-mike/io_ddir.h	2009-10-23 09:47:25.000000000 +1300
+++ fio-1.34.1/io_ddir.h	2009-10-02 06:45:31.000000000 +1300
@@ -6,7 +6,6 @@
 	DDIR_WRITE,
 	DDIR_SYNC,
 	DDIR_DATASYNC,
-	DDIR_WAIT,
 	DDIR_INVAL = -1,
 };
 
diff -urN fio-1.34.1-mike/io_u.c fio-1.34.1/io_u.c
--- fio-1.34.1-mike/io_u.c	2009-10-25 17:08:37.000000000 +1300
+++ fio-1.34.1/io_u.c	2009-10-02 06:45:31.000000000 +1300
@@ -897,7 +897,6 @@
 	/*
 	 * If using an iolog, grab next piece if any available.
 	 */
-	 
 	if (td->o.read_iolog_file) {
 		if (read_iolog_get(td, io_u))
 			goto err_put;
diff -urN fio-1.34.1-mike/log.c fio-1.34.1/log.c
--- fio-1.34.1-mike/log.c	2006-01-02 08:12:22.000000000 +1300
+++ fio-1.34.1/log.c	2009-10-02 06:45:31.000000000 +1300
@@ -86,7 +86,10 @@
 	switch (ipo->file_action) {
 	case FIO_LOG_OPEN_FILE:
 		ret = td_io_open_file(td, f);
-		if (!ret) break;
+		if (!ret) {
+			free(ipo);
+			break;
+		}
 		td_verror(td, ret, "iolog open file");
 		return -1;
 	case FIO_LOG_CLOSE_FILE:
@@ -106,8 +109,7 @@
 int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_piece *ipo;
-	unsigned long elapsed;
-	
+
 	while (!flist_empty(&td->io_log_list)) {
 		int ret;
 
@@ -123,26 +125,20 @@
 			continue;
 		}
 
+		io_u->offset = ipo->offset;
+		io_u->buflen = ipo->len;
 		io_u->ddir = ipo->ddir;
-		if (ipo->ddir != DDIR_WAIT) {
-			io_u->offset = ipo->offset;
-			io_u->buflen = ipo->len;
-			io_u->file = td->files[ipo->fileno];
-			get_file(io_u->file);
-
-			dprint(FD_IO, "iolog: get %llu/%lu/%s\n", io_u->offset,
-						io_u->buflen, io_u->file->file_name);
-			if (ipo->delay) iolog_delay(td, ipo->delay);
-		} else {
-			elapsed = mtime_since_genesis();
-			if (ipo->delay > elapsed)
-				usec_sleep(td, (ipo->delay - elapsed) * 1000);
-				
-		}
+		io_u->file = td->files[ipo->fileno];
+		get_file(io_u->file);
+
+		dprint(FD_IO, "iolog: get %llu/%lu/%s\n", io_u->offset,
+					io_u->buflen, io_u->file->file_name);
+
+		if (ipo->delay)
+			iolog_delay(td, ipo->delay);
 
 		free(ipo);
-		
-		if (ipo->ddir != DDIR_WAIT)	return 0;
+		return 0;
 	}
 
 	td->done = 1;
@@ -245,7 +241,7 @@
 {
 	unsigned long long offset;
 	unsigned int bytes;
-	int reads, writes, waits, fileno = 0, file_action = 0; /* stupid gcc */
+	int reads, writes, fileno = 0, file_action = 0; /* stupid gcc */
 	char *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
@@ -260,7 +256,7 @@
 	fname = malloc(256+16);
 	act = malloc(256+16);
 
-	reads = writes = waits = 0;
+	reads = writes = 0;
 	while ((p = fgets(str, 4096, f)) != NULL) {
 		struct io_piece *ipo;
 		int r;
@@ -271,9 +267,6 @@
 			/*
 			 * Check action first
 			 */
-			if (!strcmp(act, "wait")) { /* MJO. 22 Oct 2009 - add wait to the iolog files */
-				rw = DDIR_WAIT;
-			} else 
 			if (!strcmp(act, "read"))
 				rw = DDIR_READ;
 			else if (!strcmp(act, "write"))
@@ -319,9 +312,6 @@
 			if (read_only)
 				continue;
 			writes++;
-		} else if (rw == DDIR_WAIT) {
-			waits++;
-		} else if (rw == DDIR_INVAL) {
 		} else if (!ddir_sync(rw)) {
 			log_err("bad ddir: %d\n", rw);
 			continue;
@@ -333,18 +323,15 @@
 		ipo = malloc(sizeof(*ipo));
 		memset(ipo, 0, sizeof(*ipo));
 		INIT_FLIST_HEAD(&ipo->list);
+		ipo->offset = offset;
+		ipo->len = bytes;
 		ipo->ddir = rw;
-		if (rw == DDIR_WAIT) {
-			ipo->delay = offset;
-		} else {
-			ipo->offset = offset;
-			ipo->len = bytes;
-			if (bytes > td->o.max_bs[rw])
-				td->o.max_bs[rw] = bytes;
+		if (bytes > td->o.max_bs[rw])
+			td->o.max_bs[rw] = bytes;
+		if (rw == DDIR_INVAL) {
 			ipo->fileno = fileno;
 			ipo->file_action = file_action;
 		}
-			
 		queue_io_piece(td, ipo);
 	}
 
@@ -358,7 +345,7 @@
 		writes = 0;
 	}
 
-	if (!reads && !writes && !waits)
+	if (!reads && !writes)
 		return 1;
 	else if (reads && !writes)
 		td->o.td_ddir = TD_DDIR_READ;
diff -urN fio-1.34.1-mike/stat.c fio-1.34.1/stat.c
--- fio-1.34.1-mike/stat.c	2009-10-30 13:38:29.000000000 +1300
+++ fio-1.34.1/stat.c	2009-10-02 06:45:31.000000000 +1300
@@ -594,7 +594,6 @@
 		ts->total_run_time += td->ts.total_run_time;
 		ts->total_submit += td->ts.total_submit;
 		ts->total_complete += td->ts.total_complete;
-
 	}
 
 	for (i = 0; i < nr_ts; i++) {

------=_Part_2214_296709324.1256869521662
Content-Type: application/x-gzip; name=sample-fio-files.tar.gz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=sample-fio-files.tar.gz

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
j8//w8//AQ/N7HYAKAUA
------=_Part_2214_296709324.1256869521662--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


