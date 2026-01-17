Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6227C31AA81
	for <fio@vger.kernel.org>; Sat, 17 Jan 2026 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768654813; cv=none; b=O2MqJc2iIuh+xg8ogc8en73nauWD6HBxeLHZRp0jE8bhe4Vear5UjCoV3fShI+dlPUTqqN2GJO0ZPPNf+Zc96oMD+l5xJPgvXItiwlyJYZFaYiRMSz6vufAW7QUgCQCZmfEtUkHwkOwbqFQXvrhBdzNmI7B6Fqx9HyHmDWW7BBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768654813; c=relaxed/simple;
	bh=PDmEjXrV4ergZLy8dqpEKLH0m4kwGje6zgv8a9ZDsXY=;
	h=Subject:From:To:Date:Message-Id; b=gAeKzX4VukCQi4DzGdcg7pGXK64BYqaAwVL87VgbBwXXO28qcrsk70MKn5SgkRcmH7jeWk8iCY1BuuO8HE3iAsFC1vLbtqzHLO78+hEE3obB2i9+VfoDYsDwXYt79oon2kACll9Wxt/uj1MrFeinzGqM2/sBC8QFCsNrLIvnGhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rzkhrvdb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rzkhrvdb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=DJFATLnnfTVRzXrpJccxg/V+nlHH4e273b00Vg3IE9c=; b=rzkhrvdbdH+OvwrkFJLquKX9/y
	NpQr3x4y6n3fSu4s802D5tvHk5Hs/cWKBA5XdMxFbUQxetNm1/aVfiKsxbsxSrpfilw7ytzyiWr7p
	HZTP90Nv4WjeT114g+mtreL1INjl+oiPOSWL71ZKYGsTfGz8xBqKyTxeKWr6AbckRjLS/JPt9lAha
	fFVFhN7BykuyLk875YFZYo35tY7n6bJzyeBez1UNmB5RNZqSFWPSisHMutffaDGqc7EUcZWY07yYM
	koUvdLdAssNhNbpo3Hh72EPx/1Y7rLBm40WCqpNGrO2jhQ2hwdYBRnwYGeRd+Vnt2BAdCvXdcjoi/
	iO2+aIeA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vh5uQ-0000000AmWW-2j3C
	for fio@vger.kernel.org;
	Sat, 17 Jan 2026 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D12E81BC0144; Sat, 17 Jan 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 17 Jan 2026 06:00:01 -0700
Message-Id: <20260117130001.D12E81BC0144@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1d282baecd689f4409449d5e5238b30990cec377:

  fio: make sure that child process output is comitted (2026-01-15 17:35:13 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e2d1cce0f1c5617467f95ac2154212179451ba85:

  test: add test for switching to tausworthe64 (2026-01-15 21:02:38 -0500)

----------------------------------------------------------------
Vincent Fu (2):
      init: move random seed debug prints
      test: add test for switching to tausworthe64

 init.c             |  4 ++--
 t/run-fio-tests.py |  8 ++++++++
 t/t64-switch.sh    | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 2 deletions(-)
 create mode 100755 t/t64-switch.sh

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 8a0d8c20..5a982b53 100644
--- a/init.c
+++ b/init.c
@@ -1236,12 +1236,12 @@ static int setup_random_seeds(struct thread_data *td)
 		}
 	}
 
-	td_fill_rand_seeds(td);
-
 	dprint(FD_RANDOM, "FIO_RAND_NR_OFFS=%d\n", FIO_RAND_NR_OFFS);
 	for (int i = 0; i < FIO_RAND_NR_OFFS; i++)
 		dprint(FD_RANDOM, "rand_seeds[%d]=%" PRIu64 "\n", i, td->rand_seeds[i]);
 
+	td_fill_rand_seeds(td);
+
 	return 0;
 }
 
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 457d7f8c..b3321312 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1131,6 +1131,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          1020,
+        'test_class':       FioExeTest,
+        'exe':              't/t64-switch.sh',
+        'parameters':       ['{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.not_windows],
+    },
 ]
 
 
diff --git a/t/t64-switch.sh b/t/t64-switch.sh
new file mode 100755
index 00000000..94b12754
--- /dev/null
+++ b/t/t64-switch.sh
@@ -0,0 +1,43 @@
+#!/usr/bin/env bash
+#
+# Make sure that Fio actually does switch to the tausworthe64 random generator
+# when it detects that the combination of block size and file size exceeds the
+# limits of the default 32-bit random generator.
+#
+# Do this by counting the number of times offsets occurring more than once are
+# touched. The default random generator should produce more duplicate offsets
+# than the tausworthe64 random generator.
+#
+# Count offsets by parsing Fio's debug output. Use grep and cut to obtain a
+# list of offsets, sort them, and count how many times offsets ocurring more
+# than once are touched.
+#
+# Calculate the ratio of tausworthe32 duplicates to tausworthe64 duplicates. I
+# am arbitrarily using a minimum ratio of 10 as the criteria for a passing
+# test.
+#
+# Usage:
+# t64-switch [FIO [COUNT]]
+#
+
+FIO=${1:-fio}
+COUNT=${2:-1000000}
+
+t32=$(${FIO} --name=test --ioengine=null --filesize=1T --bs=1 --rw=randread --debug=io --number_ios=${COUNT} --norandommap --randrepeat=0 --random_generator=tausworthe | grep complete: | cut -d '=' -f 2 | cut -d ',' -f 1 | sort -g | uniq -D | wc -l | tr -d ' ')
+t64=$(${FIO} --name=test --ioengine=null --filesize=1T --bs=1 --rw=randread --debug=io --number_ios=${COUNT} --norandommap --randrepeat=0 | grep complete: | cut -d '=' -f 2 | cut -d ',' -f 1 | sort -g | uniq -D | wc -l | tr -d ' ')
+if [ $t64 -gt 0 ]; then
+	let ratio=$t32/$t64
+else
+	let ratio=$t32
+fi
+
+echo tausworthe32: $t32
+echo tausworthe62: $t64
+echo ratio: $ratio
+
+if [ $ratio -ge 10 ]; then
+	echo result: pass
+else
+	echo result: fail
+	exit 1
+fi
