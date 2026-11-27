Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761630;
	b=heZBq9ugk5geMALyuVAaHmNhjsE1LZOKsP3A0D4W7iMK6iMs4++o2J5nOUYU3+r1BILP
	 zAIMq8oa4xXxXbRo6OzWrZYpxWhsQEIl17lnZndYM66T8KWyk5unuOuCe272QLFlhoAMB
	 k4+ko0B+LkkvLamWwXWlEr+kRPdUHDRJnzfTYIwg+E7syFSpvNIalB3+hf9joAMyhY4zC
	 uADWxqRdfIePO3Exg/ZrnPX0ybNBB9Qn6RI2uARlGAhc/QcmWbHyl1jeH2nUYBNF+RIGW
	 1RWnGDSA1RtWpjdi+lSBcD99U0PeWwSPD86Vmz1Z4TIbn4X7+/h+BG8xBbb6M9YBdXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761630;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=62UHRYxC2SxX6r0Cp82OSle+fDLvHCErZgaQIbqnlTQ=;
	b=bkfLn40x6QnM52bf2QgjlOCw6iUv6P1PdzbNG3QmeoErlnj8omY8CEBu1//Kma0bhs/7
	 h39CIIK7D64e38hzR3zhgkzbsZCyWZBLSh1+VMET5o9LAQTlYQ6YLKmrHfdCQFSVaJUk5
	 oLsnLVAH67LQf756ME2hTvnWdDbTOnnqU8m1no3UTT8SIdFk8jGRw3Npw1eVeVtfo1m+y
	 HeGHdqvjigiouAsRGCnZLb6TXHH67kaMj/gzfgYAYJJ3Gns8erNIb2WM1CisTt0PePkne
	 +VllNrhM4Fxvdv0TWcV4yzDCpGZN/bORU+Q7M4rlZX+EM/70aigpXg4IDxH4tkZrx3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YV7hPlnq;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2565D606A323
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2565D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=YV7hPlnq
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761638; x=1827297638;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hOXAklWL/j1Ql1GGIcqGpvw//Wj8PpF9lIWIoLppNRs=;
  b=YV7hPlnq3JU0i4pEygh8K7upwwQJR6OsW32Fbg3f20dKeNeyMBI7amrc
   QshDCdBQyo3W5FdQOeaVjf75Qj76UMtAemOk2LyQrWse0ZPK11Y+3rliD
   hsC3VrnWYZ1ecSH40Fj86Ve9p2pkLS5Bo1zRokcURQtYfUWlWe5PeBBHG
   hm27CAOoGAZr3IHfiSkf+01ZYMgKXY2Q4jD/fi+8q0lLbp7JAHvkVTTRg
   mCC4bYRSvAhV4BEX3znoupm5IW5oW+ssLrvTRwLkt6s/ABdl4rKhqTATs
   clOqFGmY9j58h0vqNg9BpS0jmavfLFT75l5eFqTLGDmOCPckYbDO6wkpd
   g==;
X-CSE-ConnectionGUID: UTh9lbt2T6SZrSGremzE7w==
X-CSE-MsgGUID: RABHJ98DRP+wKOSo+CFLSg==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815427"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:38 +0800
X-CSE-ConnectionGUID: LiX8+7O3TvSXVm3swtlxXA==
X-CSE-MsgGUID: G3HVGpX5TEGI+brTFzSl4g==
IronPort-SDR: 6b0925de_4bG67ZDMcIPBG/uAg8Qua0pJziVecqhZmT1OVlBaVk2HJZ0
 W2CIZmhnCDSMfia79BU04RoyrUvnp5bm/pDVD6Q==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:29 -0800
X-CSE-ConnectionGUID: tyEl9amtS3GDlFv1TAyVAg==
X-CSE-MsgGUID: XSuLSDn2RNm8Y0em5YAcXg==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:29 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/8] blktrace: initialize merge cursors
Date: Fri, 27 Nov 2026 15:40:20 +0900
Message-ID: <20261127064027.1909326-2-shinichiro.kawasaki@wdc.com>
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

merge_blktrace_iologs() allocates the blktrace_cursor array with
malloc() and only initializes the fields 'scalar' and 'nr_iter'. This
leaves other fields uninitialized. However, read_trace() uses the
uninitialized fields 'iter' and 'length' to calculate timestamps. This
adds garbage offsets to the timestamps of each input blktrace file, and
results in a merged trace with meaningless timestamps. To avoid such
invalid timestamps, allocate the array with calloc() so that zero is set
to all cursor fields.

Fixes: 55bfd8c81c25 ("blktrace: add option to iterate over a trace multiple times")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 blktrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 1f2a9bc0..59f25741 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -745,8 +745,8 @@ static int write_trace(FILE *fp, struct blk_io_trace *t)
 int merge_blktrace_iologs(struct thread_data *td)
 {
 	int nr_logs = get_max_str_idx(td->o.read_iolog_file);
-	struct blktrace_cursor *bcs = malloc(sizeof(struct blktrace_cursor) *
-					     nr_logs);
+	struct blktrace_cursor *bcs = calloc(nr_logs,
+					     sizeof(struct blktrace_cursor));
 	struct blktrace_cursor *bc;
 	FILE *merge_fp;
 	char *str, *ptr, *name, *merge_buf = NULL;
-- 
2.56.0

