Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D3B218596
	for <fio@vger.kernel.org>; Tue, 24 Jun 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766414; cv=none; b=Wy3z1ds/pzb5D623X3M70+OB9XKNsvR4J9q51djsKg9IN34bHOyWP/5tHd0NCNeafDi4rbRl1BejiBx+Y2GG3N1n1FVIaMqUrlO/Y5Uj80cSnpzlTqO4ziGeHC1VlfEK9Th1zNBsERIw20rWxPhKOwIWDUIPXOYV5hdsei+VevA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766414; c=relaxed/simple;
	bh=cZ05xJYPS4i1uoIIu4vODoWotm2ySJpJ5OczzrzPdVM=;
	h=Subject:From:To:Message-Id:Date; b=e0O5vJqDQ8IKxymWwEmiv6tpFLNyxZZngKTTSNT/S7EP+sNWYszfkTe8xZDo3mVD1mLmCeK6FRyhMdMm9mY4cwO9MirA0B1GilyakFQIxnlRyat40xsTVTolqPGJqz3qR7kmPh1n6oChE0pBjQES5i47UcIWPnmxJuLYx+KK3Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PXDIpm4s; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PXDIpm4s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=SoSvSiTgN/W2jhKhsbcuJGHuW/aeV21MxOmBPBX2Vbs=; b=PXDIpm4sidv88RAx2rEG5tu61I
	JTHYyzcUBFY483Z81QKoRZUaYVN+Mb6RFaKg7vIGcKN9JVSiSdq2N4EtowsvLATc9InEpSMoLrLKO
	+7Dqw/KDASLlOKO/JYYfj8qzwwiqG4O9UYZSL81L517bgGIi/PxhcjVjufAmquOvIYZqbLAMqoa98
	vWT3ZvTgm/CwCOpqUoef06Ynpnw6f2VciATKrtz+3nSCq70PNShuYzolKQM+04ueIN5TgaxDuypSV
	6obsU5q3mnu/ZJz8gcyuaLlg7OOckVv3L0oRvipW1McW19s9w7ZZybDrtr55DiYEazvjswI2Bj9cB
	82sg1mEw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uU2Jp-00000005Qei-49dK
	for fio@vger.kernel.org;
	Tue, 24 Jun 2025 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1D0E11BC017A; Tue, 24 Jun 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250624120002.1D0E11BC017A@kernel.dk>
Date: Tue, 24 Jun 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 813445e7129240d51216e396a5ba8e19296b6581:

  backend: clean up requeued io_u's (2025-06-05 01:44:43 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7037b833e175aae32900b73bf597aad08c1d8472:

  windows: drop nanosleep and clock_gettime (2025-06-23 15:04:34 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix_real_file_size_when_pi_is_enabled' of https://github.com/SuhoSon/fio

Leonid Kozlov (1):
      parse: use minimum delimiter distance

Vincent Fu (2):
      Merge branch 'fix-random-distribution-parsing-failure' of https://github.com/leonid-kozlov/fio
      windows: drop nanosleep and clock_gettime

suho.son (1):
      io_uring: ensure accurate real_file_size setup for full device access with PI enabled

 configure          |  2 --
 engines/io_uring.c |  5 +++-
 os/os-windows.h    |  1 -
 os/windows/posix.c | 72 ------------------------------------------------------
 os/windows/posix.h |  1 -
 parse.c            |  9 ++++---
 6 files changed, 10 insertions(+), 80 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 986eb0a6..9e69dc4b 100755
--- a/configure
+++ b/configure
@@ -462,8 +462,6 @@ CYGWIN*)
   build_static="yes"
   rusage_thread="yes"
   fdatasync="yes"
-  clock_gettime="yes" # clock_monotonic probe has dependency on this
-  clock_monotonic="yes"
   sched_idle="yes"
   pthread_condattr_setclock="no"
   pthread_affinity="no"
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 51228037..c87e1cd4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1610,7 +1610,10 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 			return ret;
 		}
 
-		f->real_file_size = data->lba_size * nlba;
+		if (data->lba_ext)
+			f->real_file_size = data->lba_ext * nlba;
+		else
+			f->real_file_size = data->lba_size * nlba;
 		fio_file_set_size_known(f);
 
 		FILE_SET_ENG_DATA(f, data);
diff --git a/os/os-windows.h b/os/os-windows.h
index 12f33486..909c12e3 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -106,7 +106,6 @@ int fdatasync(int fildes);
 int lstat(const char * path, struct stat * buf);
 uid_t geteuid(void);
 char* ctime_r(const time_t *t, char *buf);
-int nanosleep(const struct timespec *rqtp, struct timespec *rmtp);
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset);
 ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 		off_t offset);
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 3e48c3ff..4c692a1e 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -549,50 +549,6 @@ return 0;
 #define CLOCK_MONOTONIC_RAW 4
 #endif
 
-/*
- * Get the value of a local clock source.
- * This implementation supports 3 clocks: CLOCK_MONOTONIC/CLOCK_MONOTONIC_RAW
- * provide high-accuracy relative time, while CLOCK_REALTIME provides a
- * low-accuracy wall time.
- */
-int clock_gettime(clockid_t clock_id, struct timespec *tp)
-{
-	int rc = 0;
-
-	if (clock_id == CLOCK_MONOTONIC || clock_id == CLOCK_MONOTONIC_RAW) {
-		static LARGE_INTEGER freq = {{0,0}};
-		LARGE_INTEGER counts;
-		uint64_t t;
-
-		QueryPerformanceCounter(&counts);
-		if (freq.QuadPart == 0)
-			QueryPerformanceFrequency(&freq);
-
-		tp->tv_sec = counts.QuadPart / freq.QuadPart;
-		/* Get the difference between the number of ns stored
-		 * in 'tv_sec' and that stored in 'counts' */
-		t = tp->tv_sec * freq.QuadPart;
-		t = counts.QuadPart - t;
-		/* 't' now contains the number of cycles since the last second.
-		 * We want the number of nanoseconds, so multiply out by 1,000,000,000
-		 * and then divide by the frequency. */
-		t *= 1000000000;
-		tp->tv_nsec = t / freq.QuadPart;
-	} else if (clock_id == CLOCK_REALTIME) {
-		/* clock_gettime(CLOCK_REALTIME,...) is just an alias for gettimeofday with a
-		 * higher-precision field. */
-		struct timeval tv;
-		gettimeofday(&tv, NULL);
-		tp->tv_sec = tv.tv_sec;
-		tp->tv_nsec = tv.tv_usec * 1000;
-	} else {
-		errno = EINVAL;
-		rc = -1;
-	}
-
-	return rc;
-}
-
 int mlock(const void * addr, size_t len)
 {
 	SIZE_T min, max;
@@ -937,34 +893,6 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 	return rc;
 }
 
-int nanosleep(const struct timespec *rqtp, struct timespec *rmtp)
-{
-	struct timespec tv;
-	DWORD ms_remaining;
-	DWORD ms_total = (rqtp->tv_sec * 1000) + (rqtp->tv_nsec / 1000000.0);
-
-	if (ms_total == 0)
-		ms_total = 1;
-
-	ms_remaining = ms_total;
-
-	/* Since Sleep() can sleep for less than the requested time, add a loop to
-	   ensure we only return after the requested length of time has elapsed */
-	do {
-		fio_gettime(&tv, NULL);
-		Sleep(ms_remaining);
-		ms_remaining = ms_total - mtime_since_now(&tv);
-	} while (ms_remaining > 0 && ms_remaining < ms_total);
-
-	/* this implementation will never sleep for less than the requested time */
-	if (rmtp != NULL) {
-		rmtp->tv_sec = 0;
-		rmtp->tv_nsec = 0;
-	}
-
-	return 0;
-}
-
 DIR *opendir(const char *dirname)
 {
 	struct dirent_ctx *dc = NULL;
diff --git a/os/windows/posix.h b/os/windows/posix.h
index 02a9075b..afb00d5a 100644
--- a/os/windows/posix.h
+++ b/os/windows/posix.h
@@ -3,7 +3,6 @@
 
 typedef int clockid_t;
 
-extern int clock_gettime(clockid_t clock_id, struct timespec *tp);
 extern int inet_aton(const char *, struct in_addr *);
 extern int win_to_posix_error(DWORD winerr);
 
diff --git a/parse.c b/parse.c
index 656a5025..5bb55bff 100644
--- a/parse.c
+++ b/parse.c
@@ -480,14 +480,17 @@ static size_t opt_len(const char *str)
 	char delimiter[] = {',', ':'};
 	char *postfix;
 	unsigned int i;
+	size_t candidate_len;
 
+	size_t prefix_len = strlen(str);
 	for (i = 0; i < FIO_ARRAY_SIZE(delimiter); i++) {
 		postfix = strchr(str, delimiter[i]);
-		if (postfix)
-			return (int)(postfix - str);
+		candidate_len = (size_t)(postfix - str);
+		if (postfix && candidate_len < prefix_len)
+			prefix_len = candidate_len;
 	}
 
-	return strlen(str);
+	return prefix_len;
 }
 
 static int str_match_len(const struct value_pair *vp, const char *str)
