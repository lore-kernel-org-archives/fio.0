Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525209;
	b=ti9BsvXsvtQCgeZqzarXqIfOyq0Oh9qa5190N0ur8w4707sJIfpMjp9UZgWiapX0iwFg
	 dL+ELGSs5sdrZyDd8hXRkVyGufe1zLI57xKwYgVmU9XKDRIpFq+izxKLuAlTdf59EB6u9
	 uOwsCAmkRbhxSzUbS2Imj2gtcxwNnSpN9sw+EhCvTPiDpZa2lDQYsfjOGIL3jL7iytAAi
	 5RVsTz0IyhTqCUHRSdqjLvrFUtqkFNgyoU0I0AWNuJZFq+iwaF8G+b09mvU0R/jK3UFS/
	 jYVYSQyJDGN8dUtFeyMFoX1En13QbOY/Fg76n/nCw9df1WwJl6m6lbv8mSEtkTa+yvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525209;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=8PACwrvgeJB4wl2+kvr8AhGyYWNxG/j9s9iczNOh52g=;
	b=TXl7dWZDhf6wusSBlIy1eW0+P1zbpO8viVdnj0MMOMJnjPPrtKj0VkpZkOwF7elRtYDR
	 ujQBp0NKFSHUXR7wNtohU70Co0Xz/CS5z06NVlRolNqaYaLhuyWnKSWCNAOAGQkjxJyi8
	 qGtzN3FjFCzFWXs746C9w0ZEhmrAKbySMNpJXuRFH/c2fqvR8heJetVHQf9BrQl/Vl19X
	 SkieA+9gq8AxxG1q+pRntZb3O2ZtH1BNTaMdrFgF90KsELy9FJGC9pt4sDpJEM+uTvSJ/
	 oqj8qBisgXezSAbDjQrgZVdo1tnTXB1ON74hGzaSpM2rCRsGev7TQRPnlhHrmKN5SAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=hmwdlq8m;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC01C606A335
	for <fio@vger.kernel.org>; Tue, 24 Nov 2026 13:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC01C606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=hmwdlq8m
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=8PACwrvgeJB4wl2+kvr8AhGyYWNxG/j9s9iczNOh52g=; b=hmwdlq8mT57TzVznCEXgAqXrHA
	KCJiorCkgR0Oto8UNkF/0kBg3z8kHf8TR3FE85+WkJcQphN+kESlFCzRMnd31opg4yrdc9rPSamv7
	rZJveVP/EjoBiGQT+xqhTxcgKc9Ss47aUzsLIzUn9zO+YSM03TIckcBRwoj9V2cjz9JT14BGYJzyb
	tmk1C2XmrVpcxHokThCFnbxh70dknYMUIDpFyBMXdi0ML22AyhpJ/bdXvM6FtBVwA5h2/E2jv+4PI
	bD54FOSNgZVxnqJdOMdsXotP8BlnWM6EvVOVbjJVTLHcFTP9iXaid36BDCgHJ/k1ujpsttdfT5I1b
	bNerYU9g==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVq7w-00000005MDs-44OY
	for fio@vger.kernel.org;
	Tue, 24 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 19CBE1BC0161; Tue, 24 Nov 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 24 Nov 2026 06:00:02 -0700
Message-Id: <20261124130002.19CBE1BC0161@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit b6d1c31bba8a17cb0f0fa3f1b8f5fa5bd20cb57c:

  engines/libcufile: fix clang -Wabsolute-value error (2026-11-20 13:58:44 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1fe61cc8e693496b2ca69b69cb41183e14eaa461:

  configure: add clock_gettime probe with -lpthread (2026-11-23 18:16:58 -0500)

----------------------------------------------------------------
Vincent Fu (3):
      libfio: don't reset io_issues when the ramp period ends
      ci: switch msys2 build from deprecated MINGW64 to CLANG64
      configure: add clock_gettime probe with -lpthread

 .github/workflows/ci.yml | 18 ++++++++++--------
 configure                |  5 +++++
 libfio.c                 | 18 +++++++++++++++---
 3 files changed, 30 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 314a00a9..ff024d6a 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -121,17 +121,19 @@ jobs:
       if: ${{ startsWith(matrix.build, 'windows-msys2') }}
       uses: msys2/setup-msys2@v2
       with:
+        msystem: CLANG64
+        update: true
         install: >
           git
           base-devel
-          mingw-w64-${{matrix.arch}}-clang
-          mingw-w64-${{matrix.arch}}-cunit
-          mingw-w64-${{matrix.arch}}-toolchain
-          mingw-w64-${{matrix.arch}}-lld
-          mingw-w64-${{matrix.arch}}-python-scipy
-          mingw-w64-${{matrix.arch}}-python-six
-          mingw-w64-${{matrix.arch}}-python-statsmodels
-          mingw-w64-${{matrix.arch}}-python-sphinx
+          mingw-w64-clang-${{matrix.arch}}-clang
+          mingw-w64-clang-${{matrix.arch}}-cunit
+          mingw-w64-clang-${{matrix.arch}}-toolchain
+          mingw-w64-clang-${{matrix.arch}}-lld
+          mingw-w64-clang-${{matrix.arch}}-python-scipy
+          mingw-w64-clang-${{matrix.arch}}-python-six
+          mingw-w64-clang-${{matrix.arch}}-python-statsmodels
+          mingw-w64-clang-${{matrix.arch}}-python-sphinx
 
     - name: install bash 4 (macOS)
       if: ${{ contains( matrix.build, 'macOS' ) }}
diff --git a/configure b/configure
index 2a2dcd6b..fe3d8784 100755
--- a/configure
+++ b/configure
@@ -1235,6 +1235,11 @@ if compile_prog "" "" "clock_gettime"; then
 elif compile_prog "" "-lrt" "clock_gettime"; then
     clock_gettime="yes"
     LIBS="-lrt $LIBS"
+elif compile_prog "" "-lpthread" "clock_gettime"; then
+    # MinGW provides clock_gettime() in libwinpthread. GCC links it
+    # implicitly but clang (e.g. MSYS2 CLANG64) does not.
+    clock_gettime="yes"
+    LIBS="-lpthread $LIBS"
 else
   fatal "clock_gettime is not supported"
 fi
diff --git a/libfio.c b/libfio.c
index aff131ff..1a4a78fe 100644
--- a/libfio.c
+++ b/libfio.c
@@ -141,8 +141,11 @@ static void update_thinktime_blocks_counter(struct thread_data *td)
 {
 	unsigned long long b;
 
-	/* an offload worker has no thinktime blocks counters initialized */
-	if (!td->thinktime_blocks_counter)
+	/*
+	 * An offload worker has no thinktime blocks counters initialized.
+	 * io_issues is not reset below, so only rebase for io_blocks.
+	 */
+	if (td->thinktime_blocks_counter != td->io_blocks)
 		return;
 
 	b = ddir_rw_sum(td->thinktime_blocks_counter);
@@ -157,10 +160,19 @@ void reset_all_stats(struct thread_data *td)
 
 	update_thinktime_blocks_counter(td);
 
+	/*
+	 * io_issues[] is deliberately not reset. It supplies the numberio
+	 * sequence used by verify (verify headers, the inflight log, failed
+	 * write tracking and the verify state file), which must increase
+	 * monotonically for the life of the job. It also sets the cadence
+	 * of fsync/fdatasync/sync_file_range/write_barrier, and resetting
+	 * it mid-interval would stretch the interval spanning the ramp
+	 * boundary. Finally, an in-flight io_u that is requeued decrements
+	 * it. It is not used for reported stats.
+	 */
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->io_bytes[i] = 0;
 		td->io_blocks[i] = 0;
-		td->io_issues[i] = 0;
 		td->ts.total_io_u[i] = 0;
 		td->ts.runtime[i] = 0;
 	}
