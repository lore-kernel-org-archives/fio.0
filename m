Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A043191A1
	for <fio@vger.kernel.org>; Fri, 31 Oct 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761912016; cv=none; b=b5CuXerW32M7OqStIe205FNcwDhtY7C9ZJT8VcDQKIwiLACqKE30j7nJtKeu1m/dyJ7OSQjQb1ixbDztNseqNAs7ndh6otFuXJCNSQoVY/wdbpFV3qULo4plDpJu/gBZou38V9hgV1h77zZQlsagUsS5diNcfzyesikGBJg+HLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761912016; c=relaxed/simple;
	bh=bWD/HG/NOFBj/G1iQ5NwNK5InXUsk6Fx8ZGXgDDFTbk=;
	h=Subject:From:To:Date:Message-Id; b=SL9eqYMUkBsKGAnxKt8D+fF+yhOumOioaljNdNkI+xnEn/C/oqJvUhmTVGcVYIr5y08++n3zqa/Zqj5UcCuduGKLcyh3qc9CVgflKLThm6gDY3mrE8zdOGCRjQsNf6RxgjHsDIYzipvW/FPOIUIb03RnrZB0wpqpVuWs/2qwZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S10jCLwM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S10jCLwM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9OZqctvrP512sdMWUA29F6ETOmhPDYldmerjmxC546A=; b=S10jCLwMwn0dDU4HKcvmXbWUbB
	yJbvkPLr/VYcMMHKH80/U7741VLaPiI98nWnCw8PXeZ1PaNJHLy7hrCIVGsaKx2sYuYuQVYD8WXUg
	5DP7CQE+0KuVjrUEHziXesKzs0NQ0tH07gA5uNzQbt0BO2dUtUILWS2CCiPTAEI//pwl35cI693/F
	k736umQjy0qMa53tEyqp6AhQJvir7euYlNormW/6tuZoacfsCSKCGm+cyllPoqRiXiQMXpLgo8/IY
	ZzIKF03c3SprZsEqjHJ/JdipK8H8ddkXj+g6ZEBl6anOBz+oIkp0FYPhLVfCYNAPvkpPgn3fljQfP
	Qbf2JtxQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEnnY-0000000EKqi-1IGF
	for fio@vger.kernel.org;
	Fri, 31 Oct 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B31E71BC0197; Fri, 31 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 31 Oct 2025 06:00:01 -0600
Message-Id: <20251031120001.B31E71BC0197@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1eb3adeed3eebab22dc5d7bed82ee23012fe360e:

  Merge branch 'master' of https://github.com/pirDOL/fio (2025-10-29 10:57:59 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 30c2e6ee56a9f0e6f0a0196ff91dbf4500318efc:

  Merge branch 'clock_gettime' of https://github.com/betonmischer86/fio (2025-10-30 14:42:29 -0400)

----------------------------------------------------------------
Sitsofe Wheeler (1):
      gettime: remove non-clock_gettime fallback code

Vincent Fu (1):
      Merge branch 'clock_gettime' of https://github.com/betonmischer86/fio

 configure   | 28 ++--------------------------
 fio.c       |  4 ----
 gettime.c   | 12 ------------
 libfio.c    |  4 ----
 options.c   |  2 --
 os/os-mac.h |  4 ----
 os/os.h     |  4 ----
 7 files changed, 2 insertions(+), 56 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index b1009f70..13450118 100755
--- a/configure
+++ b/configure
@@ -1188,6 +1188,8 @@ if compile_prog "" "" "clock_gettime"; then
 elif compile_prog "" "-lrt" "clock_gettime"; then
     clock_gettime="yes"
     LIBS="-lrt $LIBS"
+else
+  fatal "clock_gettime is not supported"
 fi
 print_config "clock_gettime" "$clock_gettime"
 
@@ -1213,26 +1215,6 @@ EOF
 fi
 print_config "CLOCK_MONOTONIC" "$clock_monotonic"
 
-##########################################
-# clockid_t probe
-if test "$clockid_t" != "yes" ; then
-  clockid_t="no"
-fi
-cat > $TMPC << EOF
-#include <time.h>
-#include <string.h>
-int main(int argc, char **argv)
-{
-  volatile clockid_t cid;
-  memset((void*)&cid, 0, sizeof(cid));
-  return 0;
-}
-EOF
-if compile_prog "" "$LIBS" "clockid_t"; then
-  clockid_t="yes"
-fi
-print_config "clockid_t" "$clockid_t"
-
 ##########################################
 # gettimeofday() probe
 if test "$gettimeofday" != "yes" ; then
@@ -3125,15 +3107,9 @@ fi
 if test "$libverbs" = "yes" -a "$rdmacm" = "yes" ; then
   output_sym "CONFIG_RDMA"
 fi
-if test "$clock_gettime" = "yes" ; then
-  output_sym "CONFIG_CLOCK_GETTIME"
-fi
 if test "$clock_monotonic" = "yes" ; then
   output_sym "CONFIG_CLOCK_MONOTONIC"
 fi
-if test "$clockid_t" = "yes"; then
-  output_sym "CONFIG_CLOCKID_T"
-fi
 if test "$gettimeofday" = "yes" ; then
   output_sym "CONFIG_GETTIMEOFDAY"
 fi
diff --git a/fio.c b/fio.c
index 3d6ce597..1394a51d 100644
--- a/fio.c
+++ b/fio.c
@@ -30,10 +30,6 @@ int main(int argc, char *argv[], char *envp[])
 	if (initialize_fio(envp))
 		return 1;
 
-#if !defined(CONFIG_GETTIMEOFDAY) && !defined(CONFIG_CLOCK_GETTIME)
-#error "No available clock source!"
-#endif
-
 	if (fio_server_create_sk_key())
 		goto done;
 
diff --git a/gettime.c b/gettime.c
index 5ca31206..b19d3920 100644
--- a/gettime.c
+++ b/gettime.c
@@ -136,20 +136,10 @@ int fio_get_mono_time(struct timespec *ts)
 {
 	int ret;
 
-#ifdef CONFIG_CLOCK_GETTIME
 #if defined(CONFIG_CLOCK_MONOTONIC)
 	ret = clock_gettime(CLOCK_MONOTONIC, ts);
 #else
 	ret = clock_gettime(CLOCK_REALTIME, ts);
-#endif
-#else
-	struct timeval tv;
-
-	ret = gettimeofday(&tv, NULL);
-	if (ret == 0) {
-		ts->tv_sec = tv.tv_sec;
-		ts->tv_nsec = tv.tv_usec * 1000;
-	}
 #endif
 	assert(ret <= 0);
 	return ret;
@@ -168,7 +158,6 @@ static void __fio_gettime(struct timespec *tp)
 		break;
 		}
 #endif
-#ifdef CONFIG_CLOCK_GETTIME
 	case CS_CGETTIME: {
 		if (fio_get_mono_time(tp) < 0) {
 			log_err("fio: fio_get_mono_time() fails\n");
@@ -176,7 +165,6 @@ static void __fio_gettime(struct timespec *tp)
 		}
 		break;
 		}
-#endif
 #ifdef ARCH_HAVE_CPU_CLOCK
 	case CS_CPUCLOCK: {
 		uint64_t nsecs, t, multiples;
diff --git a/libfio.c b/libfio.c
index 3503c65e..57f3f858 100644
--- a/libfio.c
+++ b/libfio.c
@@ -406,10 +406,6 @@ int initialize_fio(char *envp[])
 		return 1;
 	}
 
-#if !defined(CONFIG_GETTIMEOFDAY) && !defined(CONFIG_CLOCK_GETTIME)
-#error "No available clock source!"
-#endif
-
 	arch_init(envp);
 
 	sinit();
diff --git a/options.c b/options.c
index e1a87430..8e3de528 100644
--- a/options.c
+++ b/options.c
@@ -3109,12 +3109,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Use gettimeofday(2) for timing",
 			  },
 #endif
-#ifdef CONFIG_CLOCK_GETTIME
 			  { .ival = "clock_gettime",
 			    .oval = CS_CGETTIME,
 			    .help = "Use clock_gettime(2) for timing",
 			  },
-#endif
 #ifdef ARCH_HAVE_CPU_CLOCK
 			  { .ival = "cpu",
 			    .oval = CS_CPUCLOCK,
diff --git a/os/os-mac.h b/os/os-mac.h
index 3ade499f..4e96228a 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -37,10 +37,6 @@
 	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
 #endif
 
-#ifndef CONFIG_CLOCKID_T
-typedef unsigned int clockid_t;
-#endif
-
 #define FIO_OS_DIRECTIO
 static inline int fio_set_odirect(struct fio_file *f)
 {
diff --git a/os/os.h b/os/os.h
index d54e7c0d..0736f8a1 100644
--- a/os/os.h
+++ b/os/os.h
@@ -174,11 +174,7 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 
 #ifndef FIO_PREFERRED_CLOCK_SOURCE
-#ifdef CONFIG_CLOCK_GETTIME
 #define FIO_PREFERRED_CLOCK_SOURCE	CS_CGETTIME
-#else
-#define FIO_PREFERRED_CLOCK_SOURCE	CS_GTOD
-#endif
 #endif
 
 #ifndef CONFIG_SOCKLEN_T
