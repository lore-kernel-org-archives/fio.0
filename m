Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E882110
	for <fio@vger.kernel.org>; Sat,  9 Aug 2025 01:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754702234; cv=none; b=PAPWF1JANUUYt1aa00MWM2hlgEfPcw4Edv0CSXnZTxxcNNqqmIPs2HV0dXGqihLAOuUQO7bLbDgNJsuo63mhJbV1RgiuXb6/U0yLziehma/hFwQpo4OfgsZzncUOAw8r8gwwBD+RcCZPfrMfC+T5Iw6qsqj5AwN+ivjAi32qZHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754702234; c=relaxed/simple;
	bh=QyQk1VLcIlvUNTq5VXTt4sjIYo2TQqxN1Rx99zwJNQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0W1JH6keYV91J90ziI7YqXOiBQLpKTepJMZA4mGgVdIBA1LcCoR9Brsau9CLZUhUQC3VgMBwmH5uy8+x+MfDWcIoOyc1h/D0pcJymudabu/9wgl2HsnMpWyOkZVTTqWEidLPYhgxK4GmtWtQe8FWAPneZDur+olxbQXkK1KBlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JQMzKiHt; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JQMzKiHt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1754702233; x=1786238233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QyQk1VLcIlvUNTq5VXTt4sjIYo2TQqxN1Rx99zwJNQA=;
  b=JQMzKiHtKjlnH+lY8nFSVc+Jll7qffkCZ9fQ6e8q9zjiXxE59hBYEbiY
   JMEoey9jkuuyZt6ZsNnfwgRYqVX4jjyPPT9S0DBRX13OavFZ7suOWO5bK
   7DlkvHdbnIzO9R0lgVxl1RL2jPB5wF7lSSBLGGWhzP+6DFY2qR4FwHcjc
   IpLml5W16yXKeGuAFKI4MlzCk5M4OFBDcw42Q1SAEapmEEPkPagZ9+bQr
   i7J3ITnklV9pV52pRqydbnkV8GBx2/KxyKoB4NlZiRs2cEQojeZFPACmJ
   aJxm6r15TJ/rKR90K5dc5WVMvw662xPgyoitrPGh2Q2jY9EdBeejn+g5t
   g==;
X-CSE-ConnectionGUID: wtUtC/YIQMilKKm47AiBdw==
X-CSE-MsgGUID: m77NY5+rTPiOI9Rw8o/DGw==
X-IronPort-AV: E=Sophos;i="6.17,278,1747670400"; 
   d="scan'208";a="104622435"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2025 09:16:06 +0800
IronPort-SDR: 6N+l09Kdm6rT9XvdTXrqJ4a0uRRBcbO0p5tpmbOrJlfYR3wC8OT6xAgC2DjuRmWDvGlSRKvXWA
 HoyGtCUXanLqXhfGjdxpv2o7nXC1eULEj7M7jP/ND+skj49e+nvc84zSZcboDhHSnoKPC3csh4
 LrbXcWjix/YnOrVOphszcGIJCJX2JL6fDW8+rpzIK62AFAL8lrRYU35YFJZCqKSPBpT/vu9DRr
 ki8kvu5U0cZzmziFCSg/rD1Pzer0r2xzWYGlJ+0MgObnSIHJMiKV9tSJfAyOsip891PecnxX4A
 Mcc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Aug 2025 17:12:03 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2025 18:15:58 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Riley Thomasson <riley.thomasson@gmail.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] verify: bump up verify state file version
Date: Sat,  9 Aug 2025 10:15:55 +0900
Message-ID: <20250809011555.948564-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
References: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 935297d18d58 ("verify: plumb inflight write information through
verify state") modified the data structure of the verify state file.
However, the version number of the file was not incremented. Then users
may encounter compatibility issues when working with the verify state
file across different fio version. To avoid the issue, bump up the
version number.

Fixes: 935297d18d58 ("verify: plumb inflight write information through verify state")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 verify-state.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/verify-state.h b/verify-state.h
index c055008e..d8997ace 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -41,7 +41,7 @@ struct all_io_list {
 	struct thread_io_list state[0];
 };
 
-#define VSTATE_HDR_VERSION	0x04
+#define VSTATE_HDR_VERSION	0x05
 
 struct verify_state_hdr {
 	uint64_t version;
-- 
2.49.0

