Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761636;
	b=GuWAnf3MLQeYqzvU4EbS5otogq++Jy6r82w/z9TTcaUJS9q8Slswfg1/Peoa87beDi7A
	 JNzWaBI7nl8a5vWcRGdsVt1biOrWzK5SG3ehIFwnugMU5/peRmgKdGoBLzYzVAaQEzviH
	 Ex7vDRAn5WLr8EOnh1W4Ex8nCRd90j6L0S0VJ7lFoR7NURen0SyV4PjqhnKVFREBLeLmy
	 nyAIJuMyewrXil2a41iG+xBsmyiBqPsH+xDnq1qEJbsMKNZ2nQKLSfoCcJugPuIEbP5uJ
	 bv4Ca5390yXNn9kPEKuD8C2p0T7BKd/lAcQgMn35UiEiLF1ZWKYoacZz376vac7obvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761636;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=s+UP1KEQXE4Widl4radBLcEhT2XxzbfN8ueybi3Yb3c=;
	b=Gvix6hoddvu3HkdwPqP9yAbICPhHQIAQw1ERSQCPMk/SczOf4OxZXDxBBqTfGMKvyume
	 U0qZ3/xoAABX34x/wkol8zEOJAxWQkVGzMaz05mbmrHnPOdJ81YUYTYSGGOQJv1NAAxTG
	 7WedDH53ckdCDjG56tyCDeoCygSZANabi/qTLnmcS0634uEAWh8HV9YJePy4rqoZ+yewq
	 lZfU84FI7cZF1WRz5Z8dsFdfQXCzFXfr0/7HE0M8tG9LA1hksicpSxpa3piY0a1gW+G1C
	 WEzqTu51o39oKfBoLc6OG2gK2FUbOMwFbg/+vFRdjftgMLrNUqg2Uss+U9ZNl0aS3dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b="Q7E1d/hO";
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324A1606A31C
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 324A1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=Q7E1d/hO
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761644; x=1827297644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0VzDPBiHOpTkl0SaCBZgVO/muOezYTQwRVoBsyqBN/s=;
  b=Q7E1d/hOdgmf4OdtDJTL45HcGOb5bU+VW+uBqLIktc9QPdumFtHzDPrc
   J6rkHwe2aN7BysL4OMaRQj7vy4fRytRKj+dpsJEi6/6pKpnCoAXHJ6W58
   6vv2u23Cu3sS/0bSNF45AT0Dr6O1YN1GOCZn6TSDgBUWzlToVKB3PUkFh
   kTQbMO+9VByk9YK+xn0xURF+SGXaR6KXUAURLCeVJ3JpJlRvFs+yksGgE
   JBUFRloFObbsXX5OQU7zQtP9PhXu+DH5FUivwGj6e0sC2GyzK4mK3jmru
   Ho+VSK7/YBzlNEEhpM5qMJKURmKD73+A5wHYLFhDOUfEztwC4XyxR9/C8
   A==;
X-CSE-ConnectionGUID: yng0n8gpTem3czjHgBub7Q==
X-CSE-MsgGUID: 7fiqKeaKRQ2RMNunfW1qzg==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815448"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:44 +0800
X-CSE-ConnectionGUID: HY+4FI/0TIqaUFLfADNv3g==
X-CSE-MsgGUID: F8Gz408zTp+keJFWfDK43g==
IronPort-SDR: 6b0925e4_RUCCNcSv8enVsMSyKVoG5iSIi3NCP5XeI8tWOXPBDO3xJJ/
 3BKSoB6PslftY07Y8BHAjvYMfeyyAcV/DvQ4B6g==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:36 -0800
X-CSE-ConnectionGUID: YSulz92JRxCd8AL02WIoyA==
X-CSE-MsgGUID: OJLIoN9uToSP3Krj3XNNeg==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:35 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 6/8] blktrace: ignore a partial trace at the end of a merged file
Date: Fri, 27 Nov 2026 15:40:25 +0900
Message-ID: <20261127064027.1909326-7-shinichiro.kawasaki@wdc.com>
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

When a blktrace file passed to merge_blktrace_file ends with a partial
trace, fread() in read_trace() reads only a part of the trace, and
returns the number of bytes read. read_trace() checks the number of
bytes to see if the read was partial or not. However, this check was
placed after the end of file check, so it was never reached. Instead,
the end of file check returns the number of bytes read, and the merge
writes the partial trace to the merged trace. When fio replays the
merged trace, the partial, broken trace causes an unexpected I/O.

To avoid the broken trace, return zero at the end of file also after a
short read. Also print an error message to report the short read.

Fixes: 5ab088aa50ae ("blktrace.c: Use file stream interface instead of fifo")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 blktrace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/blktrace.c b/blktrace.c
index 00008d16..68c30b36 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -702,6 +702,8 @@ read_skip:
 		td_verror(td, errno, "read blktrace file");
 		return -1;
 	} else if (feof(bc->f)) {
+		if (ret)
+			log_err("fio: iolog short read\n");
 		if (++bc->iter < bc->nr_iter) {
 			if (fseek(bc->f, 0, SEEK_SET) < 0) {
 				td_verror(td, errno, "blktrace rewind");
@@ -709,7 +711,7 @@ read_skip:
 			}
 			goto read_skip;
 		}
-		return ret;
+		return 0;
 	} else if (ret < (int) sizeof(*t)) {
 		log_err("fio: iolog short read\n");
 		return -1;
-- 
2.56.0

