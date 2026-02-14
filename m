Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DC630E0EF
	for <fio@vger.kernel.org>; Sat, 14 Feb 2026 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771074011; cv=none; b=m/Ouc9tKOjD0+9+8dvDvK8ivpefcx3oHwGjAsCLGj7OZtJ4ABWYsgNrUDYmsnskqlPdeBPJDnq3lD+xuccRl7HK6SasB0owG+LW/Vbe44xvVQZQ5LDcjhzQSR9IUBP8XwsmOhvZD7PZ5mIgVOyaqLukEwfjDyJmPcqCr6xHAGyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771074011; c=relaxed/simple;
	bh=t+RIaJdtje6Kb+vE4se2+K8LsFcEvORh5EpYQhg+2Tc=;
	h=Subject:From:To:Date:Message-Id; b=XeSNmjT3w5o6sQ2k3thYHtPZSJG2MGEeQnDTyJUuk424/a1bw7wWv0wUmUS/dtXj/2ffo3kS24L9/N5IzS+C6hN0iwjKKsAQWijUkIYWeN4fJOXTsZc2Lvh64Iw5CRh2lkfriLNKhOlXcao75dw0tiwB4mTXyFJvmneiu9dV6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M4MHpUwj; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M4MHpUwj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=h2gMmK0SKQNCAGBk5OrjQ8cLCVm2FYCX1YkF25IXRIY=; b=M4MHpUwjKxD5Wriiklwi3z101H
	vvi98nH1aGDcHhXtx5VFoP3WUbN2B8tLkqbSXlMMj4gupC1L4bo+BewL7Ft1KKrPRJG+3e2O4Hj2P
	aGhVKPEUlA11fS15MB13+PH3YSLq5ckIv3SmutsZOoD14KwMiUXRvzuX7oyAJ4Aoufdl9S5H9sYN7
	zWbMao3Yu0u6Qtr28nSVYhR9VDSxQeWaTjLq5MeBPjhwhIU//1Y3RhRuRAzVpxb54NuT9OMrJwFLc
	HnywgfGM6U5aBONX+JcQmwnSG9DVCJL0qgHLUI+ntZFmGSv9JY+LCNoxEiM+a2lsUXYQz8dkx/pjs
	hSfFHyGg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vrFFk-0000000D848-3zJN
	for fio@vger.kernel.org;
	Sat, 14 Feb 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 70CE91BC016B; Sat, 14 Feb 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 14 Feb 2026 06:00:01 -0700
Message-Id: <20260214130001.70CE91BC016B@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 05b2e9fe7722af4470139465a53c629c40936cb4:

  fio: bump server version for new option (2026-02-10 07:36:17 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1a04e5746c28316bd8a64825bf2b5739dc01c589:

  stat: Remove duplicate space in __show_run_stats() (2026-02-13 11:44:32 -0500)

----------------------------------------------------------------
Niklas Cassel (3):
      fio: Fix error string not matching errno
      io_u: Fix inconsistent handling of non-fatal errors with option error_dump
      stat: Remove duplicate space in __show_run_stats()

 fio.h  |  7 +++----
 io_u.c | 10 ++++++++--
 stat.c |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index e0b7c13c..65c68d4b 100644
--- a/fio.h
+++ b/fio.h
@@ -542,10 +542,9 @@ enum {
 		if ((td)->error)					\
 			break;						\
 		(td)->error = ____e;					\
-		if (!(td)->first_error)					\
-			nowarn_snprintf(td->verror, sizeof(td->verror),	\
-					"file:%s:%d, func=%s, error=%s", \
-					__FILE__, __LINE__, (func), (msg)); \
+		nowarn_snprintf(td->verror, sizeof(td->verror),		\
+				"file:%s:%d, func=%s, error=%s",	\
+				__FILE__, __LINE__, (func), (msg));	\
 	} while (0)
 
 
diff --git a/io_u.c b/io_u.c
index ac9a1c7d..653a700c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1985,8 +1985,14 @@ err_put:
 static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 {
 	enum error_type_bit eb = td_error_type(io_u->ddir, io_u->error);
+	bool non_fatal_error = td_non_fatal_error(td, eb, io_u->error);
 
-	if (td_non_fatal_error(td, eb, io_u->error) && !td->o.error_dump)
+	/*
+	 * Non-fatal errors (errors that should be ignored), are normally not
+	 * dumped to the log, unless td->o.error_dump. Regardless, non-fatal
+	 * errors should never call td_verror() to set td->error.
+	 */
+	if (non_fatal_error && !td->o.error_dump)
 		return;
 
 	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%llu\n",
@@ -2008,7 +2014,7 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		}
 	}
 
-	if (!td->error)
+	if (!td->error && !non_fatal_error)
 		td_verror(td, io_u->error, "io_u error");
 }
 
diff --git a/stat.c b/stat.c
index b999eb4b..620b4626 100644
--- a/stat.c
+++ b/stat.c
@@ -2604,7 +2604,7 @@ void __show_run_stats(void)
 				ts->error = td->first_error;
 				snprintf(ts->verror, sizeof(ts->verror), "%s",
 					 td->verror);
-			} else  if (td->error) {
+			} else if (td->error) {
 				ts->error = td->error;
 				snprintf(ts->verror, sizeof(ts->verror), "%s",
 					 td->verror);
