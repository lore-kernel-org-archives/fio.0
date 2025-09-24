Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C841F3002C2
	for <fio@vger.kernel.org>; Wed, 24 Sep 2025 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758715227; cv=none; b=mZqutE6uX6mB+GEdUmpEghCp0dO3DdPbbJpqowtWALxqhT1svMfKr0kxiRmYMcT2Gk02xeylBJjv3pucMe53zBcu5jHaOkAisZZ70OfS8AYGJDE0t8piaurladgwQ8Eb0CHGBBPj6k4tdtFQCyEPF2vR4WhZQF7Y0sOfVPWtuuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758715227; c=relaxed/simple;
	bh=NLFy4j1ReeW21KXkEloOh+xf+oBLjx2nIikzw6EKoIk=;
	h=Subject:From:To:Message-Id:Date; b=BdvGCKBLqrqzPEmCfyVPkh20W36rEY6JkYCUDMxw09t3tO7ThVjeNEShhr9mxjiWtw4Lo4FUZ1Gh384/f9vvVOHVBSQAVILdnIDJX73HSyEBF3YYyUxH4KttvrAIyWt/RdENWMRICVav7L953kuyIb009vqwHUOFghw/uY+gpMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h2hzyEny; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h2hzyEny"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=J/ug5CWrZYOqs8ZvigTBs59tfq7Ppk5WFrISeqPvlsQ=; b=h2hzyEnyWpQ1AtDYcR9KwxsEZB
	QYvTWSUJ6DVabJqAgbFSi2Y3uOpm0KFBz4rgATVwDWCgqZdLMlQoIoZ0Pirs0xB5if7oI5sSUHkG2
	399LMg9jnXZfBiNam1n7sPhKaraFQUbcKLQNmHTNfAO2u6VK7F6dLOU5bJaPjxC0lJromvZP31FFL
	gCwvUVtNqsEwiu6JrsPuyJ7tUd0PXPLSF4E34UQ1Agr8R6htimVALnXuqEM/KqtY7Xtfj4Y0tvu/M
	FYZACITIwp5q2oLErW5DQWE1q7GWjsCHxyjT58Qpslep/QR55zDx7/OZeodPAovE3i0K26Sr2I1Bu
	UB4i/KdQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1OAV-0000000EpVk-1fE9
	for fio@vger.kernel.org;
	Wed, 24 Sep 2025 12:00:19 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CBD5D1BC015E; Wed, 24 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250924120001.CBD5D1BC015E@kernel.dk>
Date: Wed, 24 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f2c1d8f9d0c80d9e882a74c1e74fba7dfe1cd9f1:

  Merge branch 'sprandom-log-fix' of https://github.com/tomas-winkler-sndk/fio (2025-09-18 11:42:56 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a39dfaffdb8a6c2080eec0dc7fb1ee532d54025:

  options: check for NULL input string and fail (2025-09-23 11:50:46 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      options: check for NULL input string and fail

 options.c | 3 +++
 1 file changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 337a3a52..77b42cdb 100644
--- a/options.c
+++ b/options.c
@@ -1616,6 +1616,9 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 	struct thread_data *td = cb_data_to_td(data);
 	int ret;
 
+	if (!input)
+		return 1;
+
 	/* FIXME: for now buffer pattern does not support formats */
 	ret = parse_and_fill_pattern_alloc(input, strlen(input),
 				&td->o.buffer_pattern, NULL, NULL, NULL);
