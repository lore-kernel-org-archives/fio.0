Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761635;
	b=D/QATXfz8wjb8EXgiCJCyG763v7VPuO8JcdBBUf5pnuf2dg3Ldo9aHwJqpHAL+gHacKC
	 TjUGJlMu6Vcs1k+DCtHQNEj1G9wqDxqYugdMoZEMf5OVC5jnlA/m6F+eWc2ZzX7mjGq0d
	 iqSvA+mPZ+covLR55Cmtn81+pJx3y5/GQ71zLlkiNzpZgV5Be14Jnbz7zLmTtIAhI3T95
	 enJS3ANl+WgcLdvsBqqvcMMQEUUOZarT8xDhxm8iPjBH7gHsQpX45fTk5zgMQaJI/lwQL
	 KQh7KR0JJ7DCi1+i/iZM56UMEzg8vy9vLXonDfsBUKldjWiYxHTMuFf3scKRgYh9nrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761635;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8e8Wb+oQ8kpk7R0R/dkLAqgPPp2WvsL3eaGZwPplW9o=;
	b=5MSA4ImvW5Cj2OkZPc3a7PktQIKzIiSdZWJ+CnuhXDN4z43QvzA8/xnBHRFrzD39XS8b
	 nWthpIDy5RXWhojrTKSa5ddtB+smzE/EB4BQn6Yzlo2Znw2bY0I97Ckc7k/FuQ81LW7En
	 VQyv0Mm0A5S4mJ3RzfOTq8kiTj1AZoQNcQNVCmMX/SgiWaVXu2pqZhBspF98l51/EwheU
	 n1PB8gegYk3ZzH2MAg3bWrzYbvmMUyVpRP6OLk1L3nTofY7a4GHAmOTw52Nzdrtd9XKFy
	 4rJsCpsTRo+1rhv09+enDkVpKVrsdevVSkpY3GtRoNgrbgRMRhek69Sa/4rS5r3XU4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=aeOrh9RB;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE3606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2BE3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=aeOrh9RB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761643; x=1827297643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AgwMeYduFZa0DUHAKOviF6JEI2qxZipyyrCAnIDNx9s=;
  b=aeOrh9RB2u3jS20pvvmoEd5/SyVzG28ES+nEsDIlONpzIwLzbKttXkmT
   koqKCNiEvX4Aciw7EQsEesbBEKF5LxhAC6Vj+DPkXb9hCAbzCrg3F9q1/
   W/0yyVAODPdL44xHeQDo9zq+MLjSNB8/KqEIb05cBZjIt284iBNqX3bjr
   lADAgOw+WkWG9SihK+jdakfjsFEWRzvg0s89s/IWc7VczDmGYTeFPbwYr
   iOSaAMKSAry7Te1HVhWju/GNnmw889UWUKrUMlJttKxDv/IgrV+/StQRl
   h3zNpBedgighSgPgNVUqngoV9rAMUzfY5Xe2yK/kq3T2wMwK/hpimmVF4
   w==;
X-CSE-ConnectionGUID: niw/cdhnTfSwkQKn4+JCMw==
X-CSE-MsgGUID: 4sNXKTRoSkWMTNEtOZUSqQ==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815445"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:42 +0800
X-CSE-ConnectionGUID: bODDFho7Rf+Tg409yEG/Jg==
X-CSE-MsgGUID: 9yrfZ9kBTHa0uHUPck9AkQ==
IronPort-SDR: 6b0925e2_THK/FiIbjkF2tMPm1NbR7rnj6jyzKinyZbd88UveJfM9mgF
 vm5zdFOYaMHzJ6iLHjKrOEssjEpKC9SWwwqttvA==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:34 -0800
X-CSE-ConnectionGUID: 5p9ULynATeeSaqKPXVzxGw==
X-CSE-MsgGUID: 6IDvJtalTHW8+iqMCc3l2w==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:34 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5/8] blktrace: fail merge_blktrace_file without read_iolog
Date: Fri, 27 Nov 2026 15:40:24 +0900
Message-ID: <20261127064027.1909326-6-shinichiro.kawasaki@wdc.com>
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

When the merge_blktrace_file option is set, fio reads the list of input
blktrace files set to the read_iolog option. However, fio does not check
that the read_iolog is also set. If the read_iolog is not set, fio just
crashes:

  $ fio --name=r --merge_blktrace_file=out.bin
  Segmentation fault

To avoid the segmentation fault, fail with an error message if
read_iolog is not set.

Fixes: b9921d1a56d9 ("blktrace: add support to interleave blktrace files")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 blktrace.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index c6e41c5e..00008d16 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -746,14 +746,20 @@ static int write_trace(FILE *fp, struct blk_io_trace *t)
 
 int merge_blktrace_iologs(struct thread_data *td)
 {
-	int nr_logs = get_max_str_idx(td->o.read_iolog_file);
-	struct blktrace_cursor *bcs = calloc(nr_logs,
-					     sizeof(struct blktrace_cursor));
+	int nr_logs;
+	struct blktrace_cursor *bcs;
 	struct blktrace_cursor *bc;
 	FILE *merge_fp;
 	char *str, *ptr, *name, *merge_buf = NULL;
 	int i, ret;
 
+	if (!td->o.read_iolog_file) {
+		log_err("fio: merge_blktrace_file requires read_iolog\n");
+		return -EINVAL;
+	}
+
+	nr_logs = get_max_str_idx(td->o.read_iolog_file);
+	bcs = calloc(nr_logs, sizeof(struct blktrace_cursor));
 	if (!bcs)
 		return -ENOMEM;
 
-- 
2.56.0

