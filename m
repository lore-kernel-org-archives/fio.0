Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E67A3DE420
	for <fio@vger.kernel.org>; Sat, 16 May 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932812; cv=none; b=Bye9ET9NHFqOAP3W6d3ZLZ6VRXb5ThCf7XgCzl2Wra/ty9vkeAXxLFIkhb2YTL68SLf+StuAho5BjGOO8fjVSxgroPukvSYmMlf5+WmmY3Rjz9UM7kymALtqIiphf7Lr7F1IxuSFonq1vK3eG/gBJeTyivJlRA34q0eqrJTPqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932812; c=relaxed/simple;
	bh=m2quGTXwfl6uRHmP9F19Tb+dj39beOZnG1faYZ6lzr0=;
	h=Subject:From:To:Date:Message-Id; b=F0bR0rHWxCbAm1iaFktJkJxY81NiQU8J92IqEHuKPPKKr8nMN+h24U+zSS+2Bvk02rHXSP9cbT0zTbOEohz9h9Y83Bvv7nTTZWoDvE8rS3ZENj455FDWXaS6g49kUqQIEjy5SqzCuWbUeBkyXeIPtb143dCTUsDpL1yW2zQWpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mClmnB5J; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mClmnB5J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ndxJ5WVmdOqzZnFlzvWHhAduGBdPzpo7xS1yAJjt5PA=; b=mClmnB5JyseZydUcuslO1vNMqD
	LfzIrMchjNpYxtx3O2NB7d1VoehbUI/H7/w7IqVTuF18sz+HQfo8jBW+8fm8cMpn4ra+uKx8idbs9
	RRnnxRWmdDycRGG38kWewZUcFOv9KgxXR8eVfY+g8Dvt9Lrtq/ZVuZ19TX6ejDZcblBPUqpFKJVIk
	D9n5DQzobV38wU6TqKdUg/pGL89V4Wx/60hYXDrVsmK0bAQ41OLQhEkkdXXlUrttG4CtyviQKMtEE
	tT5PdmkxuXcb+j/sizFrP5GCLVzQPVgMYk+B8q88KPZhYPJQ/zSa33h3sc0mI58/k55tmlSWPbtH0
	aTOcrQQA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wODgb-00000002uTJ-2tCS
	for fio@vger.kernel.org;
	Sat, 16 May 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E36331BC017C; Sat, 16 May 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 16 May 2026 06:00:01 -0600
Message-Id: <20260516120001.E36331BC017C@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 3ea531dfc54aaccb6a5846f37e6cfefedd7ff60e:

  Merge branch 't_io_uring_htlb' of https://github.com/ming1/fio (2026-05-12 10:21:09 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4de5b267a716a9b7b71b212e0b948743f70c4d54:

  Merge branch 'pr-free-td-init' of https://github.com/malikoyv/fio (2026-05-15 08:03:55 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'pr-free-td-init' of https://github.com/malikoyv/fio

Yehor Malikov (1):
      init: fix memory leaks reported by LeakSanitizer

 init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index cce79e84..d1bf6bfb 100644
--- a/init.c
+++ b/init.c
@@ -340,6 +340,14 @@ static void free_shm(void)
 		flow_exit();
 		fio_debug_jobp = NULL;
 		fio_warned = NULL;
+
+		for_each_td(td) {
+			if (td->io_ops)
+				free_ioengine(td);
+			free(td->files);
+			td->files = NULL;
+		} end_for_each();
+
 		free_threads_shm();
 	}
 
