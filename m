Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E5819F48D
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772542811; cv=none; b=aBkoYHRS3CAb7+kzYpREXLXWcDy3Nzg6IS2bpNekNIq1bEd4pmCDpKjGTpUVA62PTbFY/m9Ki0ZV+BaAqrBn20JfVOLgNVae2pB+aqCZ9FWOrl9Oo3vh2ZBLCxWIEtoj/5Emr+55RBjq1pn4v1vCVcc/1pa0KQ8WotvQaA+TpHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772542811; c=relaxed/simple;
	bh=rQ1zNbQN8YA1nkmjkrlZMiH2P647uXkhAyVpTI5L5Lo=;
	h=Subject:From:To:Date:Message-Id; b=Ukr7bktbQvNlArWeyd+tWKUi/U94p6PDNnADH9F9fPcI/UkSB6BM7u+QH4th+idIJXKdX26Nm5v6AV/TabqU0EGsl2Xkr3uU2u4If69vzYa5rY3Lnn4HOpvY7NmNbK5OTmduP2zjbb8rBpdNNkhiHbCtHYPzE5GGVSrqTnvAHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kVHvZtwG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kVHvZtwG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=XcclV56RBc+9ibT7Zwb/dJCwISNCGgiN0dvee8XGevw=; b=kVHvZtwGaYAFc7bB0TL6SqRQ2P
	ej8FukKf+mdkGCHuduITzZaKwXdYUAHniqv5VjxEgYrp9Pc/GW8Qv3YZgD+11FFqk8Ivj2B5PbaMi
	m+hm3qDjjVYDP0EiZtFifm5OHC7lsJjSSj9M/0Z/syMcDpRwix/76M1OqMfGnl/R2tzJEn7QX+9nD
	PJ+AFz7P1ksb3E8MBhMLHTu0MNvkUcqTAnfO2e6b/jpGVYajoI0uT9uGkiEXb+IS5oiKbNWryjUR+
	IcOGvyPCRnJq94BBI8uweYs9Li3rK0K1w0rkjkx7C5OPjup09ATQZz5sPkDY3W06yBPqQmDQ63/1L
	PCK6APuQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxPM4-0000000BWlf-3S8e
	for fio@vger.kernel.org;
	Tue, 03 Mar 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 76FAA1BC0192; Tue,  3 Mar 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue,  3 Mar 2026 06:00:01 -0700
Message-Id: <20260303130001.76FAA1BC0192@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a7554ee21d3f4a799969da2e54a66e7081c1571c:

  engines: posixaio: add support for DDIR_SYNCFS (2026-03-01 23:22:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ccf9f41fdacae34fbf8bf839406c4cc7d5070d49:

  Merge branch 'prof-use-after-free-fix' of https://github.com/jsemric/fio (2026-03-02 10:26:27 -0700)

----------------------------------------------------------------
Jakub Semrič (1):
      Fix use-after-free of idle_prof_common variable

Jens Axboe (1):
      Merge branch 'prof-use-after-free-fix' of https://github.com/jsemric/fio

 backend.c | 1 +
 stat.c    | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 9912a94c..6dd078c4 100644
--- a/backend.c
+++ b/backend.c
@@ -2833,6 +2833,7 @@ int fio_backend(struct sk_out *sk_out)
 		td->sem = NULL;
 	} end_for_each();
 
+	fio_idle_prof_cleanup();
 	free_disk_util();
 	if (cgroup_list) {
 		cgroup_kill(cgroup_list);
diff --git a/stat.c b/stat.c
index 0e4e482d..aea573f5 100644
--- a/stat.c
+++ b/stat.c
@@ -2776,8 +2776,6 @@ void __show_run_stats(void)
 		buf_output_free(out);
 	}
 
-	fio_idle_prof_cleanup();
-
 	log_info_flush();
 	free(runstats);
 
