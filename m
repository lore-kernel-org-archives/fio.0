Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452491BDC4
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913215; cv=none; b=RE0EUgkueWqAtBssATNc4ApaZf2e9AOjA3uAnB+Ov8wZOhwKUQyyev/DLU7aRdpv1BuQnlPQrXWtWW2n4yhTRd6eg/UB1Aiyy0Qnsxq9tUth0/XAgiT0pop8I6uA6IoCCY9oNTXt6PHYDivnR4ER78YC9oKRneuUU1f9My7SbRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913215; c=relaxed/simple;
	bh=MuQ1Fg50Ml5LyfynaPw165Fl9WjiZWLXqMiG1Xnk4jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx3EGcpjFq6XsQGTYp+bYrXWo8cCP6evLiah2ZfX8rGlhA6MNtMal0557OYEccWYgYsOFONxP/oGxxxFNYngof35/JCvxgsTpcSYctLCw94AwFlIQBf5kXzfVSXqiDoz4tm6kbG7efFvzo5MMsSzLh5UGhDSikf1WHe0PH+Fs78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CbCRAuu2; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CbCRAuu2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707913213; x=1739449213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MuQ1Fg50Ml5LyfynaPw165Fl9WjiZWLXqMiG1Xnk4jM=;
  b=CbCRAuu2zUk6cXgSdWeuQCjIBQhs2xDbTs1WAj/dFEVymxC1ePNbVbBC
   iHWyMrSlFLOqJpUoiNrgaVjXK3fFA/7+kYxbGlaI9tzCtB67I1UlxinOb
   fq9VgQydoMoOrHlh51nsKJdHgS11HEbM12bo7EespHTDzCdAqfbPE3Ub/
   YRXWKZy5806yb3XSFX8pMdx48hmxQtboztARWm/mNG3msa/pLi+eVFNA3
   djB4HBGvnbFTxjzTNzanyOXj/n6yaYvAnAJrwW3UIHlCFkaPfCDJzRpah
   7Psu+7FZHm32KTZ+ym2CdBskYoSJ7pAbAIROnNyRb0NBqglN3hvlu782g
   g==;
X-CSE-ConnectionGUID: gqqTMISSTe2V5VJ+GK/IZw==
X-CSE-MsgGUID: lyL9Z+D0TU+jPuahbihRQQ==
X-IronPort-AV: E=Sophos;i="6.06,159,1705334400"; 
   d="scan'208";a="9479625"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2024 20:20:11 +0800
IronPort-SDR: rQz2PHmet70EizNAbHm93jT/mYMkqdfS7YgRJae7qYGRhcl/vJ/WjvQFvUKAe7Wo1R1QI8Q7Ty
 G8JxU6V39JWQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2024 03:29:47 -0800
IronPort-SDR: f7MNiS+BGPaxsWNpWxbv8NW8j9ntxJFXMmbwEW386NSHrwQn8ZP4eVYhBtC2CeDhOAje/VGBAy
 9NhVgoVF2mHA==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Feb 2024 04:20:09 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] verify: fix loops option behavior of read-verify workloads
Date: Wed, 14 Feb 2024 21:20:07 +0900
Message-ID: <20240214122008.4123286-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
References: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 191d6634e8a6 ("verify: fix bytes_done accounting of
experimental verify") introduced td->bytes_verified to separate the
verified bytes from the read bytes in td->bytes_done[]. This fixed the
issue of experimental verify feature. However, it caused another issue.
When the verify workload does only read and does not do write, the read
bytes in td->bytes_done[] is no longer updated and always zero. This
zero value is returned from do_io() to thread_main() in the bytes_done
array. If the read bytes is zero, thread_main() marks the job to
terminate and it makes the loops option ignored. For example, the job
below should do 8k read, but it does only 4k read.

[global]
filename=/tmp/fio.test
size=4k
verify=md5

[write]
rw=write
do_verify=0

[read]
stonewall=1
rw=read
loops=2
do_verify=1

To make the loops option work together with the read-verify workloads,
modify io_u_update_bytes_done(). After updating td->bytes_verified,
check if the workload does not write. If so, do not return from
io_u_update_bytes_done() and update td->bytes_done[] for DDIR_READ in
the following code.

Fixes: 191d6634e8a6 ("verify: fix bytes_done accounting of experimental verify")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 io_u.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 13187882..4254675a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2151,7 +2151,8 @@ static void io_u_update_bytes_done(struct thread_data *td,
 
 	if (td->runstate == TD_VERIFYING) {
 		td->bytes_verified += icd->bytes_done[DDIR_READ];
-		return;
+		if (td_write(td))
+			return;
 	}
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-- 
2.43.0

