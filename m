Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761634;
	b=XBW8ua38sTuU8XgANnWJsujxGCzQiqI9i+cjTgFVtkkT7HOW7BV1IYgfjoVm8trERZ9g
	 nDg0MVfa0b565sMgd+Le8vocu0V0rr2vlG5aLJBgMSy9OcUmQ3SKCtGc9equCIlShCiw5
	 HJsaoUTf/L4zSzYyYkIvrun1jiryxYKlXsNCcUE2luQzwZNOxI9ChdnxM1MqhsGxFZKPC
	 QZl/TpDhHBVxjOyh8wlFQ1Oz86n1RnjnGHZe4OjGaX+zdaHKfwXPl5Rxk2b4B8kRMgSuk
	 eEE7ejbgOhGlMsQQNcAVPVxzy2jbOJaury2kAN7az++MW9MAbppjhddkXSiB4hI+9xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761634;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=j3oucDGpkmptshHWQmNFNMxVuXGMzAx1dWuKCi+FTnk=;
	b=V0QNwLBY5PEHSj8ycltKGOye+r44BgxAbTAXXycsU+7uliou1chkQzBkMTsIq18rQ6cf
	 ULQBVY62YRdJ7urnJXx7mlB7nnnu8j3HN6URJWcM0Rt9laWS4yZ28kYZJRfezd3IIUMHB
	 yc55yQ8vbt4RA1nY5FJiY63FpZQuubkenZVV/suOTFTVBeIAPAokw/P0R2G2wu7AaOevZ
	 wpan4NH013Vzr3BnTIN/6ZI45G3xX+ac9UXV4ga5G7x5tBpMrIMb5bghexcqCG6VWCa8H
	 ntJDAhOLu0TWxwXCpyPODdoAOt0S4u2H3bPN4bzgqzH4ahlRY0oaAWLr0KjteJJenig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="U/pxGXcY";
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD6A606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFD6A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=U/pxGXcY
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761641; x=1827297641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U3frJMeN46/TUuEeqmEuQEDH/2FHaD6acVPFw04/bx4=;
  b=U/pxGXcYMIlKras2bcF1GaFJ/uorybVIGp2bPTfYjnYlMw/2gxXdhR2f
   u2bfikecyCAuSrDTO0skfuqqHgKSvAiZPhpe5DWMYK4mKUgkRqe0IbEYr
   cgMe0X8Lp2gQeJqYpOQzyJU3WSJM7oVn8qJHnv2uO64jpAtDoy1F4niRx
   BGhRaPQT3VoIdGeBh2HyQRKAqiJz28LsHIW9W8kP5Gk69kcFhMTvqrTMW
   wybyVvYL1coZcBPvYDRf2IZR3b5fGM2+fOoK5CnGUZgs44WY4FzLShuiM
   deamO5ETvYlmywWKn2kVOe2ya3IZqFBsND65y6ET3k7VIBHHYppmpf4RT
   Q==;
X-CSE-ConnectionGUID: 0T+iED51S6CJLFu/NSEXIg==
X-CSE-MsgGUID: le5hspz4T0Wn4juXRpe6vg==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815438"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:41 +0800
X-CSE-ConnectionGUID: rX+ZeCxFSym7TYpY2y/KBg==
X-CSE-MsgGUID: 121YbvDTRG27l2PNwdUiFA==
IronPort-SDR: 6b0925e1_//1Alyynx8x0YUejv7fIHbeWpKt3Y+hMgA8pOe8EMc+Le4O
 qAQNWeqZGPQFq/Tk4DNdKyn2yF0cOzGMW9hQHWQ==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:33 -0800
X-CSE-ConnectionGUID: zIGmN/WtTcmG8N7BFYq4dg==
X-CSE-MsgGUID: pEgYad6vS8eU8rC3KkeDog==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:33 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 4/8] blktrace: use unscaled trace length for merge_blktrace_iters
Date: Fri, 27 Nov 2026 15:40:23 +0900
Message-ID: <20261127064027.1909326-5-shinichiro.kawasaki@wdc.com>
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

When fio merges multiple blktrace files with the options
merge_blktrace_iters and merge_blktrace_scalars, read_trace() offsets
each record of a repeated trace by the length of the trace, and then
applies the scale:

   t->time = (t->time + bc->iter * bc->length) * bc->scalar / 100;

The length is taken from bc->t at end of file, which holds the last
record of the file. read_trace() does the scaling work only for the
timestamps of the queue events it returns, and skips other events before
scaling them.

If the blktrace file to be scaled and iterated ends with a completion
event, as blkparse output usually does, the length is unscaled and
correct. However, if the file ends with a queue event, its timestamp has
already been scaled at the first iteration, and the scale is applied
twice at the second iteration. The timestamps of the second and
following iterations will have wrong values, and I/Os will be replayed
at unexpected timings.

To not have the wrong timestamps, record the unscaled timestamp of each
record during the first iteration before the record is skipped or
scaled. For that purpose, check bc->iter which has zero value at the
first iteration. Also, ignore notify records, which may carry absolute
timestamps.

Fixes: 55bfd8c81c25 ("blktrace: add option to iterate over a trace multiple times")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 blktrace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 6339382f..c6e41c5e 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -702,8 +702,6 @@ read_skip:
 		td_verror(td, errno, "read blktrace file");
 		return -1;
 	} else if (feof(bc->f)) {
-		if (!bc->length)
-			bc->length = bc->t.time;
 		if (++bc->iter < bc->nr_iter) {
 			if (fseek(bc->f, 0, SEEK_SET) < 0) {
 				td_verror(td, errno, "blktrace rewind");
@@ -720,6 +718,9 @@ read_skip:
 	if (bc->swap)
 		byteswap_trace(t);
 
+	if (!bc->iter && !(t->action & BLK_TC_ACT(BLK_TC_NOTIFY)))
+		bc->length = t->time;
+
 	/* skip over actions that fio does not care about */
 	if ((t->action & 0xffff) != __BLK_TA_QUEUE ||
 	    t_get_ddir(t) == DDIR_INVAL) {
-- 
2.56.0

