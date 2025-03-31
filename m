Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1249821325F
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429759; cv=none; b=sux4TbQRoxO+weqTdL6y/rpRxMpI+3Lp2VdahbIR6vGg8xzYGj5705Idvx1aLw2lrZ09lbrDo5K0FQ+mGDbYUezNwSNChcOZpdxa8jpiZn2BsFzVqc2mVwB1vB5koET+gEb9JEzP/kpJ8kx4+y+FciOOAjChUzY7sbLuyriCIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429759; c=relaxed/simple;
	bh=VaLvPC9V0ICOECQlegn6pgCpBcKkSVYZrYqyvlncSEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdJ0Kp74BIyqoWEYvUxA649P1NaIhcxAn2stwfxIyIFaiCqVEjxnEuIyXvWYJJqnfeFh+Gaf6gr/YZmVe8IQXqMdBp6J3rm/34rZjpidQRN86rBq7zgEpbKjcWoPxe4zzmAotROmUOpctoqe3UPNUDPUAYXh2AFnpP6DdNvrMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yxwfc8zb; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yxwfc8zb"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e8f94c2698so24383636d6.0
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429756; x=1744034556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWcKRtonuaFbetvMSJ98v7/uT9rxuWeyV6nUUkukyB4=;
        b=Yxwfc8zba8KHaUxyyego6VbWYMAp2CqESdtv7fpKBuMbPf8q5Cc6wJ5qEezfu5kBFj
         5a2a1k7CdiJpShw1ACj3qMTLExHLJ3ffYUX5mdrpIMa5mNWD65GH4qNdiJt0c23x3pjw
         MPNpKRaZAnFAqOTPKqum+LnL2VYDyy2Jna9NaOesIiOSv10zyLqmIaDrxEx5MYEfPa0e
         IaIBPIHZdJJSwz3O0TEYlhyvXefVBcAIA0NKb9SUxCz9+wAEYrLBGvbw60f31nB70E9t
         XKtwPXnn7SIVMtlchNHrjadbueBy9PsYeJKIP6Y0wGlj7comsgojm/nx2yGjm1yFtUdg
         negA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429756; x=1744034556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWcKRtonuaFbetvMSJ98v7/uT9rxuWeyV6nUUkukyB4=;
        b=pUauht7PyAcrWQ0DHNgU+J/agUKu73gMW3le0krKdCkZp89GtZhy8Vce0jPKWrwLhH
         SBB3FBbBCLn2PVSaLHBGwVCj4lhIPM0xzhFPQKyDH2ovGNEpaoDensmkr+EO3uE7hIle
         I34wnHEYpXWJZdkW0qP9E/9DMSc/qzM5U3FIMtp4+E1j53iVLGuyzmxMilyiBk3cSx3B
         up0mpoD8nawP9suItG0CMTWorfjJjFr4KN8Ddi3GiHy8hHrzZj/cbvrr0Wrt58/kQE4M
         gixyvOoA3bF4MqWgtlsnB88Z/hcy+HX+2SA7qIqnSkzoxQFWSoxoeASPfluFQXIl/Mnp
         TH8w==
X-Gm-Message-State: AOJu0Yxi+Td+4qiX/wKdn2ryMV7yZNCUb+W9UrsmkI62kR/bpIi9xUSA
	hgfA5nMe4+Wnr8LGXv5BIFGcZ1+MJz8Nw2Z0jevde++CyxxQhhSVCYkbxA==
X-Gm-Gg: ASbGncs7c9WllXU+CvyUHzPsmCm+u9hz/U6KjuS45MrIZjJc+2NJh0rY5AAmQE8WQ9I
	Y/PQVKUkMSJLT3GWLFTv6HEFnxtaYRo5U8s8EoC/MwOY51aytRMMca6/qY6WkN4+fZkZM3d1Z2T
	SHRdjopQuY1bx2BlqA1/mkL3CUJKTgUmDDB7dA2ngXIsJOTM4RmpEiiLdpyihPg7TlAg0pxWHXO
	kJKDL/R1R8KL5iEXoHWyd8BKYeteIK6b40HMMlxLgW20d6ICJVikW9GMDn9tnCTIhP17K1hBXUN
	3Nudzs2gUg/70ihWpOKpaWP5NXPqHWNwLtnSlwqpuguRAbWvCIX/KJZAFpV95e6dIv+OzkEoOP6
	GT2mynDov2MnrkkD0A8kkNmx9PkhMi/fmXw==
X-Google-Smtp-Source: AGHT+IF2PUeFmDbUwh+Gbg2AjcffTw9C1TBbtRGdxn7w48CKh3q9dGvwukbVvchaMOiEqCDbJ3IJRg==
X-Received: by 2002:a05:6214:29e3:b0:6e4:442c:288b with SMTP id 6a1803df08f44-6eed5f9d060mr124655396d6.11.1743429755843;
        Mon, 31 Mar 2025 07:02:35 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:34 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 3/7] init: error out when readonly is set for a trim/verify workload
Date: Mon, 31 Mar 2025 10:01:30 -0400
Message-ID: <20250331140204.1971-4-vincent.fu@samsung.com>
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

Fio may issue trim commands for a verify/trim job. Abort and print an
error message if this type of job is run with the --readonly option.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 init.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/init.c b/init.c
index 85ae67fd..20f5462d 100644
--- a/init.c
+++ b/init.c
@@ -612,7 +612,14 @@ static int fixup_options(struct thread_data *td)
 	struct thread_options *o = &td->o;
 	int ret = 0;
 
-	if (read_only && (td_write(td) || td_trim(td))) {
+	/*
+	 * Denote whether we are verifying trims. Now we only have to check a
+	 * single variable instead of having to check all three options.
+	 */
+	td->trim_verify = o->verify && o->trim_backlog && o->trim_percentage;
+	dprint(FD_VERIFY, "td->trim_verify=%d\n", td->trim_verify);
+
+	if (read_only && (td_write(td) || td_trim(td) || td->trim_verify)) {
 		log_err("fio: trim and write operations are not allowed"
 			 " with the --readonly parameter.\n");
 		ret |= 1;
@@ -729,13 +736,6 @@ static int fixup_options(struct thread_data *td)
 						o->start_delay_high);
 	}
 
-	/*
-	 * Denote whether we are verifying trims. Now we only have to check a
-	 * single variable instead of having to check all three options.
-	 */
-	td->trim_verify = o->verify && o->trim_backlog && o->trim_percentage;
-	dprint(FD_VERIFY, "td->trim_verify=%d\n", td->trim_verify);
-
 	if (o->norandommap && o->verify != VERIFY_NONE
 	    && !fixed_block_size(o))  {
 		log_err("fio: norandommap given for variable block sizes, "
-- 
2.47.2

