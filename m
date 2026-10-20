Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497609;
	b=aIJo5tGdKjQCFz/Hpq9dk4/oUdCRRkJ+hMFDlsIBSVcSiSjxCiMx1K6TefdaM0jAiH48
	 o8JdC/tu0m+PftUeuwl04Fln+W0uVFAWUzlfAbo21ZMhCx4ImDZihaeTBsTBij15pJkUQ
	 A2usKt500nXNt60fllsTyPT+QpOeZy0mjh1VW1Jg9vEmAyvhxk7BBTzAnnjk5hBy2tlNZ
	 ab1Qe9CKpKVKWqIjSpwn8okm8dvsnA80fTJ05HjVf8pOiO6ltHMREYm/pECrV7xg7RTlt
	 5sOrrSw4Wk1MqQhmDVf2ptrb6JhLSPkhCCHZW0HoAFsIogiIfYZFkBk8XOJKIdYUiIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497609;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=08tfQlxiWHkv7TTvMhMMC9cD4KlVnfJjeYZ0ItuW2DY=;
	b=0aSul2EVr2yglMH4v6iohlp6TLhjt6NURi6togtgoBkbv/RAFb+lQOhjmIIHZtjeE5n6
	 O5tk3GXKgbBBKdEwv6Qhs51hcBkL00WD5HdRhnxqwd9kDqhC/nENb5Hx2AScvUY9DIT8J
	 3HFGIc6OCvhGn4D0oQ5tLSRwKYvReMs7gVhGhg1WC4BPltaH/F2H3MHd9ac0+axlUmM7J
	 fyWuZLeIsXjGz2mzEZd6CMSUaoxvmtQXM6fIU3/Cx+CGXLplbU58Yg7RGGt+rZ97/F9BE
	 OMjM+8LaYK0cPKIiZrpOgMKvQjjhs5Gaexzr1KBKG9BnpmK1PjyLHh0Reswu09E9X6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=GTFU8z+M;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AA7606A33C
	for <fio@vger.kernel.org>; Tue, 20 Oct 2026 12:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10AA7606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=GTFU8z+M
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=08tfQlxiWHkv7TTvMhMMC9cD4KlVnfJjeYZ0ItuW2DY=; b=GTFU8z+MlPp5ZC929bHqiq95V5
	mG+6eyVhgbU3o3adY3n3Yps1M4+iu7waoj3uMjDseMJxUoLxr5SVlq1USdz/Z69Zz1Ucfa0NmaCDp
	2bEt0HEY5fBX0iRv28WvlRZaLxKbAO5MQsGxdBasIdIQ5TATXSxxRY63DLlda/4sC0awgGrI7OjJp
	DyxlCnsOGoG2EBZlS0vMB2jx4QE0p08mN4KosS4KoUb94sY/n3XQr4FKtK98KGeIwWcR7dpfN1hj1
	FN+bGu2Ap7bKd4ZVwc+CMKbBbnnJZuVNh43MRCaYZyhzhDOePfr6wlKzzocVV+LeXHkGd33kGtURS
	23EZlxpw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xJ8Vg-00000004gw0-3JXA
	for fio@vger.kernel.org;
	Tue, 20 Oct 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 54DEB1BC012E; Tue, 20 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 20 Oct 2026 06:00:01 -0600
Message-Id: <20261020120001.54DEB1BC012E@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit acb7a302059b0cc397c95a232a44cb14c524bbde:

  Merge branch 'dmabuf-io_uringv1' of https://github.com/swarnagh6/fio (2026-10-12 19:21:58 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4767beef328a257c4300358ffa2901f3e0f1dc68:

  Merge branch 'write_zeries' of https://github.com/panky-codes/fio (2026-10-19 11:57:14 -0400)

----------------------------------------------------------------
Pankaj Raghav (1):
      fio: add FALLOC_FL_WRITE_ZEROES support to falloc

Vincent Fu (1):
      Merge branch 'write_zeries' of https://github.com/panky-codes/fio

 HOWTO.rst   |  8 ++++++--
 configure   | 23 +++++++++++++++++++++++
 file.h      |  3 ++-
 filesetup.c | 15 +++++++++++++++
 fio.1       |  8 ++++++--
 options.c   |  6 ++++++
 6 files changed, 58 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 0b39b01a..6adea4d7 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1357,6 +1357,10 @@ I/O type
 			Pre-allocate via :manpage:`fallocate(2)` with
 			FALLOC_FL_KEEP_SIZE set.
 
+		**write_zeroes**
+			Pre-allocate via :manpage:`fallocate(2)` with
+			FALLOC_FL_WRITE_ZEROES set.
+
 		**truncate**
 			Extend file to final size via :manpage:`ftruncate(2)`
 			instead of allocating.
@@ -1367,8 +1371,8 @@ I/O type
 		**1**
 			Backward-compatible alias for **posix**.
 
-	May not be available on all supported platforms. **keep** is only available
-	on Linux. If using ZFS on Solaris this cannot be set to **posix**
+	May not be available on all supported platforms. **keep** and
+	**write_zeroes** are only available on Linux. If using ZFS on Solaris this cannot be set to **posix**
 	because ZFS doesn't support pre-allocation. Default: **native** if any
 	pre-allocation methods except **truncate** are available, **none** if not.
 
diff --git a/configure b/configure
index 60d0ef98..9dfc9b6d 100755
--- a/configure
+++ b/configure
@@ -1098,6 +1098,26 @@ if compile_prog "" "" "linux_fallocate"; then
 fi
 print_config "Linux fallocate" "$linux_fallocate"
 
+##########################################
+# Linux fallocate FALLOC_FL_WRITE_ZEROES probe
+if test "$linux_fallocate_write_zeroes" != "yes" ; then
+  linux_fallocate_write_zeroes="no"
+fi
+cat > $TMPC << EOF
+#include <stdio.h>
+#include <fcntl.h>
+#include <linux/falloc.h>
+int main(int argc, char **argv)
+{
+  int r = fallocate(0, FALLOC_FL_WRITE_ZEROES, 0, 1024);
+  return r;
+}
+EOF
+if compile_prog "" "" "linux_fallocate_write_zeroes"; then
+    linux_fallocate_write_zeroes="yes"
+fi
+print_config "Linux fallocate write zeroes" "$linux_fallocate_write_zeroes"
+
 ##########################################
 # POSIX fadvise probe
 if test "$posix_fadvise" != "yes" ; then
@@ -3221,6 +3241,9 @@ fi
 if test "$linux_fallocate" = "yes" ; then
   output_sym "CONFIG_LINUX_FALLOCATE"
 fi
+if test "$linux_fallocate_write_zeroes" = "yes" ; then
+  output_sym "CONFIG_LINUX_FALLOCATE_WRITE_ZEROES"
+fi
 if test "$posix_fallocate" = "yes" ; then
   output_sym "CONFIG_POSIX_FALLOCATE"
 fi
diff --git a/file.h b/file.h
index 6fcf409b..d3375d7c 100644
--- a/file.h
+++ b/file.h
@@ -63,7 +63,7 @@ enum {
 
 /*
  * No pre-allocation when laying down files, or call posix_fallocate(), or
- * call fallocate() with FALLOC_FL_KEEP_SIZE set.
+ * call fallocate() with FALLOC_FL_KEEP_SIZE or FALLOC_FL_WRITE_ZEROES set.
  */
 enum fio_fallocate_mode {
 	FIO_FALLOCATE_NONE	= 1,
@@ -71,6 +71,7 @@ enum fio_fallocate_mode {
 	FIO_FALLOCATE_KEEP_SIZE	= 3,
 	FIO_FALLOCATE_NATIVE	= 4,
 	FIO_FALLOCATE_TRUNCATE	= 5,
+	FIO_FALLOCATE_WRITE_ZEROES = 6,
 };
 
 /*
diff --git a/filesetup.c b/filesetup.c
index 72be2591..0f8c4d74 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -95,6 +95,21 @@ static void fallocate_file(struct thread_data *td, struct fio_file *f)
 
 		break;
 		}
+#ifdef CONFIG_LINUX_FALLOCATE_WRITE_ZEROES
+	case FIO_FALLOCATE_WRITE_ZEROES: {
+		int r;
+
+		dprint(FD_FILE, "fallocate(FALLOC_FL_WRITE_ZEROES) "
+				"file %s size %llu\n", f->file_name,
+				(unsigned long long) f->real_file_size);
+
+		r = fallocate(f->fd, FALLOC_FL_WRITE_ZEROES, 0, f->real_file_size);
+		if (r != 0)
+			td_verror(td, errno, "fallocate");
+
+		break;
+		}
+#endif /* CONFIG_LINUX_FALLOCATE_WRITE_ZEROES */
 #endif /* CONFIG_LINUX_FALLOCATE */
 	case FIO_FALLOCATE_TRUNCATE: {
 		int r;
diff --git a/fio.1 b/fio.1
index 08153d30..6123b8d3 100644
--- a/fio.1
+++ b/fio.1
@@ -1139,6 +1139,10 @@ Pre-allocate via \fBposix_fallocate\fR\|(3).
 Pre-allocate via \fBfallocate\fR\|(2) with
 FALLOC_FL_KEEP_SIZE set.
 .TP
+.B write_zeroes
+Pre-allocate via \fBfallocate\fR\|(2) with
+FALLOC_FL_WRITE_ZEROES set.
+.TP
 .B truncate
 Extend file to final size using \fBftruncate\fR|(2)
 instead of allocating.
@@ -1150,8 +1154,8 @@ Backward-compatible alias for \fBnone\fR.
 Backward-compatible alias for \fBposix\fR.
 .RE
 .P
-May not be available on all supported platforms. \fBkeep\fR is only available
-on Linux. If using ZFS on Solaris this cannot be set to \fBposix\fR
+May not be available on all supported platforms. \fBkeep\fR and
+\fBwrite_zeroes\fR are only available on Linux. If using ZFS on Solaris this cannot be set to \fBposix\fR
 because ZFS doesn't support pre-allocation. Default: \fBnative\fR if any
 pre-allocation methods except \fBtruncate\fR are available, \fBnone\fR if not.
 .P
diff --git a/options.c b/options.c
index bb7296ed..e707203d 100644
--- a/options.c
+++ b/options.c
@@ -3011,6 +3011,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_FALLOCATE_KEEP_SIZE,
 			    .help = "Use fallocate(..., FALLOC_FL_KEEP_SIZE, ...)",
 			  },
+#ifdef CONFIG_LINUX_FALLOCATE_WRITE_ZEROES
+			  { .ival = "write_zeroes",
+			    .oval = FIO_FALLOCATE_WRITE_ZEROES,
+			    .help = "Use fallocate(..., FALLOC_FL_WRITE_ZEROES, ...)",
+			  },
+#endif
 #endif
 			  { .ival = "truncate",
 			    .oval = FIO_FALLOCATE_TRUNCATE,
