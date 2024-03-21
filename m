Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085BD7482
	for <fio@vger.kernel.org>; Thu, 21 Mar 2024 03:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710990623; cv=none; b=Veb/+N6t1HaeveyLawfoOerQ9RoxdxZqCCKnLTMF+wc+AkKCuJReiYAYeDYOoi6+Wcx8MdAuG7o+GdPIGwiGuBa7Ly8pMUnP6RzI60Q/g3mOw/+uC8tZkD+zAjHGVDk0XAZeSTaeZCX++JewZtkIB0zdZg3x/vNOGzYCocqsp5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710990623; c=relaxed/simple;
	bh=rcXctql6W59+rax2SUbIhFrlZuzVkb/zuWulieEjG5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7zUqAeZT4tml4k57i2afK+v6n+ngcME3UD3D4uxpZLEvQvBBnHVp3HAPD6bIuDdoLO5k1q8oM37pp+uq/BH+JdL69YRNNu8Ery/1AONota+69k6wamp++kL0nnM6f14AFtRdTI0kPosFjwZyOQptEDaOc88BAEUXHgKwti6HV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QqugXKrl; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QqugXKrl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710990621; x=1742526621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rcXctql6W59+rax2SUbIhFrlZuzVkb/zuWulieEjG5w=;
  b=QqugXKrlfW9G2W/HFBKPm+AfYA4IPVSuZyKvklTDtRbDih03IBLlxVCa
   tp3m7H2K69b/U5mFPjysu4OlFdnZlIMdxmIEeVGVjIdhRqGIA1SgS/goi
   NU2rDp3BRDx86CCLvrWrTDYLWFoMEM77uQYmEXNCseiZh0lgf8IBHUH8r
   pPaQAfx99f1tLae5s4z9iCh11kP+ZNcHgLwFSy0dTCr91z/c1EheFQT9N
   ZudTn9lk3xd2fs2y8DMNpJWOnG5Fy29Ud6mEoZBJ+5mSrWmKo8j9NM6+2
   3lFpl7vmMFd5H4Vnq3nzW+FObHVPn8DzVzqG6OWMnNJKWwsVhBJqSfZpf
   g==;
X-CSE-ConnectionGUID: 4wvTNY7jQw2mscPaCkMYdA==
X-CSE-MsgGUID: VSzdm2dASpW4IC1CSHh2Vg==
X-IronPort-AV: E=Sophos;i="6.07,141,1708358400"; 
   d="scan'208";a="12730329"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Mar 2024 11:10:14 +0800
IronPort-SDR: Xg7Ko20Phz+ANSIA6SvDcNUzy2fzzwyRBx0dEWIJ8NA6SB0UGQCjE8ZXb9zPZ+nA99I+sf3EnD
 mmaDDTpOEPLw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Mar 2024 19:19:06 -0700
IronPort-SDR: xzXeRIAaZqeMYmbrppADNiEIGPYEdXQgAF5R7VrgW/q20ZrO+tsvjrXNAkAiMJfODaGKGo/Wsq
 gXz0O+HgnhYA==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Mar 2024 20:10:14 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Kookoo Gu <Zhimin.Gu@solidigm.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] iolog: regrow logs in iolog_delay()
Date: Thu, 21 Mar 2024 12:10:10 +0900
Message-ID: <20240321031011.4140040-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
References: <20240321031011.4140040-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit b85c01f7e9df ("iolog.c: fix inaccurate clat when replay
trace") triggered the assertion failure below for the workload which
does I/O replay as asynchronous I/O together with log recording options
such as write_lat_log.

  fio: stat.c:3030: get_cur_log: Assertion `iolog->pending->nr_samples < iolog->pending->max_samples' failed.
  fio: pid=40120, got signal=6

The assertion means that too many logs are recorded in the pending log
space which keeps the logs until next log space regrow by reglow_logs()
call. However, reglow_logs() is not called, and the pending log space
runs out.

The trigger commit modified iolog_delay() to call io_u_queued_complete()
so that the asynchronous I/Os can be completed during delays between
replayed I/Os. Before this commit, replayed I/Os were not completed
until all I/O units are consumed. So the free I/O unit list gets empty
periodically, then wait_for_completion() and regrow_logs() were called
periodically. After this commit, all I/O units are not consumed, so
wait_for_completion() and regrow_logs() are no longer called for long
duration. Hence the assertion failure.

To avoid the assertion, add the check for log regrow and reglow_logs()
call in iolog_delay().

Fixes: b85c01f7e9df ("iolog.c: fix inaccurate clat when replay trace")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 iolog.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iolog.c b/iolog.c
index f52a9a80..251e9d7f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -102,6 +102,8 @@ static void iolog_delay(struct thread_data *td, unsigned long delay)
 		ret = io_u_queued_complete(td, 0);
 		if (ret < 0)
 			td_verror(td, -ret, "io_u_queued_complete");
+		if (td->flags & TD_F_REGROW_LOGS)
+			regrow_logs(td);
 		if (utime_since_now(&ts) > delay)
 			break;
 	}
-- 
2.44.0

