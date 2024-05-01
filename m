Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC23644C8C
	for <fio@vger.kernel.org>; Wed,  1 May 2024 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714564818; cv=none; b=Q7ZUcmt1s9IEt8rVOVqGZS96zRvD8JRM7j3Ctu53fwN4jC6ZSjPAVickZWuSD8XFydNT54pos+UNnVuVsQ3gEjM3CCo6juv2Ua6iC84ruTyzUGh4LAhaorFKMWzKwINKmR99JWF5jFY5EBVrmjk3yoe2XDep8RtXC/uA5/cjZOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714564818; c=relaxed/simple;
	bh=4Vwq27Nrr2Bx251/DrcYr3oL/mh9d0pyTD3Fc68ryho=;
	h=Subject:From:To:Message-Id:Date; b=fH8zUcORAbYEKes0C92TMU3KtkR3xEUAoNbArkTJxzlVLpMyw/oATom8YTTz7IF9vzFJp00PcGN1/IwCCoCe/9IGw32shIA03+D74xKXsNi5TFTNdyfJELFLGf1kpiXczUEyw1DcvZQQSEXPugMXpJIpehv1J8p8rvNiqPyCvpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l8m6y1Bf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l8m6y1Bf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/qFl+zJ1MQ4wk0eAMXxMlQxos+kRDMo49BX/HWzZGyI=; b=l8m6y1BfVlCgpJFWa/2KNOWER1
	Ed8RrUtkZkMvvPlbpuzrYOdo3pcDIh7aIC2wMkU1Ykn5w5u+SGMx/5fFzn5CFNf9YpqSV0gMArgja
	8VH+ybrHzPXAXeZMJdTuqcG8mXh5KZWalRifIm7O6UadLndXSdch30hsQNVJoctDeamOL0+ZxaC1R
	zAqgwqErHgc1lX6SwKLo77IH+b80LawKofBxKRb2YPgedVZdbHO1bN/jEwo8qTVzBR/8Ilq3gkuaM
	Cz77dG79M+dlbCNUNWd2Ma6yhNx62O9l9vG0AFXs9wRCKa0QBXpnP/BqNEnL2K56YuxlMSilqtu7e
	YgqoezYQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s28d3-0000000Godw-00aM
	for fio@vger.kernel.org;
	Wed, 01 May 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2989D1BC012A; Wed,  1 May 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240501120002.2989D1BC012A@kernel.dk>
Date: Wed,  1 May 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6a9a9bd2c524a7ef58d2fb8181038408155902b8:

  t/nvmept_trim: increase transfer size for some tests (2024-04-25 14:25:54 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3ed8eea0ee9b5d7de603e9b128e6c05941b99938:

  t/zbd: avoid test case 31 failure with small devices (2024-04-30 11:11:58 -0400)

----------------------------------------------------------------
Shin'ichiro Kawasaki (3):
      zbd: remove unnecessary verify_backlog check in zbd_file_reset()
      t/zbd: add test case to confirm verify_backlog=1 options
      t/zbd: avoid test case 31 failure with small devices

 t/zbd/test-zbd-support | 19 +++++++++++++++++--
 zbd.c                  |  3 ---
 2 files changed, 17 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index c27d2ad6..e0b2a755 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -852,12 +852,15 @@ test31() {
     # To distribute the write target zones evenly, skip certain zones for every
     # write. Utilize zonemode strided for such write patterns.
     bs=$((128 * 1024))
+    off=$((first_sequential_zone_sector * 512))
+    size=$((disk_size - off))
     nz=$((max_open_zones))
     if [[ $nz -eq 0 ]]; then
 	nz=128
     fi
-    off=$((first_sequential_zone_sector * 512))
-    size=$((disk_size - off))
+    if ((size / zone_size < nz)); then
+	nz=$((size / zone_size))
+    fi
     inc=$(((size / nz / zone_size) * zone_size))
     opts=("--name=$dev" "--filename=$dev" "--rw=write" "--bs=${bs}")
     opts+=("--offset=$off" "--size=$((inc * nz))" "--io_size=$((bs * nz))")
@@ -1593,6 +1596,18 @@ test68() {
 	[[ $(grep -c "WRITE:" "${logfile}.${test_number}") == 1 ]]
 }
 
+# Test rw=rw and verify_backlog=1 options do not cause verify failure
+test69() {
+	require_zbd || return "$SKIP_TESTCASE"
+
+	prep_write
+	run_fio --name=job --filename="$dev" --time_based --runtime=15s \
+		--rw=rw --offset=$((first_sequential_zone_sector * 512)) \
+		"$(ioengine "libaio")" --iodepth=32 --randrepeat=0 \
+		--verify=crc32 --verify_backlog=1 --zonemode=zbd --direct=1 \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index 37417660..8a092cbe 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1361,9 +1361,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	if (td->o.verify != VERIFY_NONE) {
 		verify_data_left = td->runstate == TD_VERIFYING ||
 			td->io_hist_len || td->verify_batch;
-		if (td->io_hist_len && td->o.verify_backlog)
-			verify_data_left =
-				td->io_hist_len % td->o.verify_backlog;
 		if (!verify_data_left)
 			zbd_reset_zones(td, f, zb, ze);
 	}
