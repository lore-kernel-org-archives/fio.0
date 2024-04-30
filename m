Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D01833982
	for <fio@vger.kernel.org>; Tue, 30 Apr 2024 10:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473035; cv=none; b=XP7wvPG+RZg8M7q3wazNiH6CAVDwOSr2OCjgNoRYhojYN2gmXt2riqbxBHE35Cr1Vt30bl5IRQg1JNoo3Pbd4oRtPs1KBB+CTKtzKLcorksiBTdSS3PcnyWSh8exzpNAbiHyozSj+uGpUusACtOkZ7yoVjeWDNSFRP2NWjyoT7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473035; c=relaxed/simple;
	bh=tkP+WblJY/3gEcvZrzZwNs8bISzDgjXDyaEm3iIC1kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlwXrIJ3k0tCHSm+nu4vJL7+/qvSw3xNpw6sVxzgUJRWJhpI4+3XGyAtjzZVNaKKk1jzU6P3LhL2PuoAmEjjgcb+VuunUSeJyxRh5rEYJXyqdHTp6r6EIwGlR5OtGG5YTJPQZwpXhSR4wn7F1CgpYp3r7UrkzsZ+tubOspwmvNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iqgBV/iC; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iqgBV/iC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1714473033; x=1746009033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tkP+WblJY/3gEcvZrzZwNs8bISzDgjXDyaEm3iIC1kw=;
  b=iqgBV/iCvxy98iTxuI79DKhG6XmK2v5KDOrOv9XD4NQDc962WV7zuIIZ
   I4otX25SsdUCzDhxj5RnTnSZ/DESukC5/jZyKrJ1ce0dCYCdPDegu3Z5E
   k+0FWtdGWAGSwe9q8xY6WVY91rRdEr2xnz4MwSvK/FkHpKjBWc/SDC79y
   m2tbJa+d7oKIbUwljYmXVsgmlyenXYvYt9d/ZmhXknGYqeWbH6ViPUh8i
   d4Ddl3SxdzMFIpnMzqJ6YkgtrI25vGif8h7Ss8QIdjr5XZ3rrgvMNyIKb
   4EoitME1ww1t6a7l1g3/fa9N5RzDtrxj/ULPe/fNew8iEXC9D+5qGqa0e
   Q==;
X-CSE-ConnectionGUID: EQ4+3GrYQ++VM0VYGoBG2Q==
X-CSE-MsgGUID: /n1u4M4ERFyjgk/23Rn0hg==
X-IronPort-AV: E=Sophos;i="6.07,241,1708358400"; 
   d="scan'208";a="15244717"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2024 18:30:24 +0800
IronPort-SDR: wzjFdSXHdM8KYZJLLt+Wz4vN+YdIL1M8xSriZdhfWKXO+aMjMAeGr9jrFTeqR1eez76t6TtnFK
 lQ00Xul5dB+qmbBZL/bJzAXqqUo1WTWAo59fOziEJLelKNJc03rRhRqFnatN8pTLhObqbkrEvR
 1G9Qhayjr+wNzzjnyVQJtqaF0yJtBQc5JvjYbg4m8EvqCbFnIrOYYfLTZNA7I6+R4AmRkF5uSP
 z8NW4CjK6sm1ZisbCUxDtvXKyOYgDYjxE2CKqFJhvJPu5i03sXVurHcFnEwqsJMn9lXzHyxEQ/
 rSM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Apr 2024 02:38:28 -0700
IronPort-SDR: IewKajwMNAmP8W9I0NbX0gVYTIUWpxK+faXweET9I0L0k9svxzEwmjd+zQ++U01SS4JrNEn+rM
 mY0lRkAeYSLakhQL5MWQEt30Ezeru64agd2VqnzOX96p6Qy2w68cAyd0ixGkQ+r5cWQsR/FvNA
 kjVtKK27jAk08lFs0cgBSh/0ha17ieMVw+PtxYy8v4N5UUrJ0yqOfpElbKJ+lqG/7JBvRXliI/
 yfenNTvCbfTtbcOTLo+wlECd7xr6arp4dhAeLhysy4UAQWFHDO/3ml/agUjNtIKdAtqQqlDqgY
 +Ns=
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 30 Apr 2024 03:30:25 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/3] zbd: remove unnecessary verify_backlog check in zbd_file_reset()
Date: Tue, 30 Apr 2024 19:30:20 +0900
Message-ID: <20240430103022.4136039-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
References: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit c5c8b92be5a2 ("zbd: fix zone reset condition for verify")
improved zbd_file_reset() to not reset zones when data to verify is
left. To check the left verify data, it tried to do the same as
check_get_verify() including the check for the modulo operation
"td->io_hist_len % td->o.verify_backlog". This check is required in
check_get_verify() to know when to do the verify backlog operation.
However, this check is not required in zbd_file_reset() since zone reset
is not related to the verify backlog timing. The unnecessary check for
"td->io_hist_len % td->o.verify_backlog" allows to reset zones even when
td->io_hist_len is non-zero and the data to verify is left. It erases
the data to verify and causes verify errors. Fix this by removing the
unnecessary check.

Fixes: c5c8b92be5a2 ("zbd: fix zone reset condition for verify")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/zbd.c b/zbd.c
index 37417660..8a092cbe 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1361,9 +1361,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	if (td->o.verify != VERIFY_NONE) {
 		verify_data_left = td->runstate == TD_VERIFYING ||
 			td->io_hist_len || td->verify_batch;
-		if (td->io_hist_len && td->o.verify_backlog)
-			verify_data_left =
-				td->io_hist_len % td->o.verify_backlog;
 		if (!verify_data_left)
 			zbd_reset_zones(td, f, zb, ze);
 	}
-- 
2.44.0

