Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1DE32B999
	for <fio@vger.kernel.org>; Fri,  6 Feb 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770396069; cv=none; b=tkzL+hONs4xgXfKV6qMp13N3OyjOQoPXL7YrukZAYCUjQ3ACPFzevMviUrPyFfgnBrKCHHt6gyXV1jAYuof+aHAWStZtSgWe6dwiNwYYvqotq8mAqka4SK1JXX7hI0+ighwV6RNVKEr5h6zWGfsGkM25gzDeP4++VEjhzAc/9lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770396069; c=relaxed/simple;
	bh=klil/y+oCR8zB4gefR74RRfkOIEERlgnNfQmI8bCVUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWHyXFRfjIKLDlNRqArn+D0vnrx6oqhLtx7ykxKZTgnn6zWwCxCLVsaqax1tO0tsVEybV4C4e0OMMPKco/xtxJusjNCsZ32psi9QjQklRDWq0TuvEZ9pSAxUWiMZaPlPGnGPJqG0S2HArgkRyio5aioH/kdRZWY/LXnNsVOCcR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmKoyO08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmKoyO08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD4BC19423;
	Fri,  6 Feb 2026 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770396068;
	bh=klil/y+oCR8zB4gefR74RRfkOIEERlgnNfQmI8bCVUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmKoyO08+R0eikCKGvXMH/LiER8a26bxBp7hdwZ8uIqCeIniatoPZfporCwXQkRwF
	 RdH2FWh3Sgu9LKG2GatCj121OpA2KNudQkuIYAllIHeUvY2kq0uCwsczMeXmOV0F2C
	 4AREpMQucMveyRjGcaVQNIazP6sKkZ84/Fl7Wy8XFhFplsZDIqMUo7kEU1ZBbUU1ZL
	 HUxJ74+67QjocOboGmwA8LrLuHawllb7i2I/DD3lwMWMoRhgAvG/zv7KZbjre8jAT7
	 qS62QU5jWdCz6MGuzmbbol189p0L8s7zmY9Z58bx7WQiPM7lvknu79liVG2v00mYIj
	 0BKFxEzqPCdcw==
From: Niklas Cassel <cassel@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Jorgen S Hansen <jorgen.hansen@wdc.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 2/3] io_u: Fix inconsistent handling of non-fatal errors with option error_dump
Date: Fri,  6 Feb 2026 17:40:57 +0100
Message-ID: <20260206164058.3105327-3-cassel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260206164058.3105327-1-cassel@kernel.org>
References: <20260206164058.3105327-1-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 8b28bd413759 ("backend: Add configurable non fatal error list")
added an early return in io_u_log_error() for non-fatal errors.

This early return is performed if the error is a non-fatal error, and if
error_dump is not set.

Looking at the help text for the error_dump option:
"If set dump every error even if it is non fatal, true by default.
If disabled only fatal error will be dumped."

So this commit made sure that, if error dump is NOT set:
For a non-fatal error, io_u_log_error() will return early and will thus:
1) NOT print an error to the log
2) NOT call td_verror()

However, if error dump is set, io_u_log_error() will not do an early
return, instead it will log the non-fatal error and then call td_verror().

It is clear that the intention is for a non-fatal error to not set
td->error. (If error_dump is used it should _log_ the non-fatal error.)

Thus, fix the code such that if error_dump is set, for a non-fatal error,
we:
1) print an error to the log
2) NOT call td_verror()

This will make the behavior in io_u_log_error() consistent.
If error_dump is set, we will log the non-fatal error, but regardless of
error_dump being set or not, we do NOT call td_verror() (which would set
td->error) for a non-fatal error, since that was obviously the intention
of commit 8b28bd413759 ("backend: Add configurable non fatal error list").

Fixes: 8b28bd413759 ("backend: Add configurable non fatal error list")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 io_u.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

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
 
-- 
2.53.0

