Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:13016 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0LOPKB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Dec 2010 10:10:01 -0500
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 26283E83CE
	for <fio@vger.kernel.org>; Wed, 15 Dec 2010 15:10:00 +0000 (GMT)
Received: from unknown (client-86-29-47-22.glfd.adsl.virginmedia.com [86.29.47.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id E1093E63D7
	for <fio@vger.kernel.org>; Wed, 15 Dec 2010 15:09:59 +0000 (GMT)
Date: Wed, 15 Dec 2010 15:09:24 +0000
From: Bruce Cran <bruce@cran.org.uk>
Subject: [patch] Use C99 standard integer types
Message-ID: <20101215150924.00003add@unknown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/OprSu1um69u2RtzbfbiViOI"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--MP_/OprSu1um69u2RtzbfbiViOI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Since most compilers now have a copy of the C99 inttypes.h header
available, [u]intX_t types should be preferred over compiler-specific
types such as __u32 etc. Using the standard types allows clang to build
fio.

I've attached a patch which updates blktrace_api.h, blktrace.c and
os/binject.h .

The patch also updates Makefile.FreeBSD to use the -pthread flag
since it's preferred over -lpthread .

-- 
Bruce Cran
--MP_/OprSu1um69u2RtzbfbiViOI
Content-Type: application/octet-stream; name=c99.diff
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=c99.diff

diff --git a/Makefile.FreeBSD b/Makefile.FreeBSD
index 9378b19..005458d 100644
--- a/Makefile.FreeBSD
+++ b/Makefile.FreeBSD
@@ -52,7 +52,7 @@ mandir =3D $(prefix)/man
 %.o: %.c
 	$(QUIET_CC)$(CC) -o $*.o -c $(CFLAGS) $<
 fio: $(OBJS)
-	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(EXTLIBS) -lpthread -l=
m -lrt
+	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(EXTLIBS) -pthread -lm=
 -lrt
=20
 depend:
 	$(QUIET_DEP)$(CC) -MM $(ALL_CFLAGS) $(SOURCE) 1> .depend
diff --git a/blktrace.c b/blktrace.c
index 297a8a9..822dbc7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -1,6 +1,7 @@
 /*
  * blktrace support code for fio
  */
+#include <inttypes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/stat.h>
@@ -176,7 +177,7 @@ static void trace_add_open_event(struct thread_data *td=
, int fileno)
 	flist_add_tail(&ipo->list, &td->io_log_list);
 }
=20
-static void trace_add_file(struct thread_data *td, __u32 device)
+static void trace_add_file(struct thread_data *td, uint32_t device)
 {
 	static unsigned int last_maj, last_min;
 	unsigned int maj =3D FMAJOR(device);
diff --git a/blktrace_api.h b/blktrace_api.h
index 3df3347..78498bf 100644
--- a/blktrace_api.h
+++ b/blktrace_api.h
@@ -1,7 +1,7 @@
 #ifndef BLKTRACEAPI_H
 #define BLKTRACEAPI_H
=20
-#include <asm/types.h>
+#include <inttypes.h>
=20
 /*
  * Trace categories
@@ -92,39 +92,39 @@ enum blktrace_notify {
  * The trace itself
  */
 struct blk_io_trace {
-	__u32 magic;		/* MAGIC << 8 | version */
-	__u32 sequence;		/* event number */
-	__u64 time;		/* in nanoseconds */
-	__u64 sector;		/* disk offset */
-	__u32 bytes;		/* transfer length */
-	__u32 action;		/* what happened */
-	__u32 pid;		/* who did it */
-	__u32 device;		/* device identifier (dev_t) */
-	__u32 cpu;		/* on what cpu did it happen */
-	__u16 error;		/* completion error */
-	__u16 pdu_len;		/* length of data after this trace */
+	uint32_t magic;		/* MAGIC << 8 | version */
+	uint32_t sequence;	/* event number */
+	uint64_t time;		/* in nanoseconds */
+	uint64_t sector;	/* disk offset */
+	uint32_t bytes;		/* transfer length */
+	uint32_t action;	/* what happened */
+	uint32_t pid;		/* who did it */
+	uint32_t device;	/* device identifier (dev_t) */
+	uint32_t cpu;		/* on what cpu did it happen */
+	uint16_t error;		/* completion error */
+	uint16_t pdu_len;	/* length of data after this trace */
 };
=20
 /*
  * The remap event
  */
 struct blk_io_trace_remap {
-	__u32 device;
-	__u32 device_from;
-	__u64 sector;
+	uint32_t device;
+	uint32_t device_from;
+	uint64_t sector;
 };
=20
 /*
  * User setup structure passed with BLKSTARTTRACE
  */
 struct blk_user_trace_setup {
-	char name[32];			/* output */
-	__u16 act_mask;			/* input */
-	__u32 buf_size;			/* input */
-	__u32 buf_nr;			/* input */
-	__u64 start_lba;
-	__u64 end_lba;
-	__u32 pid;
+	char     name[32];		/* output */
+	uint16_t act_mask;		/* input */
+	uint32_t buf_size;		/* input */
+	uint32_t buf_nr;		/* input */
+	uint64_t start_lba;
+	uint64_t end_lba;
+	uint32_t pid;
 };
=20
 #define BLKTRACESETUP _IOWR(0x12,115,struct blk_user_trace_setup)
diff --git a/os/binject.h b/os/binject.h
index 1d862c8..f31d910 100644
--- a/os/binject.h
+++ b/os/binject.h
@@ -9,15 +9,15 @@
 #define BINJECT_VER_MASK	((1 << BINJECT_MAGIC_SHIFT) - 1)
=20
 struct b_user_cmd {
-	__u16 magic;	/* INPUT */
-	__u16 type;	/* INPUT */
-	__u32 error;	/* OUTPUT */
-	__u32 flags;	/* INPUT */
-	__u32 len;	/* INPUT */
-	__u64 offset;	/* INPUT */
-	__u64 buf;	/* INPUT */
-	__u64 usr_ptr;	/* PASSED THROUGH */
-	__u64 nsec;	/* OUTPUT */
+	uint16_t magic;		/* INPUT */
+	uint16_t type;		/* INPUT */
+	uint32_t error;		/* OUTPUT */
+	uint32_t flags;		/* INPUT */
+	uint32_t len;		/* INPUT */
+	uint64_t offset;	/* INPUT */
+	uint64_t buf;		/* INPUT */
+	uint64_t usr_ptr;	/* PASSED THROUGH */
+	uint64_t nsec;		/* OUTPUT */
 };
=20
 struct b_ioctl_cmd {

--MP_/OprSu1um69u2RtzbfbiViOI--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


