Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57549154422
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808551; cv=none; b=m35FOfK0gnHvmtatA0BaymVK+62o1BPuqqL7rlJ7fXZna0TEwVjElaetwZzdi2a6W/mvXpugjYhDV+4Ej6ntK0pOiJYLlgu4WYjhZYl0IkfZL9dAOcsqloUgXjge1R4Jypuz5oiCCV9rgLl52o7jzsIxOrdMqSW6ku3NwrH44VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808551; c=relaxed/simple;
	bh=Utgv9XrAzx4AXEJ8vS308iIq+KUeHNpgqDBWfkHkDqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVlo2v9/JGBo5nX0CkP1XiGWUpbsglFSvkUlqQQjsAjm2MKWvz68kwZ0gablHwqe+8hiHKQfffX6fFbedm56b/M95vPPHfSkPOdT7MR+JzaBssgYJnlMtBAXDtzKxawcUYgWL4Q6Y4sD2GQaks8yySJUteJmb/LAJt3y0AkVDfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vkqd1Vlo; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vkqd1Vlo"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-78f05341128so323738585a.0
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808549; x=1714413349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hv9fnokNC5vOYg0jUTOaN4LUx0sVbihbbNJWo+A8WMQ=;
        b=Vkqd1VlopYbesEQWCY4rBpDcjq0H2n1oqUfQWPd+AdqbcF2zsTpm7RfNBv/hiDULXg
         n7AnONXGs6Cz+l+zvpSxU4uc3pIj3edK9WGc1yYCxAq++IXlnYNcjyLXb5Yyxi6Qz50O
         P2kIoenWlrBPSU+6FmqBlggXe7f2eicHyl/4k85iXSrLmSMpf2X7FeTJbCJ8l4YsvzXb
         Alf2VAin4IaFMdKmq4u2Fd0K92XmZvNmZVbHagvjFW5voQ11++OJszJjeeWvbdKYutiV
         Wh/Kpnuy9l5H8fNxkjnoYxrhDe6OESAwZa/NGmi4h+gY4wvYlKRDYQZpD7CRqmRkDxru
         //DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808549; x=1714413349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hv9fnokNC5vOYg0jUTOaN4LUx0sVbihbbNJWo+A8WMQ=;
        b=FRpFfa8JDHnbPun3SRXY8MlH003byIQ78u9at1fyj/TsTRd6odn0eq0QR/ZtWvOB4A
         teEmpWL/Zzd2lSQehn1hqqxSMRfS2PSliuaWoP2B067R3cxYFPUNlmAXvbA2/iClAuS/
         IrecwU4b4CRdH9NNLn/6hUMgj5X4qfp2BGed0TiHDPfuGUbpBxk8/7zpSv1PD4FuMVQl
         7sgDt3iuyQPvpghKTut8UbyKlX+WlTy5BT056FJrKnfz+JtVUR5+CewIlxzo1ve2iXeL
         1vR+VYGaTRUvtIaqgNEBay+4yShamfT3jN9/y1K9uFMVID4CU9fjGejRHO6kmc/HuY4o
         kfCw==
X-Forwarded-Encrypted: i=1; AJvYcCV7z4NZreNvEfvONS0K8K7rbewBPYAB03iUuRNx7RmowOhXTydtAo4bwU37ZdbLMtpM1JVouogSDZU7SVK4Iv490Ecv
X-Gm-Message-State: AOJu0YwC9ccwNl71LrlwutTAAeVkHiSCNiWE3pVCOxLJAgkVJx1eRMOS
	DcIUU2Jjv5yMPZG6G/hcodSG+gaID/MTNffUq+UZqlzHCYynpK5m
X-Google-Smtp-Source: AGHT+IEQaEb5PSWq+TJNqeotz9IWwTnHFP/jx8NJprVOWiJm+Zd50Gq3oI5JZk8ihD0EFjIxvGCJ5A==
X-Received: by 2002:ad4:4f01:0:b0:6a0:7cef:9883 with SMTP id fb1-20020ad44f01000000b006a07cef9883mr4414210qvb.14.1713808549254;
        Mon, 22 Apr 2024 10:55:49 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:48 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 6/9] options: parse placement IDs as unsigned values
Date: Mon, 22 Apr 2024 13:49:52 -0400
Message-ID: <20240422175522.4614-7-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422175522.4614-1-vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/options.c b/options.c
index ece90c72..0484b6b4 100644
--- a/options.c
+++ b/options.c
@@ -271,7 +271,7 @@ static int str_fdp_pli_cb(void *data, const char *input)
 	strip_blank_end(str);
 
 	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_DP_IDS) {
-		unsigned long long id = strtoll(v, NULL, 0);
+		unsigned long long id = strtoull(v, NULL, 0);
 		if (id > 0xFFFF) {
 			log_err("Placement IDs cannot exceed 0xFFFF\n");
 			free(p);
-- 
2.43.0

