Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA01C8603
	for <fio@vger.kernel.org>; Mon,  9 Feb 2026 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770642014; cv=none; b=WuXpBbv9krJ8j1hdznalxjpl320cffYf54NfBil0Fw0HgSWHZ7gW6mPNiNv2OudYLAL0kzgxT4MZ4znoSBFFy6qEzBTBHJRp/jqPKvMhsTV0O98D1Nq9OwpwGwKXHdUNxIFol9crEBBNEjWMtygqhvUrNL1sIaoRB2LsL/tVlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770642014; c=relaxed/simple;
	bh=XUYv6pgUn7lyTFzxbB+L3baJS7ZRkqCiFQ6Ht3Rwhm0=;
	h=Subject:From:To:Date:Message-Id; b=lFNxw+I0yqI3j/z9uzCnwveiMQkRqDgYhJHN0J+XtF+w1PcoVCXPyvTKioFTFGb4haBUSt+4OXhKyktmLsc8YC4yrToFAT3pIBntwLA57CjvsXkUBWyT6bWRnsRgB+FkGBPgD+OI8wozs2okRJ7UScH5JOsAgTxgwNtSYJiOHyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J2BndXRI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J2BndXRI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gyEXe3CZUCK7frltyHHXdRgvPg/1MG5HcFOEjGHJ5V8=; b=J2BndXRIqy12BqyDo7UPiTTDNW
	Us1h6XerhNsL7KpmikuhhzaJqB+RbWxznPeQOHFxdUge8gDKkyl0STklhT6NO2BmSz9ahK+zoszD9
	8ZXsJMZNHEnzeJWGxzjm5Ss+WS1GscqOX/HrbSYDj7fuQBX2R9692SgPZE6+1dKV68jlhu75laEXI
	q01ACw4exXcry/jW/M77xiZ++t2/IRED2rKqaEWLo9pGMUQM9G8r7X7aEuGyKtq8KQk+5IJUaUlKX
	6aZTTRoyDcst7+0EuhEnB6dEobdeKEFiYJi/35SjvS+LviyUC3sTowgF3uWGjR6P3bpVyOK2b6ikt
	LNB0y3JA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpQs1-00000009VpD-0zTh
	for fio@vger.kernel.org;
	Mon, 09 Feb 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D2BEC1BC0145; Mon,  9 Feb 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Mon,  9 Feb 2026 06:00:01 -0700
Message-Id: <20260209130001.D2BEC1BC0145@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a8ab726842f4140dfcdb4240138f1abba9b54c05:

  Merge branch 'offload_fix' of https://github.com/tomas-winkler-sndk/fio (2026-02-05 13:14:38 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6783ccc569c8e427cb3cfe4e8b37e18fa0601d9f:

  options: ensure callback handlers handle NULL input (2026-02-08 08:39:27 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      parse: check for NULL input
      Revert "parse: check for NULL input"
      options: ensure callback handlers handle NULL input

 options.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index fe22df01..68189be7 100644
--- a/options.c
+++ b/options.c
@@ -266,6 +266,9 @@ static int str_fdp_pli_cb(void *data, const char *input)
 	char *str, *p, *id1;
 	int i = 0, ret = 0;
 
+	if (!input)
+		return 1;
+
 	p = str = strdup(input);
 	strip_blank_front(&str);
 	strip_blank_end(str);
@@ -603,6 +606,8 @@ static int str_replay_skip_cb(void *data, const char *input)
 
 	if (parse_dryrun())
 		return 0;
+	if (!input)
+		return 1;
 
 	p = str = strdup(input);
 
@@ -641,6 +646,8 @@ static int str_ignore_error_cb(void *data, const char *input)
 
 	if (parse_dryrun())
 		return 0;
+	if (!input)
+		return 1;
 
 	p = str = strdup(input);
 
@@ -884,6 +891,8 @@ static int str_cpus_allowed_cb(void *data, const char *input)
 
 	if (parse_dryrun())
 		return 0;
+	if (!input)
+		return 1;
 
 	return set_cpus_allowed(td, &td->o.cpumask, input);
 }
@@ -894,6 +903,8 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 
 	if (parse_dryrun())
 		return 0;
+	if (!input)
+		return 1;
 
 	return set_cpus_allowed(td, &td->o.verify_cpumask, input);
 }
@@ -905,6 +916,8 @@ static int str_log_cpus_allowed_cb(void *data, const char *input)
 
 	if (parse_dryrun())
 		return 0;
+	if (!input)
+		return 1;
 
 	return set_cpus_allowed(td, &td->o.log_gz_cpumask, input);
 }
@@ -949,6 +962,8 @@ static int str_numa_mpol_cb(void *data, char *input)
 
 	if (parse_dryrun())
 		return 0;
+	if (!input)
+		return 1;
 
 	nodelist = strchr(input, ':');
 	if (nodelist) {
@@ -1567,6 +1582,9 @@ static int str_filename_cb(void *data, const char *input)
 	struct thread_data *td = cb_data_to_td(data);
 	char *fname, *str, *p;
 
+	if (!input)
+		return 1;
+
 	p = str = strdup(input);
 
 	strip_blank_front(&str);
@@ -1689,6 +1707,9 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	struct thread_data *td = cb_data_to_td(data);
 	int ret;
 
+	if (!input)
+		return 1;
+
 	td->o.verify_fmt_sz = FIO_ARRAY_SIZE(td->o.verify_fmt);
 	ret = parse_and_fill_pattern_alloc(input, strlen(input),
 			&td->o.verify_pattern, fmt_desc, td->o.verify_fmt,
