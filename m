Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4669925543
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WW50A+lG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+A7HhnACPV0Cwisd4DMC5jsgkmTLblqRtSyIMfQ+g6o=; b=WW50A+lGXjSj6wMxslK58WTQYE
	DKltm0pM3ztxZ5Yj146mSWHmirZqesPJ05w92T8ANgI6eriM3NQm8GxnTH6EbdGl2hpEimISbmPtJ
	2aYqCSdgIT5Jo4M4iraFa0zgwReLtYpkttW1gnslM5+CtvhfPU8v9UOtwHGa9RB4HrXixgi3xAtV5
	ZzCJkEzJKVt8qhh0Ad08IoBxi/AC7MDbClUbRN2p//i+oH6HSZ/2dJAUpkyIFkC+dlQoWVFqTWVEt
	tDMQyh2ZAtCc/YZWSJjDQ/aIHfRGl9D/KRkdLwordlGPwSlvE+cFgTc5PuypogrWESPMj4uhSU38V
	mF4Q2C3w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rFwB9-0040NI-6F
	for fio@vger.kernel.org; Wed, 20 Dec 2023 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 45FBA1BC015A; Wed, 20 Dec 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231220130001.45FBA1BC015A@kernel.dk>
Date: Wed, 20 Dec 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit c77fe6859b6ef937a6ca900c1fab009175d721f8:

  engines/http: use proper error value (2023-12-15 13:17:13 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to be943a3ef5d94d8a9fefa11dc004789f66beb8e6:

  t/zbd: add test case to confirm no write with rwmixwrite=0 option (2023-12-19 19:52:35 -0700)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      zbd: avoid write with rwmixwrite=0 option
      t/zbd: add test case to confirm no write with rwmixwrite=0 option

 t/zbd/test-zbd-support | 23 +++++++++++++++++++++++
 zbd.c                  |  3 ++-
 2 files changed, 25 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 2f15a191..532860eb 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1561,6 +1561,29 @@ test67() {
 	grep -q 'Exceeded max_active_zones limit' "${logfile}.${test_number}"
 }
 
+# Test rw=randrw and rwmixwrite=0 options do not issue write I/O unit
+test68() {
+	local off size
+
+	require_zbd || return "$SKIP_TESTCASE"
+
+	reset_zone "${dev}" -1
+
+	# Write some data as preparation
+	off=$((first_sequential_zone_sector * 512))
+	size=$min_seq_write_size
+	run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off" \
+			--io_size="$size" --zonemode=strided \
+			--zonesize="$zone_size" --zonerange="$zone_size" \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	# Run random mixed read and write specifying zero write ratio
+	run_fio_on_seq "$(ioengine "psync")" --rw=randrw --rwmixwrite=0 \
+		       --time_based --runtime=1s \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+	# "WRITE:" shall be recoreded only once for the preparation
+	[[ $(grep -c "WRITE:" "${logfile}.${test_number}") == 1 ]]
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index c4f7b12f..61b5b688 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1876,7 +1876,8 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
-	if (io_u->file->last_start[DDIR_WRITE] != -1ULL || td->o.read_beyond_wp)
+	if (io_u->file->last_start[DDIR_WRITE] != -1ULL ||
+	    td->o.read_beyond_wp || td->o.rwmix[DDIR_WRITE] == 0)
 		return DDIR_READ;
 
 	return DDIR_WRITE;
