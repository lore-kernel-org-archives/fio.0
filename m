Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055622063FE
	for <fio@vger.kernel.org>; Thu, 13 Feb 2025 05:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739424324; cv=none; b=it16ocS/OZkPMAcXwQkWeBZelJY6O9xBXL+7BYK4piDBS17bujArf7CUHaDqw5MzCViiNcKDzofEvW4vZ59xgDudRxpwn4SeBkoABccbXTaiwDWRYFUAZQplAjpYZtnx+6/lUQXg2QI6DGnNuTDGepaXwt55wu2Z8pEF3H3IIeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739424324; c=relaxed/simple;
	bh=OI6X1Qc9aR6A6zRSP1PWgrHq/eIL3Dcot+ZILmAoyJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+ohG4StrptAN/wqaAAu0L0m4khLC0Xt+DMAuipdg47ebC4kUARJEx4M2Qo0yyWq+ktYYohJDPO1aSH9R/sFHmVidrhTV2Mty2oNPWD9X9cnS2Pm4NGz50eFDURzcF6zmjfpsWoVKTscpjmMLB6I/XlmytDnwuerOqbZshiEUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LU/FPXnY; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LU/FPXnY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739424322; x=1770960322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OI6X1Qc9aR6A6zRSP1PWgrHq/eIL3Dcot+ZILmAoyJI=;
  b=LU/FPXnYzbuTWpvVXl0jovlBDHfKf2QFRr+fXjBE71H2G9fk/yGkUHKJ
   oaleqEPxybsHRjlIlSoB2duQNnWN/fYVyNKy+salrFkr8Mu8yLP6j5TlU
   dqdw/eZu8UruhbEtHj66sp5w8l4HiqVv15Axllw80osSNodSCe3hS0VW6
   C58OVAAe5Jj6ac+SsKH6W+eFIDQSqZYBSBXsEKyKUI5/VtfB9j2++EvJi
   HwYEfgAcNFdt6gJUVxvVMJ8cQPN7X2frBnqu2zVeCnO4XnP3ljFvrTppd
   Ev+3lX+KdDSLtnv1tgOOA7MQjw36zMpsPlcoOZ4qEuE1mKw7IWS/HEprY
   Q==;
X-CSE-ConnectionGUID: tWqzuh3fTHy5iOK88t6ipw==
X-CSE-MsgGUID: MCQu4yhOTD+de9vASVjiog==
X-IronPort-AV: E=Sophos;i="6.13,282,1732550400"; 
   d="scan'208";a="38948613"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2025 13:25:15 +0800
IronPort-SDR: 67ad7488_clkS190yAyl8VYeFPbQcTE/vhTKykpin8DNNhTqZHVFwgRR
 dZl20k4XjANrYwnLyDBM67DNg9XdU02dDk+TaTg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Feb 2025 20:26:49 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Feb 2025 21:25:14 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 3/3] t/verify-state.c: adjust to verify state format change
Date: Thu, 13 Feb 2025 14:25:10 +0900
Message-ID: <20250213052510.1474423-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
References: <20250213052510.1474423-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit modified the format of verify state files. To adjust
to the change, add support of the new field "max_no_comps_per_file" and
pass it to __thread_io_list_sz(). Also check the version number against
the new version 4.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 t/verify-state.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/t/verify-state.c b/t/verify-state.c
index 734c1e4c..f8787e9a 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -23,6 +23,7 @@ static void show_s(struct thread_io_list *s, unsigned int no_s)
 	printf("Name:\t\t%s\n", s->name);
 	printf("Completions:\t%llu\n", (unsigned long long) s->no_comps);
 	printf("Depth:\t\t%llu\n", (unsigned long long) s->depth);
+	printf("Max completions per file:\t\t%lu\n", (unsigned long) s->max_no_comps_per_file);
 	printf("Number IOs:\t%llu\n", (unsigned long long) s->numberio);
 	printf("Index:\t\t%llu\n", (unsigned long long) s->index);
 
@@ -46,6 +47,7 @@ static void show(struct thread_io_list *s, size_t size)
 
 		s->no_comps = le64_to_cpu(s->no_comps);
 		s->depth = le32_to_cpu(s->depth);
+		s->max_no_comps_per_file = le32_to_cpu(s->max_no_comps_per_file);
 		s->nofiles = le32_to_cpu(s->nofiles);
 		s->numberio = le64_to_cpu(s->numberio);
 		s->index = le64_to_cpu(s->index);
@@ -57,9 +59,9 @@ static void show(struct thread_io_list *s, size_t size)
 
 		show_s(s, no_s);
 		no_s++;
-		size -= __thread_io_list_sz(s->depth, s->nofiles);
+		size -= __thread_io_list_sz(s->max_no_comps_per_file, s->nofiles);
 		s = (struct thread_io_list *)((char *) s +
-			__thread_io_list_sz(s->depth, s->nofiles));
+			__thread_io_list_sz(s->max_no_comps_per_file, s->nofiles));
 	} while (size != 0);
 }
 
@@ -90,7 +92,7 @@ static void show_verify_state(void *buf, size_t size)
 		return;
 	}
 
-	if (hdr->version == 0x03)
+	if (hdr->version == 0x04)
 		show(s, size);
 	else
 		log_err("Unsupported version %d\n", (int) hdr->version);
-- 
2.47.0

