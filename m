Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F43AB26C
	for <fio@vger.kernel.org>; Wed, 10 Jun 2026 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781092814; cv=none; b=m82Xg8GDw3Lgkdx8Hdm2Z5GZ5D+xB3EXKxjBWlfRgHakG1o+SiYVms4MM+NogsSbdzXCi5yvWwwl2paeqX3C+feni16EnTwl0KECjluBmipC23IhG+VrBtdD3qPytKRIBT97g1I3JDqbgXu/tGahpSxQWyJOxIcNsJWjmDLPFxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781092814; c=relaxed/simple;
	bh=3hLrqGScyIRYr4qjzf0kdJeQaH1ofk3dgoxXm0GUP54=;
	h=Subject:From:To:Date:Message-Id; b=fHezu/u4t4wDET4CKqV0AJB1zHsK8DB34Yz0KPdXqUDcIWlgjLkrbjSaHK4aOULp6kfWuCj8VKPJeJYBSqYRuQpzc1VSJseo9/eLiCzFf3DKMeIYqLDveH7/yaSWC9fe8cZd1lemledXnYqE80nlR1GVYNigB6IRpy0athksRW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W5Nne9la; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W5Nne9la"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=V17/aNQyPxqltL5Z6qOvUkjVbrDlXH5jHhfAnZkARGY=; b=W5Nne9la9hNj0t9+aAXBkrsFr0
	JsO9d2PIiGG+zYBWD1efctcIFKKiGHcy9UpNKc0RjAW0tkhKV7TTWvx349TtWiHAL/n/gJWWYWJO1
	t/QEAaeGJpTG+l17dQ8jvM6V2VB/+402TDNAjv1GMS96tX53LKNQbkqio7wgQdhgrU5K7K4eRJ9rO
	f3zITTDtZBUAJCc9empcFWjSMuo4H9z9cZvzYeG0LAXpNGxotKcHVg3VTGcO3+CmWc4rhqAiKVbJb
	882tRCuk1noii3vQTlsGF/TEhHQ4ufroE10vzrndO6HfTvU2DBZyDrpYOMJYDVZH4ajHa4Puks+Fv
	tJHOkk8Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXHbK-00000003q2S-3Na5
	for fio@vger.kernel.org;
	Wed, 10 Jun 2026 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1493C1BC0165; Wed, 10 Jun 2026 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 10 Jun 2026 06:00:02 -0600
Message-Id: <20260610120002.1493C1BC0165@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit cf144e06b4f98492f6ca8a17157bcf284b3f64a4:

  t/run-fio-tests: add verify_state_save.py (2026-06-08 14:05:55 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f055bacb90990b96fe9940579b3f7eda3515679f:

  t/nvmept_write_mode: fix fio path (2026-06-10 00:21:19 +0000)

----------------------------------------------------------------
Vincent Fu (2):
      mem: adjust alloc size for [rand]trimwrite workloads
      t/nvmept_write_mode: fix fio path

 backend.c              | 21 ++++++++++++++++++++-
 t/nvmept_write_mode.py |  2 +-
 2 files changed, 21 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index af5a22b7..8ff3bc12 100644
--- a/backend.c
+++ b/backend.c
@@ -1574,7 +1574,26 @@ int init_io_u_buffers(struct thread_data *td)
 	char *p;
 
 	max_units = td->o.iodepth;
-	if (td->trim_verify && td->o.trim_zero)
+
+	/*
+	 * Trim operations do not involve data transfer. So we typically do not
+	 * have to account for trim sizes when allocating buffers. However,
+	 * there are exceptions:
+	 *
+	 * - if we are in trim verify mode we need a data buffer the same size
+	 *   as the trimmed range in order to confirm that the trimmed offset
+	 *   is all zeroes when we read it back
+	 * - if we are in [rand]trimwrite mode we need a data buffer the same
+	 *   size as the trimmed range in order to write data at the trimmed
+	 *   offset
+	 * - however, fio can mistakenly believe it is in [rand]trimwrite mode
+	 *   if it encounters trim and write operations when reading an iolog.
+	 *   So when replaying an iolog we do not need to account for trim
+	 *   sizes when allocating buffers even if the [rand]trimwrite check
+	 *   returns true because this is a false positive.
+	 */
+	if ((td->trim_verify && td->o.trim_zero) ||
+			(!(td->flags & TD_F_READ_IOLOG) && td_trimwrite(td)))
 		max_bs = td_max_bs(td);
 	else
 		max_bs = td_max_rw_bs(td);
diff --git a/t/nvmept_write_mode.py b/t/nvmept_write_mode.py
index b52bd8b0..21a6ea1e 100755
--- a/t/nvmept_write_mode.py
+++ b/t/nvmept_write_mode.py
@@ -261,7 +261,7 @@ def main():
     if args.fio:
         fio_path = str(Path(args.fio).absolute())
     else:
-        fio_root = str(Path(__file__).absolute().parent.parent)
+        fio_path = os.path.join(str(Path(__file__).absolute().parent.parent), "fio")
     print(f"fio path is {fio_path}")
 
     for test in TEST_LIST:
