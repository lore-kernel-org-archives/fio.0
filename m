Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253761DDDA
	for <fio@vger.kernel.org>; Fri, 26 Jan 2024 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292844; cv=none; b=Zb+ftCjsTBK3Qad5p4AhyVe2TFdGaiFcU0ktKNl+TkB6CtnHx14vPjAitPf4KdUd9x7ikNDJ8blK9lUwsU+w5U6QMduBFhr4AaUeJk5r/W4DDuKMFyQuNqaDOCdi9shkZIzNXq0cEpWyecgJGBwcFhTkO/EPJPDoGqoDzDJDors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292844; c=relaxed/simple;
	bh=d09qFPfYYTDaJkTV7ml/q7FP3gZ0Kme/ru8kI9CCBNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DpY2S+V4vCsS+SQF17M0vJFdpyuSYwCmEaxcK49Ih/CvrAGiPJRBm0JvBmrUVSVjRgAVw/jSMPonOhgk8nQaIB2gVVA8dq0qWAdvsZvU4lLxbnyJrzwLxh91nqWDZdrufN/dTXgof+IPQeNQWkMDLPVeEC9+WlTJvlMXOSYucns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZgqml2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZgqml2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E25C433F1;
	Fri, 26 Jan 2024 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706292843;
	bh=d09qFPfYYTDaJkTV7ml/q7FP3gZ0Kme/ru8kI9CCBNw=;
	h=From:To:Cc:Subject:Date:From;
	b=aZgqml2eqL02S5urYn09v8owbUMwbDD9XqiOvcNVIOlgoWJyi3YHwlPKm6nm/3A0a
	 2kcaWRBDSevXgxbbImGFErUviiaG9z+1AByTwKX59HB1tKwrPVMLq5iC4/G+6Oefum
	 CK0c9PcrGI3K235VspDWlHtPVN0Xkfo0FDDnXD8UKEAM5xrJvb4Ric6NiVNLR01UX0
	 SDlvTwMz4TJAG7GOIUJXE9WlKmmynaiPa/3gkBA7LCJNo0Azwm9AiuZwcKqafh7MRH
	 K/ET+185V/dq7Qvz6JXaWarwFFTbeD7Q3BCMD9bc6WSrc8tLI6SnK53YfhYBwd35vx
	 GEE9fDoew9KvQ==
From: Niklas Cassel <cassel@kernel.org>
To: axboe@kernel.dk,
	vincentfu@gmail.com
Cc: fio@vger.kernel.org,
	dlemoal@kernel.org,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 1/2] examples: cmdprio_bssplit: s,IO,I/O,
Date: Fri, 26 Jan 2024 19:13:52 +0100
Message-ID: <20240126181353.4151771-1-cassel@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace IO with I/O.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 examples/cmdprio-bssplit.fio | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
index f3b2fac0..05f0d0b2 100644
--- a/examples/cmdprio-bssplit.fio
+++ b/examples/cmdprio-bssplit.fio
@@ -12,9 +12,9 @@ iodepth=16
 ; use the same prio class and prio level defined by the cmdprio_class
 ; and cmdprio options.
 [cmdprio]
-; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 40% of read I/Os are 64kB and 60% are 1MB. 100% of writes are 1MB.
 ; 100% of the 64kB reads are executed with prio class 1 and prio level 0.
-; All other IOs are executed without a priority set.
+; All other I/Os are executed without a priority set.
 bssplit=64k/40:1024k/60,1024k/100
 cmdprio_bssplit=64k/100:1024k/0,1024k/0
 cmdprio_class=1
@@ -23,20 +23,20 @@ cmdprio=0
 ; Advanced cmdprio_bssplit format. Each non-zero percentage entry can
 ; use a different prio class and prio level (appended to each entry).
 [cmdprio-adv]
-; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 40% of read I/Os are 64kB and 60% are 1MB. 100% of writes are 1MB.
 ; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
 ; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
-; All other IOs are executed without a priority set.
+; All other I/Os are executed without a priority set.
 stonewall
 bssplit=64k/40:1024k/60,1024k/100
 cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
 
 ; Identical to the previous example, but with a default priority defined.
 [cmdprio-adv-def]
-; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 40% of read I/Os are 64kB and 60% are 1MB. 100% of writes are 1MB.
 ; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
 ; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
-; All other IOs are executed with prio class 2 and prio level 7.
+; All other I/Os are executed with prio class 2 and prio level 7.
 stonewall
 prioclass=2
 prio=7
-- 
2.43.0

