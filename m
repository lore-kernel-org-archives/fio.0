Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE2622064
	for <fio@vger.kernel.org>; Fri, 19 Apr 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713528015; cv=none; b=ld8KHxEZRBcSW3HwqEI/O90MiaxJQOIWiPR7pmuFpeyWKvXS4zjC2NyuoPH4qRah6fGdxWqCh3rzvBalkVLq+C8zb7zguMXsQVIJVQaQD0jZ9TBcwQXMTr41/RTsJAFeTg6OD69kdKpFe1XVpwCObYjkONPojXIi4GjNxNZu4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713528015; c=relaxed/simple;
	bh=PYOla+4qucPjTMF5E5wF0ZXMPrN174zlEx1n/kAeThc=;
	h=Subject:From:To:Message-Id:Date; b=bBiWThKplUAy4gbkv8LI4R2fneDbB5QuZUUXFTju30gzqGQdmq64n87dlgwKdbap0wXFC6IFpLYF9PstSMCiofAhQnpmPHMrUOx0QGFkKG/WV1QObAFsfO2U3MXUHmSeluUviu9Np305N8mEwsWtA1aiRl8UZM4YDfNg1Jje8Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pR9jwjJn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pR9jwjJn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=uNRuRjf4jz0zLNXwOHDvmpIi6NCngDbTbpw60ih7OII=; b=pR9jwjJn8xjaX0YewaTpAvIcvU
	YtZpTVCy/ZiW/1HgpXH3Jv8bytyjPD/mfEMKfuRzGg2Q0v58U2BoSD6KHvdpXuiRDMfA2HS0nh9sG
	JOLOWVAJxBUKW/iWhEoNHL6twLb+wn82Alf79e0ppbM5lNwZytBlhvGY+Ge3H0dYy4Nnl4w8agaMh
	vkjw7fl1kJL38QXuzBxhAxujH8j/7++wD0pcBCtvhNeLNFThhSEnifDtEtbS+QeL5XwjGfEimxJe+
	N31nwCdRhoTWme4suII8edarxE2fvK1oWSw4Jtun4Kc0ObWSPXWBmNZr4Tj8iiZleOAfz9W/ZgD1H
	BgPSVufg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxmuU-0000000CQh3-0JDC
	for fio@vger.kernel.org;
	Fri, 19 Apr 2024 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E293B1BC012F; Fri, 19 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240419120001.E293B1BC012F@kernel.dk>
Date: Fri, 19 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e0bb44a5b2a67695f0b940772c70f678b323ec54:

  t/io_uring: only calculate per-file depth if we have files (2024-04-17 16:34:47 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 420415dd1180c14ec0f55f65a05e57ea1fd85f9f:

  fio: ioengine flag cleanup (2024-04-18 12:36:01 -0400)

----------------------------------------------------------------
Chana-Zaks-wdc (2):
      Don break too early in readwrite mode
      test: add test for readwrite issue

Vincent Fu (3):
      fio: use thread flag count for ioengine flag shift
      fio: remove compile time assertion
      fio: ioengine flag cleanup

 backend.c                 |  5 ++++
 fio.c                     |  2 --
 fio.h                     |  4 +--
 io_u.c                    | 11 +++++++
 ioengines.h               | 73 ++++++++++++++++++++++++++++++-----------------
 libfio.c                  |  1 +
 t/jobs/t0032-43063a1c.fio | 12 ++++++++
 7 files changed, 78 insertions(+), 30 deletions(-)
 create mode 100644 t/jobs/t0032-43063a1c.fio

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index fb7dc68a..fe03eab3 100644
--- a/backend.c
+++ b/backend.c
@@ -977,6 +977,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	*/
 	if (td_write(td) && td_random(td) && td->o.norandommap)
 		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
+
+	/* Don't break too early if io_size > size */
+	if (td_rw(td) && !td_random(td))
+		total_bytes = max(total_bytes, (uint64_t)td->o.io_size);
+
 	/*
 	 * If verify_backlog is enabled, we'll run the verify in this
 	 * handler as well. For that case, we may need up to twice the
diff --git a/fio.c b/fio.c
index f19db1be..3d6ce597 100644
--- a/fio.c
+++ b/fio.c
@@ -27,8 +27,6 @@ int main(int argc, char *argv[], char *envp[])
 {
 	int ret = 1;
 
-	compiletime_assert(TD_NR <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
-
 	if (initialize_fio(envp))
 		return 1;
 
diff --git a/fio.h b/fio.h
index fc3e3ece..7d9927a0 100644
--- a/fio.h
+++ b/fio.h
@@ -706,8 +706,8 @@ enum {
 	TD_NR,
 };
 
-#define TD_ENG_FLAG_SHIFT	18
-#define TD_ENG_FLAG_MASK	((1ULL << 18) - 1)
+#define TD_ENG_FLAG_SHIFT	(__TD_F_LAST)
+#define TD_ENG_FLAG_MASK	((1ULL << (__TD_F_LAST)) - 1)
 
 static inline void td_set_ioengine_flags(struct thread_data *td)
 {
diff --git a/io_u.c b/io_u.c
index 09e5f15a..83895893 100644
--- a/io_u.c
+++ b/io_u.c
@@ -360,6 +360,17 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 		loop_cache_invalidate(td, f);
 	}
 
+	/*
+	 * If we reach the end for a rw-io-size based run, reset us back to 0
+	 * and invalidate the cache, if we need to.
+	 */
+	if (td_rw(td) && o->io_size > o->size) {
+		if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f)) {
+			f->last_pos[ddir] = f->file_offset;
+			loop_cache_invalidate(td, f);
+		}
+        }
+
 	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
 
diff --git a/ioengines.h b/ioengines.h
index e43650f7..4fe9bb98 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -72,33 +72,54 @@ struct ioengine_ops {
 	struct fio_option *options;
 };
 
-enum fio_ioengine_flags {
-	FIO_SYNCIO	= 1 << 0,	/* io engine has synchronous ->queue */
-	FIO_RAWIO	= 1 << 1,	/* some sort of direct/raw io */
-	FIO_DISKLESSIO	= 1 << 2,	/* no disk involved */
-	FIO_NOEXTEND	= 1 << 3,	/* engine can't extend file */
-	FIO_NODISKUTIL  = 1 << 4,	/* diskutil can't handle filename */
-	FIO_UNIDIR	= 1 << 5,	/* engine is uni-directional */
-	FIO_NOIO	= 1 << 6,	/* thread does only pseudo IO */
-	FIO_PIPEIO	= 1 << 7,	/* input/output no seekable */
-	FIO_BARRIER	= 1 << 8,	/* engine supports barriers */
-	FIO_MEMALIGN	= 1 << 9,	/* engine wants aligned memory */
-	FIO_BIT_BASED	= 1 << 10,	/* engine uses a bit base (e.g. uses Kbit as opposed to KB) */
-	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
-	FIO_NOSTATS	= 1 << 12,	/* don't do IO stats */
-	FIO_NOFILEHASH	= 1 << 13,	/* doesn't hash the files for lookup later. */
-	FIO_ASYNCIO_SYNC_TRIM
-			= 1 << 14,	/* io engine has async ->queue except for trim */
-	FIO_NO_OFFLOAD	= 1 << 15,	/* no async offload */
-	FIO_ASYNCIO_SETS_ISSUE_TIME
-			= 1 << 16,	/* async ioengine with commit function that sets issue_time */
-	FIO_SKIPPABLE_IOMEM_ALLOC
-			= 1 << 17,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
-	FIO_RO_NEEDS_RW_OPEN
-			= 1 << 18,	/* open files in rw mode even if we have a read job; only
+enum {
+	__FIO_SYNCIO = 0,		/* io engine has synchronous ->queue */
+	__FIO_RAWIO,			/* some sort of direct/raw io */
+	__FIO_DISKLESSIO,		/* no disk involved */
+	__FIO_NOEXTEND,			/* engine can't extend file */
+	__FIO_NODISKUTIL,		/* diskutil can't handle filename */
+	__FIO_UNIDIR,			/* engine is uni-directional */
+	__FIO_NOIO,			/* thread does only pseudo IO */
+	__FIO_PIPEIO,			/* input/output no seekable */
+	__FIO_BARRIER,			/* engine supports barriers */
+	__FIO_MEMALIGN,			/* engine wants aligned memory */
+	__FIO_BIT_BASED,		/* engine uses a bit base (e.g. uses Kbit as opposed to
+					   KB) */
+	__FIO_FAKEIO,			/* engine pretends to do IO */
+	__FIO_NOSTATS,			/* don't do IO stats */
+	__FIO_NOFILEHASH,		/* doesn't hash the files for lookup later. */
+	__FIO_ASYNCIO_SYNC_TRIM,	/* io engine has async ->queue except for trim */
+	__FIO_NO_OFFLOAD,		/* no async offload */
+	__FIO_ASYNCIO_SETS_ISSUE_TIME,	/* async ioengine with commit function that sets
+					   issue_time */
+	__FIO_SKIPPABLE_IOMEM_ALLOC,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
+	__FIO_RO_NEEDS_RW_OPEN,		/* open files in rw mode even if we have a read job; only
 					   affects ioengines using generic_open_file */
-	FIO_MULTI_RANGE_TRIM
-			= 1 << 19,	/* ioengine supports trim with more than one range */
+	__FIO_MULTI_RANGE_TRIM,		/* ioengine supports trim with more than one range */
+	__FIO_IOENGINE_F_LAST,		/* not a real bit; used to count number of bits */
+};
+
+enum fio_ioengine_flags {
+	FIO_SYNCIO			= 1 << __FIO_SYNCIO,
+	FIO_RAWIO			= 1 << __FIO_RAWIO,
+	FIO_DISKLESSIO			= 1 << __FIO_DISKLESSIO,
+	FIO_NOEXTEND			= 1 << __FIO_NOEXTEND,
+	FIO_NODISKUTIL  		= 1 << __FIO_NODISKUTIL,
+	FIO_UNIDIR			= 1 << __FIO_UNIDIR,
+	FIO_NOIO			= 1 << __FIO_NOIO,
+	FIO_PIPEIO			= 1 << __FIO_PIPEIO,
+	FIO_BARRIER			= 1 << __FIO_BARRIER,
+	FIO_MEMALIGN			= 1 << __FIO_MEMALIGN,
+	FIO_BIT_BASED			= 1 << __FIO_BIT_BASED,
+	FIO_FAKEIO			= 1 << __FIO_FAKEIO,
+	FIO_NOSTATS			= 1 << __FIO_NOSTATS,
+	FIO_NOFILEHASH			= 1 << __FIO_NOFILEHASH,
+	FIO_ASYNCIO_SYNC_TRIM		= 1 << __FIO_ASYNCIO_SYNC_TRIM,
+	FIO_NO_OFFLOAD			= 1 << __FIO_NO_OFFLOAD,
+	FIO_ASYNCIO_SETS_ISSUE_TIME	= 1 << __FIO_ASYNCIO_SETS_ISSUE_TIME,
+	FIO_SKIPPABLE_IOMEM_ALLOC	= 1 << __FIO_SKIPPABLE_IOMEM_ALLOC,
+	FIO_RO_NEEDS_RW_OPEN		= 1 << __FIO_RO_NEEDS_RW_OPEN,
+	FIO_MULTI_RANGE_TRIM		= 1 << __FIO_MULTI_RANGE_TRIM,
 };
 
 /*
diff --git a/libfio.c b/libfio.c
index 5c433277..d0c6bf8f 100644
--- a/libfio.c
+++ b/libfio.c
@@ -378,6 +378,7 @@ int initialize_fio(char *envp[])
 	compiletime_assert((offsetof(struct jobs_eta, m_rate) % 8) == 0, "m_rate");
 
 	compiletime_assert(__TD_F_LAST <= TD_ENG_FLAG_SHIFT, "TD_ENG_FLAG_SHIFT");
+	compiletime_assert((__TD_F_LAST + __FIO_IOENGINE_F_LAST) <= 8*sizeof(((struct thread_data *)0)->flags), "td->flags");
 	compiletime_assert(BSSPLIT_MAX <= ZONESPLIT_MAX, "bsssplit/zone max");
 
 	err = endian_check();
diff --git a/t/jobs/t0032-43063a1c.fio b/t/jobs/t0032-43063a1c.fio
new file mode 100644
index 00000000..db998e5b
--- /dev/null
+++ b/t/jobs/t0032-43063a1c.fio
@@ -0,0 +1,12 @@
+# Expected results: max offset is ~1280K
+# Buggy result: max offset is ~640K
+#
+
+[global]
+ioengine=null
+size=1280K
+io_size=2560k
+bs=128K
+
+[test1]
+rw=rw
