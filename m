Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4612E6A
	for <fio@vger.kernel.org>; Sat,  8 Jun 2024 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717848021; cv=none; b=LqewHN0K6yCLbEXs+6NCgikuGHjBKgpKd03a2Bh17Fj/Aosij+3d+JrM5OUW6YrX5bZZGIAy8Ny0b026Hq70kuuXiRMh3788ThUIdMKD3UKmA5xkLVe15psu3JYpz0IUGG75yYZNqSp4WUdxESQCUuYWNZrsLvlrPdU8n2XgqwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717848021; c=relaxed/simple;
	bh=Z22qNTGMBmbbkkblbVRxYgYrflBNrp357q2tbrImax4=;
	h=Subject:From:To:Message-Id:Date; b=WlCNfgjltsQB8QpG7pOLgZ1JbgCxNUBxnQqEKrTkQDFyZf1kITLU8YQOULjrUxI4JzxOHLStQLXo5OfVUwahS/dfUWwtoqPDrv9/zzTdDhFyDd2pnV60d4B9JJjx1WfcLVFHyHNo3BWDCxqd5SLY2FkXQ2RFN39J0kpeVep7RkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jdQs9KhF; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jdQs9KhF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=MmbjDk7K3BId232DqOmseUUL0ph26GxzXWxUNVgGfDI=; b=jdQs9KhFfKucd7tzlW8oToM3F8
	dSAZmCulmklW59QJkfOcKos1rmt3ydcvjdT19u4mqwK/cqVQPUBSHALTSkEbAB8+zhjj9XjUi1Ai+
	MYz12bSnyDGUxB0qYgbLRhF/NpvZPflDJRGXmMCXjIoqaRhKs7u21g3kWLb7rzI1ADd0nc6Kk6Tgm
	oZMhatDzrUFg2JOf7NVYvnCTP9GfVhAVg+FV9ndkLchiAxWKR14JdafcmiOJ0UfTQmxpGOlIxC3YT
	OYvrKqwquTDiBFNJHaX6tX6W3LGw4nP3jU9F64jQdoAl3yVlLGZyPwwwZ/2rEDy4dP5eraNbgqb13
	w03ITC+A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFujp-000000004nj-08M1
	for fio@vger.kernel.org;
	Sat, 08 Jun 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5D9601BC014C; Sat,  8 Jun 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240608120001.5D9601BC014C@kernel.dk>
Date: Sat,  8 Jun 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit eb7fe4550ff2a569d0d8c71de16a1ea1e1aaf0a5:

  Revert "smalloc: smalloc() already clears memory, scalloc() need not do it again" (2024-06-06 14:03:47 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fbf954c96bb4089b3097adde723216a4668f854b:

  engines/io_uring: eliminate FDP memory corruption risk (2024-06-07 09:45:02 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      engines/io_uring: eliminate FDP memory corruption risk

 engines/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index cf8cf289..7e083010 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1545,6 +1545,8 @@ static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
 		goto free;
 
 	fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
+	if (fruhs_info->nr_ruhs > FDP_MAX_RUHS)
+		fruhs_info->nr_ruhs = FDP_MAX_RUHS;
 	for (i = 0; i < fruhs_info->nr_ruhs; i++)
 		fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);
 free:
