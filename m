Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D1432B9B4
	for <fio@vger.kernel.org>; Fri,  6 Feb 2026 16:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770396067; cv=none; b=V2krveIxMi2EB23qu2INTVKJ5yQzfKNRiaWhiVH/nxJZRMCX0mlyamUJJ4N4INlkLUmoTsNQGz9nQLbBNYrcV+80gbhIJudRu+xhQE/Cc3Va0BdB5J9dn1EJEEblPCqRmwhTQQBj5xUVx6acTcYljH2ru1X5UvFqgJx1gpFYQ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770396067; c=relaxed/simple;
	bh=pEN7Q1H+1l9ss/11D18/F1bSDVex+rG0FxpgMYezgzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8iZRd4ZFKQ71B2Hlu20kjKS2mlIANUAkOQo1xL8lA6dppH/Mu9XNZh3N0m41IVpjuHqipJEnswkkInNPZXm56giCSYkR8BjShnjh1rAHfIrTwiNLQm2DvclF8cu+eNwH/Y1ZHq4DEAZvhLXh8bf4TVKs5+vdS2HDwBfMGX1DgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tO5+FC5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tO5+FC5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A612BC116C6;
	Fri,  6 Feb 2026 16:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770396067;
	bh=pEN7Q1H+1l9ss/11D18/F1bSDVex+rG0FxpgMYezgzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO5+FC5OrlC5EwpNybeiGy5TqorsAVgaxdrckE3gH7/Ve7H4r2bb5dWJtBlFL0NkI
	 e2kl0LrTigcZiALeYK9lRWfEedkjBJHUt1ZI9wt40U/T1DTGJqzyAhpUuNUOuf+O8n
	 1kS6c7eFxb1y7cj8bfB6cQiX6FQrURJdWEr4tED8wsaww7d1xNt2RYry0T4Qd1cIR0
	 lZ/hcdlEFQAOG9uiDCgE6ISYl5EuaP6yEMFZ5pOkiLh6uR2XRehBrTdZ+JomE4zNMg
	 rtESP+F0D1/u1W+duXltLJwGmOyb/5hV4CtzgVsQK0aSATcq+qaMgIdYvVLFYzl46z
	 k01XiJK5vjCvQ==
From: Niklas Cassel <cassel@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Jorgen S Hansen <jorgen.hansen@wdc.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 1/3] fio: Fix error string not matching errno
Date: Fri,  6 Feb 2026 17:40:56 +0100
Message-ID: <20260206164058.3105327-2-cassel@kernel.org>
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

When using --error_dump=1 together with --continue_on_error=io and
--ignore_error=62, we can get an inconsistent error in the summary line
 produced by __show_run_stats():

Before patch:
test: (groupid=0, jobs=1): err= 5 (file:io_u.c:2012, func=io_u error, error=Timer expired): pid=30925: Thu Feb  5 09:15:15 2026
...
  IO depths    : 1=0.8%, 2=1.6%, 4=3.3%, 8=6.6%, 16=13.1%, 32=74.6%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=98.9%, 8=0.0%, 16=0.0%, 32=1.1%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,122,0,0 short=0,0,0,0 dropped=0,0,0,0
     errors    : total=4, first_error=62/<Timer expired>
     latency   : target=0, window=0, percentile=100.00%, depth=32

The string for errno "err= 5" is incorrectly printed as "Timer expired".
(The correct string for "err= 5" is "Input/output error".)

There is thus a mismatch between the errno and the verbose string for the
errno.

This problem is this code in __td_verror():

td->error = ____e;
if (!td->first_error)
	nowarn_snprintf(td->verror, ..);

I.e. td->error (errno) is updated unconditionally, while td->verror (the
verbose error string), is updated only if td->first_error is not set.

Thus, if you get a non-fatal error, it will set td->error and td->error.
Later, for a non-fatal error, io_completed() will call update_error_count()
which sets td->first_error, followed by td_clear_error() which will clear
td->error.

Thus a second error (fatal or non-fatal) will set td->error, but since
td->first_error is now set, it will not update td->verror.

Since td->verror contains the string representation of the errno stored in
td->error, these two struct members should obviously always be updated at
the same time.

If you look at the example print above, you can see that there is another
print: first_error=62/<Timer expired>

Which prints td->first_error, and does not even use td->verror. Instead
show_thread_status_normal() calls strerror(td->first_error) to get the
error string for td->first_error.

There is thus absolutely no reason to not set td->verror every time
td->error is set.

Remove the useless guard such that the error string will always correspond
to errno.

Fixes: f2bba1820a56 ("Add a 'continue_on_error' option to fio")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 fio.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

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
 
 
-- 
2.53.0

