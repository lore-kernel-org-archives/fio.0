Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DE737416E
	for <fio@vger.kernel.org>; Tue, 10 Mar 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773144009; cv=none; b=PNTHVSU+pmNOzKsP7BIpoAeYiC5wx8T+DedET+h29r3DBVfukJawJn2q6smuvNXFTAQOMq8GFvXn+pMidNOYKfa4h2P8FY6Z3cM94vtJAAY6cnmgW/uqoYmnZWS5kb3OrAAuSc0vE6TgY0o8pAOzgCInnP9kDdEkLj4nlwSVtao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773144009; c=relaxed/simple;
	bh=AuHkI9opKSjjAPK2mlNtY5J1+ikqE5N5hT6uDDiJax0=;
	h=Subject:From:To:Date:Message-Id; b=r0iL3lHvk5YlvZgW3pICz4bYJZoyJA1u2h+7aVXycS+V17CwcjYR8ZrY1qP9BpByUMKk8IsvpxLUwQbCNdtav68n8R/EpvWU5XFswDx71A7/MZVrsVIm2TyCEv7yhZwIuZUy7qVrwybTcu395Zp9sEKWrnMiqhBOfCt1pGs6rjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KRckNfz2; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KRckNfz2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CYLswgrrL+1ITO98l9zZgFFG1jP3zT4P7f2X5LEx0A0=; b=KRckNfz2pULRpvcP064Kmmrmax
	HUHCXWFjPj9NBPPfT69RT1WRZfoEgByYAO4nd9J5hyRb/M9N/TRR5N+aPnYdr6bFE9CCOG7ld4uI6
	8JUxKW++uZJyTD/7B3nRJrSvOlGhli5PF5hLupUqk8MVH0LEAsbiUR370Kh2SVglB/umCiJGMTfzW
	0Un5XbEqvg4JxoDPYWd976ru0ejyrCkgmnRTD0R+OWgmWq5w6x6Gudf+q1mxWSTKC+Yw+EoF8jVFG
	Zadvsqa9NEcg0gmfQ56NlZKMzFPUIdXEpht7EyNhfCsirb3T65AdWEMU6gs7lx79G0RxFaBHtgwkP
	wUbgxFIQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzvkq-00000007mVH-3S8o
	for fio@vger.kernel.org;
	Tue, 10 Mar 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C4BB01BC0199; Tue, 10 Mar 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 10 Mar 2026 06:00:01 -0600
Message-Id: <20260310120001.C4BB01BC0199@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5d15185ae6f0c46822c0e360c5bd75042269a5eb:

  t/zbd: avoid test case 71 failure with write_zone_remainder option (2026-03-03 19:11:54 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fa23c09bfefb2b9c960d179ad67d356fbc29179f:

  Merge branch 'push-lnvrzuqpnylp' of https://github.com/msuozzo/fio (2026-03-09 20:02:12 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'push-lnvrzuqpnylp' of https://github.com/msuozzo/fio

Matthew Suozzo (1):
      options: fix heap-use-after-free in ioengine_so_path

 options.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 8d9e3054..a4cd1a77 100644
--- a/options.c
+++ b/options.c
@@ -1924,7 +1924,9 @@ static int str_ioengine_external_cb(void *data, const char *str)
 		return 1;
 	}
 
-	td->o.ioengine_so_path = p;
+	if (td->o.ioengine_so_path)
+		free(td->o.ioengine_so_path);
+	td->o.ioengine_so_path = strdup(p);
 	return 0;
 }
 
@@ -6121,6 +6123,9 @@ void fio_options_mem_dupe(struct thread_data *td)
 {
 	options_mem_dupe(fio_options, &td->o);
 
+	if (td->o.ioengine_so_path)
+		td->o.ioengine_so_path = strdup(td->o.ioengine_so_path);
+
 	if (td->eo && td->io_ops) {
 		void *oldeo = td->eo;
 
@@ -6230,6 +6235,11 @@ void del_opt_posval(const char *optname, const char *ival)
 void fio_options_free(struct thread_data *td)
 {
 	options_free(fio_options, &td->o);
+	if (td->o.ioengine_so_path) {
+		free(td->o.ioengine_so_path);
+		td->o.ioengine_so_path = NULL;
+	}
+
 	if (td->eo && td->io_ops && td->io_ops->options) {
 		options_free(td->io_ops->options, td->eo);
 		free(td->eo);
