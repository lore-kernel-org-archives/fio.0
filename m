Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9D74E3769
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789674437; cv=none; b=HnKhQfAn9Fz4vZ5HSzKHTs1U5Ch3y1LTHKi7sfktpahorbzsiq2I2WK289S14wfgmcJeQOOilPLC8YQ8CbLMPIWhBiNWp7M+Iizmso0FijAgvK4lZ5eeiR6Ojn9kv9AnG3M0ojN8WvmWhEyB+e5ImVCeo16UMFC/H7XqtRW13YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789674437; c=relaxed/simple;
	bh=aDE6yuJMAMA2ObyDdBW330mJnLNz6Cx9kyHWeUmAXCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfEpFYAdIMzJd29fPYDnvWu2n/FF/9Sa2XXdkAEUFAPE90wEoRtXEJbkBJzxb9Ck4uI03cd8FPeQLr4ZXqTZrzzVFFLK3qlHUNYDHp6SQVeelqsOlhx1iAd1iFGfsoY41/Hy3PJph1CTFUTqcALw6YdAq5p0YUORGNXZnBnndDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHRAfXSR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eplyjNJ4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHRAfXSR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eplyjNJ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789674433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iBXaIsrzbQAmcX2poFz6Juz353uRe8PxcDDMRODgDak=;
	b=gHRAfXSR9+nM/Ph/MFPeWWVLrywAZlKTA8Cbv95VqdOZLa+KnwYoBeDBYEVEgyFNaFzbdR
	n3Lw+Jw1Rljj1O5vZJ0H3OejN0XfhqzBEYGQlxZlgGeotldu8PEUm1568B8+QcJH73zZDO
	Zv08lex1zp+K2ygQERSU5lqK6Kib5pw=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-2PjzaWvLPYieMLcDFiZYOQ-1; Thu, 17 Sep 2026 15:47:12 -0400
X-MC-Unique: 2PjzaWvLPYieMLcDFiZYOQ-1
X-Mimecast-MFC-AGG-ID: 2PjzaWvLPYieMLcDFiZYOQ_1789674432
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-8052a85c504so1232101a34.1
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 12:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789674432; x=1790279232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iBXaIsrzbQAmcX2poFz6Juz353uRe8PxcDDMRODgDak=;
        b=eplyjNJ40Mj+6Q4UR0LMO7kGr73HKBQJOs+5aymWyQ4yxmyunKAKqY1A8APnS08ny5
         F0gFIidIxeVLaaZM3P1pY7nuVkicLlngNvhV51i08GTYrWtpDSMuehIU1aHeG34n3OUZ
         oOoVynct+4U0S1nji1EC5RQG8BgtjFUL5YCG3jflqQ9OxDdW3j3shBwe9RHr+CLn89li
         6odGSLBJVcFGDKudq6thLFhze4j/lEihg2+JiySGzLU4RG+5DtJxLFNKkKgXDNjLNtTV
         nsD7c5CdiaixSbpd3/iIHFNS3IFMLKeZrbJ1KRDnSg9aMULRzheQGWakxt82Q/H1IGQa
         J/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789674432; x=1790279232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iBXaIsrzbQAmcX2poFz6Juz353uRe8PxcDDMRODgDak=;
        b=QY5z+VK6qmn1Klla5EMdngqC5JFFlJVLECcB39pOYzssyPiDkuXp3huiWtv9MtAhO3
         pMWI8d6r/j2wZanzSpEKK9sBYNTLzDQzKr+DLLl0PW+6XC8DWayjd2lFKZK6bCerJlw9
         Iwc70snrVhviORL4AHkN6M/DDUinim91p5TpLjbiyKlJS07MxiFbtFIZtpgg0Uoo4Nyc
         Sv1CncLot206KNWKoFgdN2QVQ/IE7v2srKQ0cPwy1mvUflqaTu/3piZkE2+0dY0raLh1
         E09g7QqGv532vLg+n+3Y6lfzOaWtCBGL7L74FffEbTuQPKXb3iLz+I6dmDlLBjdW1H92
         eDOQ==
X-Gm-Message-State: AFuF++n1BHYsN6jvN2FdtJ0FHm5KThOvUAOJbOLjpyEQqyZIUkqEhFF7
	/tdqCXpVmvyDvCQU2+/GzpgyRCTmxHAX2WgX2WfLTtSRhZ06vC8mm3tKNBsNkVQgZunLrm7jUQ3
	UhtG6Lu5SluYW/R6ayiK1CUZPheWvrpenMeRSuOdRViekdqcOjY98UMZYQddYRa1u5WxucRAOFa
	DcqRqDd/KHo6tCMrLIEhhG77M00T73wrcoq5sodUE=
X-Gm-Gg: AYBFou0JXm5lGB2vmwbyrbdc4PXKVEKSvFLNZB7thiVPyQXrGrqQsCcqoa7/Rx+HscR
	tfKKQZHTBnyyEsVagzhe+gmButNcwQWoLaj4IVOLNNSkJYcI54SMQgL6ucs582uVaUAQTULv+mt
	e+PSCTbcplWIkHEAOa/CPmKnro0TzyYlVoIVh3PI/Ea+foDSxlnw4371hILspmMbXRE97WsGlxg
	aNZC6WLlJqltMUZ/7BBnSmej+xMP7ZpTYgyMSrbmU7khb5oWeO3UmuPAdZT75r+ouPQVtd/Nbp3
	Xs+yGNawE8dYGNQiEkwbANuMfqhNPwNoVpWcdwG4vJSjWSQch2nAa28n5oz+F/pPema4TX9pCFH
	5tAnCGXGiyDmN8kg6WY1818AYwAofsBvWMF85Uw==
X-Received: by 2002:a05:6830:6a99:b0:80d:7045:ec38 with SMTP id 46e09a7af769-80de035af5bmr226268a34.7.1789674431615;
        Thu, 17 Sep 2026 12:47:11 -0700 (PDT)
X-Received: by 2002:a05:6830:6a99:b0:80d:7045:ec38 with SMTP id 46e09a7af769-80de035af5bmr226238a34.7.1789674431131;
        Thu, 17 Sep 2026 12:47:11 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a2e63sm3828886a34.15.2026.09.17.12.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:47:10 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] fio: server: Warn when listening on network
Date: Thu, 17 Sep 2026 14:41:26 -0500
Message-ID: <20260917194706.2264798-4-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917194706.2264798-1-sandeen@redhat.com>
References: <20260917194706.2264798-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it crystal clear to users at run time that the client/server
protocol should only be used in trusted environments.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 server.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/server.c b/server.c
index 34f3f5c0..887ed7ed 100644
--- a/server.c
+++ b/server.c
@@ -2596,6 +2596,13 @@ static int fio_init_server_connection(void)
 	} else
 		snprintf(bind_str, sizeof(bind_str), "%s", bind_sock);
 
+	if (!bind_sock) {
+		log_info("fio: WARNING: The fio network protocol is neither "
+			 "authenticated nor encrypted.\n");
+		log_info("fio: WARNING: Use this mode only in trusted "
+			 "environments.\n");
+	}
+
 	log_info("fio: server listening on %s\n", bind_str);
 
 	if (listen(sk, 4) < 0) {
-- 
2.55.0

