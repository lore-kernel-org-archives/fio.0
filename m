Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CDA3A6405
	for <fio@vger.kernel.org>; Tue, 10 Mar 2026 20:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773176295; cv=none; b=OmbwbGa1hHjZJ1mdkMHnkfex30r4zgaqKLZs3OddMAZxGWc6BNMTWtvYjryz9Yr93e4Wor+hv9uWgRDBYHm3cPLEwVCTXYJspGSCQzvPetNmrGmAGLzcct3zkTCH+mo+vS53HrvagxcFWxzQH49bJcCTLPQkGKafX5+JTCGkOAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773176295; c=relaxed/simple;
	bh=eR3c1NFPpPmPLpw/Kqu12r+tGdZxGhv3rl5kOLyNG8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OHLaPkV28bac1lkAbvZPgJfS3U41EuIEn9VSXHsS6OvNh13Neyy/uo+vZ9CQw2ZV+4kvJ3fxKPZWUdWhtuqGzS73OQUCiwH8TyU3gYLIVROSUgBxY8WRAU719jRJYW7cUDeOEM/z45FmAEJb75/A7PsfDy0IJnJlVzWa0EhqdZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kGniD0VO; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kGniD0VO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773176294; x=1804712294;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eR3c1NFPpPmPLpw/Kqu12r+tGdZxGhv3rl5kOLyNG8k=;
  b=kGniD0VOO+SrS4ndAId3XCSgOX5T06DmXsr0PvqEgcWTkurkhUvHYibI
   Mr/HlL6Grw6AXlOalhdv9rNDL7hzC9ix8JN1ITIl7fghjXC+BuHHeLDjf
   AcgePRwhCC+/TJLlI5s90uKNqb0sGVsdgS5lh9DHW/bhL5e2X8sQMQD/a
   aSipZhH87qp2RMwIOGaVwanWXu12OyCAOX8RrqD6AQcTEPC0D9aTyCudm
   8vqyxxFTlQ1eiVQH3Ea0liVrvpj/ox1BCLhHRFs5Ifn31iRhQtFoOU/qx
   yw2PgKea3aFXFE3oHcbH8DuDWmxa841xSUrHFVFa612NAG0REzgZBhxiX
   Q==;
X-CSE-ConnectionGUID: uL4vjgUgT5G4aQPeQZs3GA==
X-CSE-MsgGUID: LUuv/8NNTHmYNemwgSB0Dg==
X-IronPort-AV: E=Sophos;i="6.23,112,1770566400"; 
   d="scan'208";a="142803962"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2026 04:58:08 +0800
IronPort-SDR: 69b085dc_jRUNjijDYqcpavX4EN/HA7SH2kj9Yf6zOfLrfs5OR1b8Xh3
 MuCCMX2vFIOwfTLO91G60xNtpDdrHsCW6omKf6g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2026 13:58:06 -0700
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2026 13:58:04 -0700
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH] backend: correctly handle rate_iops combined with bssplit
Date: Wed, 11 Mar 2026 05:58:04 +0900
Message-Id: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, rate_iops does not produce the expected I/O rate with
workloads that use 'bssplit' option. Consider the following example
configuration -

[global]
direct=1
time_based
runtime=30s
ioengine=io_uring
thread=1

[bssplit_rate_iops_repro]
filename=/dev/sdX
rw=randread
iodepth=8
bs=64K
rate_iops=50

This works correctly and ~50 IOPS I/O rate is logged during the run.

If we replace 'bs=64K' with the following bssplit option -

bssplit=32ki/20:64ki/40:256ki/10:512ki/25:1mi/5

in the configuration above, then some incorrect (much lower) IOPS values
are observed to be in effect at run time.

This problem happens because fio, in order to derive the required
I/O rate from 'rate_iops' value provided by the user, simply multiplies
the IOPS value by the minimum block size (min_bs). Once bps I/O rate is
calculated this way, the processing for 'rate' and 'rate_iops' becomes
identical.

This works if the I/O issued has the uniform min_bs, as in case of using
'bs=64K'. However, with 'bssplit' option in effect, fio may issue I/O
with sizes that are much different from min_bs. Yet the code in
usec_for_io() currently always calculates I/O issue delays based on
min_bs leading to incorrect IOPS being produced.

Fix this by modifying usec_for_io() function to check for
bssplit+rate_iops being in effect. For this case, derive the IOPS rate
from bps 'rate' member of thread data and then calculate the delay to
the next I/O using the IOPS value, not the bps rate.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 backend.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/backend.c b/backend.c
index 6dd078c4..2a171bfa 100644
--- a/backend.c
+++ b/backend.c
@@ -842,15 +842,31 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 		}
 		td->last_usec[ddir] += val;
 		return td->last_usec[ddir];
-	} else if (bps) {
+	}
+
+	if (!bps)
+		return 0;
+
+	/*
+	 * For rate_iops option combined with bssplit, recover
+	 * the user provided IOPS value and calculate the I/O delay
+	 * based on this value, not on bps.
+	 */
+	if (!td->o.rate[ddir] && td->o.bssplit_nr[ddir]) {
+		uint64_t iops = bps / td->o.min_bs[ddir];
+
+		if (!iops)
+			return 0;
+
+		td->last_usec[ddir] += (int64_t)(1000000 / iops);
+		return td->last_usec[ddir];
+	} else {
 		uint64_t bytes = td->rate_io_issue_bytes[ddir];
 		uint64_t secs = bytes / bps;
 		uint64_t remainder = bytes % bps;
 
 		return remainder * 1000000 / bps + secs * 1000000;
 	}
-
-	return 0;
 }
 
 static void init_thinktime(struct thread_data *td)
-- 
2.37.3

