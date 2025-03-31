Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8241BDCF
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429755; cv=none; b=XAj0QZkAyczE60tin4vwtE4eU7vDdfMKIvLbkBeCnZOcc2RW33bQuEpWfedOXmGkZZbG/VoH/v8dZIZ0tdKj2PAURc4+a+mQnM8Mh5xcjjaEjNd5SMtKgRT8pc/A6nPC8wTQw/40Ueg+h0eFsN4TwphUw+Bh8P5ebrHxJqrZ7bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429755; c=relaxed/simple;
	bh=FrTaJ5Xdia+1sy5Fs3U4oXx1YW8f2wst3h0UpmVDdvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGBhokOc5ZcmyL3sr2KmTx+SViiZZCZcunQrBJ/Z4NNg2kmZsA1iE3KFi5YPcyxysn+ficuRZmvSAikQp6dErLd5qBLwLsA7pjGGaP75/DMdbMgcTP2kDzZJja21svEg7KzFhnD22LT6jTF9BCUe4Xox7sphIptbTTo4IQho0Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SY6P1I/8; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SY6P1I/8"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47686580529so46429891cf.2
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429752; x=1744034552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+7tj0cqorULMElBtP7ZqkD4w1gnd0UMlXinl9EG+YU=;
        b=SY6P1I/8/IXWZ454AqSF+jU2G1bC3DsS9fYlO+2lQFufVOKUi/iLjKenyos/z2XQfV
         cM8LGwD3suQ2A79BZVsN04Z9tr73uD+S9m2tf8HKbw/RcK7QGEEarh4O09zXGfYB1+9I
         gQOK2fjZvxQvH4TU/Xs7nkt+BLQOi961i6noG5y6i6fj2WGzckahWYtplwjdOsu0i2Lu
         CQMZjWaWK5VNpTebZV27oU44yKQtnQyooQyeX9UyVwj8OB6MCnip2pD1FSDA/YMrUBt2
         lx4BWS0/a1lnolImX9i5SASKKDESD99ohKdvp8orRbvE1gIlLKqtNW/rrCCpoQKuSuJn
         qQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429752; x=1744034552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+7tj0cqorULMElBtP7ZqkD4w1gnd0UMlXinl9EG+YU=;
        b=nVDKbSaE1qwO845w5RiQ+SFHVJK9SMUhMoB4eyyJsVrGkuWXG8Nd5HV9/sh6b/1eNo
         VtMM3S8eX0caKmropU42GBA2XlSGExbv3xp/dGs7OBsRfJgOSP2y68eVIpD19ZpzRJMb
         6bIBobFMl+NomCgp8I0kuEaCrgZfgR9eSceLMrSvOaBcYDnAZbcxireL5Lahn/N6+c3r
         8UF8mLK8wg7GoUOst2H3mrCeZcnD4dvVbSchDdl3c+AbC+tB8vD3PihnEc5QthyJsI11
         wksBC085rliyoFMuJHevXydAAyo2UgLMzRnOqUIY+067a2Ssg61ZRNG4swVSyhaMFxyl
         FUKw==
X-Gm-Message-State: AOJu0YycX7P/zqCxJr9KgP4b4aS+OQTPXgylMS14CVWQgnEvNSb60mjy
	KvTrwwM82RVCDvesHRnfb08VymsMfw/7u4y2ihjhGcs7n0sVSdmuWiGFbg==
X-Gm-Gg: ASbGncv5umwSJYjPcaCj/uMWzLT1GnZh5xHWz4wyKppIyOzfVefNhLjYpowFqWlWJVt
	/UL3QLBe3GeYGObMTcIK+43Vj/lX1PyvtTpo/eF6oZrW1Y6hKfZvkFPSvtJqk5EUQVrUhkvrLr6
	6oDjBjYqPKCOvC/6gk0BnYSM00JDIBsc5FVlzUSNZQ88P0ca+9u5I4FVazoFTuZuifFwuTxKjIM
	PnBU7XeEt6KGhaEO39PGkizVWu5bEjQcJVFXno1x3OSbitj0VInbkLpeXgIiAiTciU6ZsahvSUg
	Ez501mZ2VrdGDhae9vpXRuku2yFw1N1EgJ7fYjxstG/NwxMW/d0EwMIcpRs8KQcRBZ4cWP0Hb3/
	rGZ5oUKY6vCAUOHkIEHmN+Xf8cs6ZWyQwmA==
X-Google-Smtp-Source: AGHT+IGwJd/qJj1QG7+XTY/139FoWQRYkQen2umKStN/imsjMsLEnXR4ogA51InyKTtWaJkvcOhECA==
X-Received: by 2002:a05:6214:27ef:b0:6d8:a7e1:e270 with SMTP id 6a1803df08f44-6eed625d45amr110561856d6.40.1743429752374;
        Mon, 31 Mar 2025 07:02:32 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:31 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/7] fio: allow trim operations for verify/trim workloads
Date: Mon, 31 Mar 2025 10:01:28 -0400
Message-ID: <20250331140204.1971-2-vincent.fu@samsung.com>
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

Fio has the ability to verify trim operations by running a verify
workload and setting the trim_percentage, trim_backlog, and
trim_verify_zero options. Some of the written blocks will then be
trimmed and then read back to see if they are zeroed out.

This patch changes fio_ro_check to allow trim operations when fio is
running a verify/trim workload.

Fixes: 196ccc44 ("fio.h: also check trim operations in fio_ro_check")
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 fio.h  | 10 +++++++++-
 init.c |  7 +++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fio.h b/fio.h
index d6423258..00f0f09b 100644
--- a/fio.h
+++ b/fio.h
@@ -292,6 +292,7 @@ struct thread_data {
 
 	unsigned int verify_batch;
 	unsigned int trim_batch;
+	bool trim_verify;
 
 	struct thread_io_list *vstate;
 
@@ -618,7 +619,14 @@ extern bool eta_time_within_slack(unsigned int time);
 static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 {
 	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)) &&
-	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
+	       !(io_u->ddir == DDIR_TRIM && !(td_trim(td) || td->trim_verify)));
+
+	/*
+	 * The last line above allows trim operations during trim/verify
+	 * workloads. For these workloads we cannot simply set the trim bit for
+	 * the thread's ddir because then fio would assume that
+	 * ddir={trimewrite, randtrimwrite}.
+	 */
 }
 
 static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
diff --git a/init.c b/init.c
index 95f2179d..85ae67fd 100644
--- a/init.c
+++ b/init.c
@@ -729,6 +729,13 @@ static int fixup_options(struct thread_data *td)
 						o->start_delay_high);
 	}
 
+	/*
+	 * Denote whether we are verifying trims. Now we only have to check a
+	 * single variable instead of having to check all three options.
+	 */
+	td->trim_verify = o->verify && o->trim_backlog && o->trim_percentage;
+	dprint(FD_VERIFY, "td->trim_verify=%d\n", td->trim_verify);
+
 	if (o->norandommap && o->verify != VERIFY_NONE
 	    && !fixed_block_size(o))  {
 		log_err("fio: norandommap given for variable block sizes, "
-- 
2.47.2

