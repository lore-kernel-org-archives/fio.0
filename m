Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA9F3431F8
	for <fio@vger.kernel.org>; Sat, 31 Jan 2026 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769864410; cv=none; b=t5Wj9AG7UXPe0dH++99GDMdlNTlNnJ58mKjls1W4gm/yGejvJgsg4O+IaFQqSBzjHnHc3Toie9opeW2J1+XXFr7Ui/FoxM+ZJhoO6tOR0BzBm4zc9HbvZCP3Pl/eGxN/qdvaE6Hm5Rcg2NpktQzNviIGzpJMvxUTdjFd6qCzl60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769864410; c=relaxed/simple;
	bh=FkDmMU9CVffaUgE6oi98seH1nlo5Fo6UOSSE74rxMgQ=;
	h=Subject:From:To:Date:Message-Id; b=BEYINHZYetHluWEMbbFwbNs8DECoDeOG06pVOSl2FeHT3p1d6aNE449VbfW88sNEXLbvWjGiSKf1v1MpjAr9saW0aWsqZV4lb9+n226wldb9aCusZmwYlbfC3CSa4xQQydXeVjAdY0QhO9Zc290cU++ojKMJeiDhNHRaK1liBw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oaD/noZE; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oaD/noZE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=G/rusDU8RFHLjRSpLckX0UNj75/pThX8IL7gWRozUHY=; b=oaD/noZE3pQA2mUYEi/XHFfDsj
	pOgeApoN5ty3lhBksvp9tISuSIb8xdnYxl2uYEy+XZGmeJsdqPZQ5LAfM9HmtqOmOn+ZoVEi2EYw6
	hfuqagjXZUlpLqRIMmWgXVwt9qNVopa+edzVnha7g5odQi+Ldsg7ZeehCVJWp2vQkLkKJgmdqR+Ag
	wM8kWun3VIPVnPcASQ1kPoXdp/KhfpRY1R0QLjzUNXqNRjJ1APmVRWhoK7oo7ncf0/z06cMwSVtO3
	GPWKQLkiEypH1sviTXbgZBC1Q2pTZB2qgJva4TKGHa7ugQSdNxinyfO/12qZBhQ796QJ+bmiug5C+
	a2kaGOdg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmAa4-0000000CoqL-2WyV
	for fio@vger.kernel.org;
	Sat, 31 Jan 2026 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A39751BC0144; Sat, 31 Jan 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 31 Jan 2026 06:00:01 -0700
Message-Id: <20260131130001.A39751BC0144@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2d953029b289b778e18c9418f7d596bd12232215:

  Merge branch 'job-process-comm' of https://github.com/robertbaldyga/fio (2026-01-28 05:22:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a50d7ce532510ab467d307c1ee010386e20ee652:

  Merge branch 'fix-fork-memleak' of https://github.com/malikoyv/fio (2026-01-30 08:03:56 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-fork-memleak' of https://github.com/malikoyv/fio

Yehor Malikov (1):
      backend: remove premature free of td->eo in parent process

 backend.c | 3 ---
 1 file changed, 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 3a000464..568f306c 100644
--- a/backend.c
+++ b/backend.c
@@ -2610,9 +2610,7 @@ reap:
 							strerror(ret));
 			} else {
 				pid_t pid;
-				void *eo;
 				dprint(FD_PROCESS, "will fork\n");
-				eo = td->eo;
 				read_barrier();
 				pid = fork();
 				if (!pid) {
@@ -2625,7 +2623,6 @@ reap:
 					_exit(ret);
 				} else if (__td_index == fio_debug_jobno)
 					*fio_debug_jobp = pid;
-				free(eo);
 				free(fd);
 				fd = NULL;
 			}
