Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBD17981
	for <fio@vger.kernel.org>; Wed,  8 Nov 2023 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dl96X+0p"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB81A1BF7
	for <fio@vger.kernel.org>; Wed,  8 Nov 2023 05:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fNwj1DRkL7TP1YNHmH+UxjgLM40jbNV/dGX6KY9MYUY=; b=Dl96X+0pt1OqMCdlTp/HHLsqf5
	xSDRQvUUTsp4cgwtMQuvHkq8O+22EiL8xt50jslmhU5XsHERwDg1U6dLZ3nOcv+GBqiqcIvapAOLq
	4+avMQ6t+735aMnDT+eiJaCkvBJrT7CpaM/ho/ISmDJ8xr1aenGBo3apL5utkqu/QtzC/POOC5MBy
	lqESWlz2xQYY6x307uDltQ0fkCsQNk++692jUGUceAFXB734eWWWFMUvic9ypgEmYM5NsJNSiQAlw
	mzf4kzP1SiAtCa07qOGo7Gn/sjNUarUtqLl+ofl/fBIdz7Axx4SaaYYivlBbwV+RxpeKXmgAPMIFd
	lefRi7RQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0iAG-0016h2-Bd
	for fio@vger.kernel.org; Wed, 08 Nov 2023 13:00:13 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9BA641BC0158; Wed,  8 Nov 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231108130001.9BA641BC0158@kernel.dk>
Date: Wed,  8 Nov 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 05fce19c7d2668adb38243636a1781c0f8fae523:

  docs: add warning to per_job_logs option (2023-11-06 13:46:30 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to afdde534004397ba1fb00ccc6f5906fa50dd667f:

  t/jobs/t0012.fio: make this job time_based (2023-11-07 12:22:40 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      t/jobs/t0012.fio: make this job time_based

 t/jobs/t0012.fio | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/t/jobs/t0012.fio b/t/jobs/t0012.fio
index d7123966..e01d2b01 100644
--- a/t/jobs/t0012.fio
+++ b/t/jobs/t0012.fio
@@ -14,6 +14,7 @@ flow_sleep=100
 thread
 log_avg_msec=1000
 write_iops_log=t0012.fio
+time_based
 
 [flow1]
 flow=1
