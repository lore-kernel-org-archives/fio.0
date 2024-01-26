Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6A1DDDA
	for <fio@vger.kernel.org>; Fri, 26 Jan 2024 18:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292846; cv=none; b=DYMpN44RqeLli3QnZBkdfTaXnQdyjcjM+J8Zc2lAnI3m/jOzeXuw6/91jOnMOOoOJRFkR/iPlXQjd9PxgLP/EjQdFjwmQDX0WdNHh0I61CJ6WZIu5p/TtdRaQ1mSkMuQXKA3efUwa6l4pGVTbf0MJHPTSoXRwsceybCRDPeaRgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292846; c=relaxed/simple;
	bh=t5ZwVdPgNrJXZw4SkOw6h3wqUNnMXpDei35id/mN5g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvoAdFfcNh+vW7PPC7j1Xm45BDAjJc+bDGiKYJJ/ZhbjFNA7+0FKO6yrxAZHYofhHpKqkSMQc9WzKe0zRPtTcEDgvibpXN/1bL8S+Ziw9cZo59T1sDKRlSgmmlKrAOsQYNWIQO7SHmJzukuhLOGBWdEKG4jbhC/yX3uNMTtw7LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFBkCeUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFBkCeUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245FEC433C7;
	Fri, 26 Jan 2024 18:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706292845;
	bh=t5ZwVdPgNrJXZw4SkOw6h3wqUNnMXpDei35id/mN5g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFBkCeUgrc463ZhKkhvoSag1C2DXOH3VkyR77XzQIW87O/4BklmBrOPSTVEQVtoM/
	 simbc4szb9XpZMhyV2uaGGEiM6MAfpQiZ6BrN9LsXn6B/YH8Y3MdOeGMMwBnxJ4fjf
	 4FSH8c4gvmnSNOiefUMJZ0U0QKdkLUZJvglb+lg10rYLtgO8P41EuxqXVbq2Lh++7v
	 ZkVTDBKp9zSAQw92/FHuCiloP/knPQiNRA3zBu3sn5qXJsvzKO1Y8ffoKUKF+joNa9
	 cRaG0GHdouaa8dWXr7NrFtEWKhZkfUgsnU685KdlKwK+YZI79qZ6siLEc7y0Xsyc90
	 OKZzl2cNdAFWg==
From: Niklas Cassel <cassel@kernel.org>
To: axboe@kernel.dk,
	vincentfu@gmail.com
Cc: fio@vger.kernel.org,
	dlemoal@kernel.org,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 2/2] examples: cmdprio_bssplit: add CDL example
Date: Fri, 26 Jan 2024 19:13:53 +0100
Message-ID: <20240126181353.4151771-2-cassel@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240126181353.4151771-1-cassel@kernel.org>
References: <20240126181353.4151771-1-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an example of how to use cmdprio_bssplit with Command Duration Limits.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 examples/cmdprio-bssplit.fio | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
index 05f0d0b2..ee202d74 100644
--- a/examples/cmdprio-bssplit.fio
+++ b/examples/cmdprio-bssplit.fio
@@ -42,3 +42,38 @@ prioclass=2
 prio=7
 bssplit=64k/40:1024k/60,1024k/100
 cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
+
+; Example of how to use cmdprio_bssplit with Command Duration Limits (CDL)
+; using I/O priority hints. The drive has to support CDL, and CDL has to be
+; enabled in sysfs, otherwise the hints will not be sent down to the drive.
+[cmdprio-hints]
+; 40% of the I/Os are 1MB reads and 60% of the I/Os are 2MB reads.
+;
+; 10% of the 1MB reads are executed with prio class 2 (Best Effort),
+; prio level 0, and prio hint 1. Prio hint 1 means CDL descriptor 1.
+; Since 40% of read I/Os are 1MB, and 10% of the 1MB I/Os use CDL desc 1,
+; this means that 4% of all the issued I/O will use this configuration.
+;
+; 30% of the 1MB reads are executed with prio class 2 (Best Effort),
+; prio level 0, and prio hint 2. Prio hint 2 means CDL descriptor 2.
+; Since 40% of read I/Os are 1MB, and 30% of the 1MB I/Os use CDL desc 2,
+; this means that 12% of all the issued I/O will use this configuration.
+;
+; 60% of the 1MB reads are executed with prio class 2 (Best Effort),
+; prio level 0, and prio hint 0. Prio hint 0 means no hint.
+; Since 40% of read I/Os are 1MB, and 60% of the 1MB I/Os use no hint,
+; this means that 24% of all the issued I/O will use this configuration.
+;
+; 10% of the 2MB reads are executed with prio class 2 (Best Effort),
+; prio level 0, and prio hint 3. Prio hint 3 means CDL descriptor 3.
+; Since 60% of read I/Os are 2MB, and 10% of the 2MB I/Os use CDL desc 3,
+; this means that 6% of all the issued I/O will use this configuration.
+;
+; 90% of the 2MB reads are executed with prio class 2 (Best Effort),
+; prio level 0, and prio hint 0. Prio hint 0 means no hint.
+; Since 60% of read I/Os are 2MB, and 90% of the 2MB I/Os use no hint,
+; this means that 54% of all the issued I/O will use this configuration.
+stonewall
+rw=randread
+bssplit=1M/40:2M/60
+cmdprio_bssplit=1M/10/2/0/1:1M/30/2/0/2:1M/60/2/0/0:2M/10/2/0/3:2M/90/2/0/0
-- 
2.43.0

