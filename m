Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761633;
	b=ifmStEdmme63oLSRNvGqBqzrweStKV3zJfhjnHjZI8kwt3LsoY2Ep+GAqb+vy4D0Wz+G
	 WgKZP7BFabJ+h/9FWQpmq/SOFjNOYuRALDt6oA4FHtORweBw3eIg63acZsmvoLcLWR7Df
	 9c2JSz+U7PB5JS9ZgHteMV7MH5YAaDNzSKtMzikErW1tQVLw3y4nktqTl2BVlmTiB/74I
	 LuUdCGp9zS3kIP+J8F2cTvGBBzm0Jc6JurYvoUKXd+IrZIXARo/09Hape2nd+dt1En0JG
	 J9yLLLbX/BlvOgPMzvhT6nyA7JBWUpIfeLrtzNX6Nc7sHp91L1Lsfz8IN5tk85+Q/WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761633;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qOMx9NL9nKMEDCxhXKaZ4LlWPboD8G1MM/o6+O54u/A=;
	b=ce/1JkSYYL4Pq8Ic6rOpkDfpLiCXQrOn8HLHIci7quKgSIy80cOwYfNEJ9u/F21gGuDJ
	 lvtSjpKH0GEW6Wo+VWOD/xOR2tvxT6rTHdYi60xGyOGhqAO+QbwnXICUrYxilFdj4WNi7
	 CENjNc3waLVaNx9cTTu1Lpk7Ek6mqgNImetetZPDTHP8pO5XGtbzQDGQtPu3Iu0qazO2k
	 bnI79c09kYu65EeGGBjP6Qm7mE3Q44RZxw2YDFaYMs801u6g0BGLb1cqL3sPfF+EbewMA
	 lq1VgTdORPvc/xTs9H5vQSUhMopIGOkPsknOambhzamNy0r9YvqcNwZD57KZ3DryqiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cDleGIH0;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917B8606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 917B8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=cDleGIH0
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761640; x=1827297640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q529beD00O9y6/tfT8hyT8NQ6UBevZx/ALuN25z8EzI=;
  b=cDleGIH0qhf/Yk/J1+YA/yDbzHFeVDRNkK7MhlIdnuQRQkUTmfGKj9n3
   TICRp3lrOj3oil/HeUXVdsEbrBKBpRh11VlmguKvh+nKLRV53ZZhQc8S8
   bXhNXCJ/jihCoNbJXS3rwaS1ChjQDnnK864TPmnGwv+ABmGsTg6MErZnl
   4/RuDcJe806PTAt0gpIYz+8EohBMaFnQncjsPuU3MPjCOKaTekgAJqQIe
   TRs724UORsGlkto6/yxhzPAZfEnQS+NobJ7i8C17eHeCu6HyIrIEy5jw+
   d85KenAdbuMI7wkf9s+UpFI2ED0fg0UC9wjpzUBsfi4Vo7ce4V+eBQwZh
   g==;
X-CSE-ConnectionGUID: W60DL6vmRFCvBXQZLiwo0Q==
X-CSE-MsgGUID: c1Z+ULSYSd+Hlv+6U9dsbw==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815434"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:40 +0800
X-CSE-ConnectionGUID: jal4tyfnTl+DfkPQL/kKRg==
X-CSE-MsgGUID: V0sDwFe2QzqcE98ggmDqMg==
IronPort-SDR: 6b0925e0_tkYmb5TR6V7yb6ztDZAzDlEuXtL3QEvsHK8bKW8ToFVBtJ2
 uF8n/F08nSeIX8l1nfniL/TGO0dxfFGW2zQHHTw==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:32 -0800
X-CSE-ConnectionGUID: L/cLRdcLQG2wf7e+mVeojg==
X-CSE-MsgGUID: WABOJUgeSkuDZ49Xzavvlw==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:32 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/8] blktrace: fix trace rewind for the merge_blktrace_iters option
Date: Fri, 27 Nov 2026 15:40:22 +0900
Message-ID: <20261127064027.1909326-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
References: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fio merges blktrace files with the option merge_blktrace_iters, fio
rewinds the file position indicator of the blktrace files using fseek().
When merge_finish_file() does this rewind, it does not read the next
record. Then the cursor still holds the last record that read_trace()
read, which is the last record of the file. This last record is written
to the merged trace. If the last record is not a queue event, it is not
replayed as an I/O. However, read_blktrace() uses completion events to
probe the queue depth, which is used when the iodepth option is not set.
Then the additional completion event can change the queue depth of the
replay. If the last record is a queue event, the event is written to the
merged trace twice. When fio replays with this merged blktrace, it
replays the unexpected additional I/O.

To not write the extra record, move the rewind into read_trace() from
merge_finish_file(). read_trace() now returns zero only after the last
iteration is done, so merge_finish_file() only needs to close the input.

Fixes: 55bfd8c81c25 ("blktrace: add option to iterate over a trace multiple times")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 blktrace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 1edebc8f..6339382f 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -681,12 +681,6 @@ static int find_earliest_io(struct blktrace_cursor *bcs, int nr_logs)
 
 static void merge_finish_file(struct blktrace_cursor *bcs, int i, int *nr_logs)
 {
-	bcs[i].iter++;
-	if (bcs[i].iter < bcs[i].nr_iter) {
-		fseek(bcs[i].f, 0, SEEK_SET);
-		return;
-	}
-
 	*nr_logs -= 1;
 
 	/* close file */
@@ -710,6 +704,13 @@ read_skip:
 	} else if (feof(bc->f)) {
 		if (!bc->length)
 			bc->length = bc->t.time;
+		if (++bc->iter < bc->nr_iter) {
+			if (fseek(bc->f, 0, SEEK_SET) < 0) {
+				td_verror(td, errno, "blktrace rewind");
+				return -1;
+			}
+			goto read_skip;
+		}
 		return ret;
 	} else if (ret < (int) sizeof(*t)) {
 		log_err("fio: iolog short read\n");
-- 
2.56.0

