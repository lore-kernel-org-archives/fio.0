Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D98A20F97A
	for <fio@vger.kernel.org>; Thu, 23 Jan 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737637211; cv=none; b=Ch5kYLmivnDMFU1dC0WJw0GddoxA6JR7Ya8REZx+FV6K5GojJp8n/fR6hOmBUquSJ/pU4Bwkmn3VhQ/Qt/K+SEgMPsJqrgx1Kcdrcr97uTRJhFk3/ECWFKEn5C1aJEPFacp04Lk+Uxfws2R4bWEAcp9Z0+6D87NIgA+E8bvJ+Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737637211; c=relaxed/simple;
	bh=/JhpaxeU+MWpLJIjqeOso7PIV62RhrtksNNrsJJB3Sc=;
	h=Subject:From:To:Message-Id:Date; b=FH3lCRTTs7gC72+U+xBGWiDmO5ba30WQsG9wI1byd+t143XE7WbMRnpoBOZ/STopcQcjcsWCs9/pwNR3t5syqcVwGUWNNMIzsUIXzJaqIqxZCfhlHd5LrcUNEDfCMDwri8Z/pxGkzMkXHBXX9k2rd17x2IWGCIa3CcOc5tUOl/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TdzkuAX8; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TdzkuAX8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YnwcXhvGPKA7uNN9BWn3hHxwusWiRG5g1jwo5GRBtow=; b=TdzkuAX80whBSkbbCiSoOSymgB
	+tdtNajcnJWEoyXLx40eKliAQH4LKn/4S3mv4n/ifZzC6QLBzYiovQF+6zGZ2zgH0Mj9igTmSYrcr
	qoP0QmvED4kJyh8/U2teXNhPlyuH7aH0l3rEAs9Vq/sr4Fwc9/z7rhl5Hau1zkyx+GfyjAu7K4kJb
	m5HmvjO6rE3LeTgWfqPNQJiaL/EEAyJLwLV3f2kyopfDSXPw/zTdIloHUREDWkKnVS0DGgYtAZ5Nz
	lkH+Ktflif4Lsi3FtLtUYMaaRDj1VEfTrtbLx8eA6sgGTg9JA0F/shSxxN4feLxi5vdyXU1lbwCXE
	zoUGiScg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tawoW-00000008yfz-2nfT
	for fio@vger.kernel.org;
	Thu, 23 Jan 2025 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 335621BC0152; Thu, 23 Jan 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250123130001.335621BC0152@kernel.dk>
Date: Thu, 23 Jan 2025 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 187103ae7c28701d73725200a73dbb39eef72221:

  Merge branch 'pre_success' of https://github.com/kawasaki/fio (2025-01-21 11:38:18 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0f754a3af30fe6f308ce1c0f95bf1a6f99b3177a:

  t/zbd: add test case to confirm no max_open_zones limit check (2025-01-22 11:08:37 -0500)

----------------------------------------------------------------
Shin'ichiro Kawasaki (2):
      zbd: do not check open zones status and limits when jobs do not write
      t/zbd: add test case to confirm no max_open_zones limit check

 t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
 zbd.c                  | 10 ++++++++++
 2 files changed, 39 insertions(+)

---

Diff of recent changes:

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e0b2a755..468fce70 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1608,6 +1608,35 @@ test69() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Test max_open_zones and job_max_open_zones do not error out for non-write jobs
+test70() {
+	require_zbd || return "$SKIP_TESTCASE"
+
+	reset_zone "${dev}" -1
+
+	# Write data to two zones and make them open
+	run_fio_on_seq "$(ioengine "psync")" --io_size="$min_seq_write_size" \
+		       --rw=write --offset_increment=1z --numjobs=2 \
+		       --group_reporting=1 >> "${logfile}.${test_number}" 2>&1
+
+	# Confirm max_open_zones=1 for read workload does not fail
+	run_fio_on_seq "$(ioengine "psync")" --io_size="$min_seq_write_size" \
+		       --rw=read --max_open_zones=1 \
+		       >> "${logfile}.${test_number}" 2>&1 || return $?
+
+	# Confirm job_max_open_zones=1 for read workload does not fail
+	run_fio_on_seq "$(ioengine "psync")" --io_size="$min_seq_write_size" \
+		       --rw=read --job_max_open_zones=1 \
+		       >> "${logfile}.${test_number}" 2>&1
+	grep -q 'valid only for write jobs' \
+	     "${logfile}.${test_number}" || return $?
+
+	# Confirm max_open_zones=1 for trim workload does not fail
+	run_fio_on_seq "$(ioengine "psync")" --rw=trim --io_size=1z \
+		       --bs="$zone_size" --max_open_zones=1 \
+		       >> "${logfile}.${test_number}" 2>&1
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index 8a092cbe..ee095b1d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1264,6 +1264,16 @@ int zbd_setup_files(struct thread_data *td)
 			return 1;
 		}
 
+		/*
+		 * If this job does not do write operations, skip open zone
+		 * condition check.
+		 */
+		if (!td_write(td)) {
+			if (td->o.job_max_open_zones)
+				log_info("'job_max_open_zones' is valid only for write jobs\n");
+			continue;
+		}
+
 		/*
 		 * The per job max open zones limit cannot be used without a
 		 * global max open zones limit. (As the tracking of open zones
