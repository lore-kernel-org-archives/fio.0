Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FC01EB25
	for <fio@vger.kernel.org>; Wed, 17 Jan 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705496413; cv=none; b=iWlRmxWyHVfXioBRfFhRBIn6znBnZ28GULDicfOye3j8DqsSARelO64pUMDOQhVl459DPXBz806tGyN4dJd6G0/5jzUYW0fpeL+dqA4+vOaLOlTrTiA0AI1B1ufztENEy/FZfVUFPtNNsxs8gvYulfhTAavyjPwttdqZWkjFCq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705496413; c=relaxed/simple;
	bh=wn65ckSmw/DtEF5OTaxbqW684i3Y1IV6x2eXMRXu8m4=;
	h=DKIM-Signature:Received:Received:Subject:From:To:X-Mailer:
	 Message-Id:Date; b=owEOHrgXTSSlLg+vg3IpltzuTsCbjPjxdaXj2OZS/sQQUcrbx5y95yctCo4bxEXaSsNp7PXgV1eM5MaIMsYx47sALo8Nvz8I+9OgTzy7h9cArWLMC4Tr9YLQdURPuF8cVv5VH0Bkq6xJMwGDpkkHRRvMZWUsNNsZQN6Lzjeqq1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cw2uc0Y3; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cw2uc0Y3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=1zv7b4ANT5WhER9va6zy/xhKT6ogiPvmlWiWlAshIUY=; b=cw2uc0Y3ttuDXUpMlYflirOWgw
	iJJ/1HiSuhugRPv9FcgdfG9YFdYUiJmHqMtg28TvdjI8AS5KKqZlazJiZlSSlNKTMKkblJWZVq+vR
	l8MOKjAhPu+o0qiuYvkAGjtqIDd6Z8lyZtA3lDY3wLvNZNuDPiOPMDRY3TvzJ7imRiXDsVzOgLFBM
	CSuBybES1S2uYvTRak5r9MQx+Mp9FEJRlkfIN8WM3F5XwYPcVaeIMDynx4n/pXMNdC65+sIZsfgoa
	nZRQEit7KsIQIst1Acy3w7bdEyBNygyvO69tEj4Rjo9t/Soc6DiIF94BtMxnsO4AV1NHetU/WP4HW
	IBJ8bVQQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rQ5WY-00000000SUf-2UiP
	for fio@vger.kernel.org;
	Wed, 17 Jan 2024 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 565B41BC0123; Wed, 17 Jan 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240117130001.565B41BC0123@kernel.dk>
Date: Wed, 17 Jan 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 06c40418f97811092c0aece1760487400bcdd506:

  t/strided: check_result() has no return value (2023-12-28 22:19:44 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9f9340cc3a15bca2aa6e883bd5be3d0c9471f573:

  Merge branch 'group_reporting_indentation' of https://github.com/0mp/fio (2024-01-16 09:03:35 -0500)

----------------------------------------------------------------
Mateusz Piotrowski (1):
      doc: group_reporting: Fix indentation and syntax

Vincent Fu (1):
      Merge branch 'group_reporting_indentation' of https://github.com/0mp/fio

 HOWTO.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 847c0356..d0ba8021 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3984,12 +3984,12 @@ Measurements and reporting
 	same reporting group, unless if separated by a :option:`stonewall`, or by
 	using :option:`new_group`.
 
-    NOTE: When :option: `group_reporting` is used along with `json` output,
-    there are certain per-job properties which can be different between jobs
-    but do not have a natural group-level equivalent. Examples include
-    `kb_base`, `unit_base`, `sig_figs`, `thread_number`, `pid`, and
-    `job_start`. For these properties, the values for the first job are
-    recorded for the group.
+	NOTE: When :option:`group_reporting` is used along with `json` output,
+	there are certain per-job properties which can be different between jobs
+	but do not have a natural group-level equivalent. Examples include
+	`kb_base`, `unit_base`, `sig_figs`, `thread_number`, `pid`, and
+	`job_start`. For these properties, the values for the first job are
+	recorded for the group.
 
 .. option:: new_group
 
