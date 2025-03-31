Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3DF2135BB
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429761; cv=none; b=X0UgNUFgRMEXcaYgriHENXvDNEEjTNK33U3xI2EazuLK7B4ojILZoDHwVAlB+uuBsSNqtMyKmAr3fjmMhjRTP2NEuQKTsKVCKBXRd2bMxzm1+ptooholaMv69RACIx9IFh+EslwLqLQzwjurzfFCx7qKAsit3A5/k1dMHRdzS24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429761; c=relaxed/simple;
	bh=Elq9GTLExqqS2boa2Lc+jHKiOOFHwjHG+ubRJucULZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJPOmNgGiCVm8K5/q5s+66/sQzGPQJFCJvtcQeRNdo43mxD21BRp8uphGbooesUapGPARogQIH+c38y7X4obi1PgKmY2JWScTTEzsAgXAIP2AFP5lGjD4CrtUf6bCxutTzDf2kAX/9kMkm1kVbBaJxpg6VwqdyczpUBqNvbneVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lO0eHgO/; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lO0eHgO/"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4767e969b94so29251331cf.2
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429758; x=1744034558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYd9vVl9SJDKoEAUpLAuTauamKSdd57rwsqFWpJax9A=;
        b=lO0eHgO/CZqKnF3qfpJD1MROQ3WHLmvDeDOxeEnDZRAIqXsnJczlelgo7LlXgK/cls
         5iomZCHPBh7O07nwQfs5Lf6zS4s1+d/JRpDdDVWQcTWOMXnvauS6WmkLwsuFmUt/5POx
         LcTWhfOazxBh7LUdN5cgIAjob5Dr3I91BrvMlx6h8osj52XyrIzOUlsJn/vyLERcHzbH
         cmPtjK3xfW2WODPsXEeOa400x/+uqHCZktLIu9qhcLghfPB9UqP61FdD8529B22VZdt9
         b0F9fwpS+xua2utRb3SWw/iJ8po9EsNIWKBtjgtD6m3f9PiESCZ6aZAYaEBFVkhPUNEO
         4AEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429758; x=1744034558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYd9vVl9SJDKoEAUpLAuTauamKSdd57rwsqFWpJax9A=;
        b=NBKjclTT8MjPpbCM8YmCUaYvGqsttf/4Yrv3+e0z1T/+EgfdUEZw2jgUKIAwE/9Bwn
         UmobxP5GMoHumdE6TB0o3O8DDlpnp9l5qVQBUXmKZL4nTn9yM5G68EuHJs64eHNwtmrR
         5NQjgpmWIwnjZ0tX/P4Dd4jXgN1HWjkc/semQHpvWacl1gldDOX0vvRZrUUINyiV+lao
         tYbnIfK5hcdh3Kj/gO6T8yJOA/J1v5fOXdfKNOP7uhOP92rCsKT9ZD82ZrSk6ECps7yC
         4ORYOEo7y7S9m68iZOjy7lvU0rJEmn+/3jgSwMTp90KR+5IjR2CqcESVGV107A5Pp2Wv
         9ziw==
X-Gm-Message-State: AOJu0YxFJgmfppCT9SgAu0kQotjyRa+B6nmlQ1Jb/TdMyFtAbqlpO5bP
	LkgDl1ymJMo/Xrob9VeRRaqXyxZ4nljlUYhAaWnG48EsHBK/q1MNJN+8RA==
X-Gm-Gg: ASbGncsJSYmGBsk8HcduQgYmRXpTtUv29aZIuXaVcTrCdECveHH6RC/xTB38mL0NFxx
	OHcmFHLFy2YEsDgqHwrC+EGIk8uYkSaBcT/wVSD1wNcSRIi7lKROGk1DBOtL2HjCPQkYeerPePC
	2PfZaaTvIihZyDekoxjasJH199PnwXhGeDzPNa7OBgIXqiUXuUF099pNpusD6OknDAKWfDDjhni
	PiVF3v9pqhs/g+doasdtDXKx1/cPY5UpzbCbqi5Y53TkCc0iWz/ZPzyljhXXHtzdlnH7VBWDvmF
	WlPvyLOLXEn89zVeMlQ4eh4c2CVFbuYCKpVuRJ1zToGFo6WTVx7Ka/777cxnIrDQqjAEeuQig2F
	ITvj1hzlP3yxG0u1GJJF5/GOhCKc5+pY86g==
X-Google-Smtp-Source: AGHT+IF3MSLDCV9Dys2uhIGKqhpYV96E0FfGBW/SXK9vOj3N2UiE0j4XrZgWlT+bsrlPjkM3dcr5wg==
X-Received: by 2002:a05:6214:496:b0:6e8:9021:9090 with SMTP id 6a1803df08f44-6eed6044038mr120424366d6.26.1743429757627;
        Mon, 31 Mar 2025 07:02:37 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:37 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 5/7] verify/trim: make trim_backlog_batch work
Date: Mon, 31 Mar 2025 10:01:32 -0400
Message-ID: <20250331140204.1971-6-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250331140204.1971-1-vincent.fu@samsung.com>
References: <20250331140204.1971-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to detect when we are at the beginning of a trim phase we check
io_hist_len and should check that the previous operation was not a
*trim* (instead of not a read). Without this change trim_backlog_batch
will have no effect because after one batch is done, fio will simply
start a new batch because io_hist_len is still a multiple of
trim_backlog and the last operation in a batch was a trim which is not a
read.

For check_get_verify checking against read is appropriate but for
check_get_trim we must check against a trim.

Also we need to decrement the trim_batch count for the first trim
operation we send through.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 io_u.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_u.c b/io_u.c
index 66cfa16a..17f5e853 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1761,12 +1761,14 @@ static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 		else
 			td->trim_batch = 0;
 	} else if (!(td->io_hist_len % td->o.trim_backlog) &&
-		     td->last_ddir_completed != DDIR_READ) {
-		td->trim_batch = td->o.trim_batch;
-		if (!td->trim_batch)
-			td->trim_batch = td->o.trim_backlog;
-		if (get_next_trim(td, io_u))
+		     td->last_ddir_completed != DDIR_TRIM) {
+		if (get_next_trim(td, io_u)) {
+			td->trim_batch = td->o.trim_batch;
+			if (!td->trim_batch)
+				td->trim_batch = td->o.trim_backlog;
+			td->trim_batch--;
 			return true;
+		}
 	}
 
 	return false;
-- 
2.47.2

