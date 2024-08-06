Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FFF166F2F
	for <fio@vger.kernel.org>; Tue,  6 Aug 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722945617; cv=none; b=tNAie56OFcN3UkMZeVzG5V9Hm5VoAjCJGVXO4kgucvUmTyj/siCeOw4tj7G0R3pEtjLeCGTnENGg+V5anbUPXK7Gk5lzZDO1Uwqm2n/4OHzXl2FnGyGenBZVkkB/xTj1cmzTYIZpU8SlBfxNgzxx0tbuP+XR9fL33Az71pEgQFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722945617; c=relaxed/simple;
	bh=fzWC3AXL6Kt9R+pjQ46Xyy7L6qa0FEFJashX0jtoxmA=;
	h=Subject:From:To:Message-Id:Date; b=MU3llZKg7a91zZuJ6HM3RcmotNLcCPlthlWyYUWIxG0V5DcSRkSV+oOWWUVnGwEqj/eE9xXvg3TlKVA3fjSH1EsVwtmsDl0ZiYYy+7xd4HnGVGHJ4tn7yBY2yEbxCFOG6x2qTcZTz4wIZR/LvaNKE8kYgNCMOpZyIypfbIEp7Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jxsELk38; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxsELk38"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+47otvbGUXbLB4FGQhtbIQKPXCsdvTXIXso8wH7cyLs=; b=jxsELk38PbJqC7KwN84OY6mbwS
	QpOu087tOXFcKjT8SV52MybqWYbhhHNKfF62rxSkeMld6KJv8g0lOjq+Uv6/V9bTlp+l7RmtYwsJh
	IHdDtmti6rzgQYU5kzqDGgKB2BX+e/WMRzJGgITQKznzkNzEDuCizE++RMcYk+YTO7gNK2jP16CQF
	xWDMlgynS1HQze2JsP5dPGnBNXgr6gwCR6dp6JH9hbKXF2wmQYdqM665raWrmg2DIxSt3iqMCQ4EZ
	Ls7vZYcCRBK9Iy7HbY2uWEBIHi5kdG7vKCLm2S4lsmz6a+FzCEbqvAIdbb5NsrAdB8KdXUMOrMgfI
	tmZH3kmg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbIrH-00000005fTF-1jTl
	for fio@vger.kernel.org;
	Tue, 06 Aug 2024 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B86ED1BC0178; Tue,  6 Aug 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240806120001.B86ED1BC0178@kernel.dk>
Date: Tue,  6 Aug 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 40176e3206288e36f01baea86b15d7ff450c3e00:

  Merge branch 'qnx-phys-mem' of https://github.com/mvf/fio (2024-07-26 07:56:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8ac0eec77e9c25a054ff1fbff243ffdffcd6e858:

  nvme/streams: avoid allocating too large a buffer (2024-08-05 18:15:24 +0000)

----------------------------------------------------------------
Vincent Fu (1):
      nvme/streams: avoid allocating too large a buffer

 dataplacement.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/dataplacement.c b/dataplacement.c
index 399659be..fc45cd27 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -52,7 +52,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
 			log_err("fio: stream IDs must be provided for dataplacement=streams\n");
 			return -EINVAL;
 		}
-		ruhs = scalloc(1, sizeof(*ruhs) + FIO_MAX_DP_IDS * sizeof(*ruhs->plis));
+		ruhs = scalloc(1, sizeof(*ruhs) + td->o.dp_nr_ids * sizeof(*ruhs->plis));
 		if (!ruhs)
 			return -ENOMEM;
 
