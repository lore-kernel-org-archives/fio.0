Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C03415444B
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808550; cv=none; b=WmZxKhake5h5+K2GiTelG+Xh4GVt7KFcmBcHQfmjN7KbDaOI2De8kJ8HT6KGLjAbZXP6D7SAcbgjvS2K12YVR1BH4JTy1C25rdGuIZEiq0ZE16QzQzWQH6CifE0pyQ+6yYRysFOUtC2LtTdzpJoc444w/mtGSJjTViqMwWm/Y1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808550; c=relaxed/simple;
	bh=Z26YarxJwRXiNTgpfEP6uV3EAejaqecJJ5nKjOo9L+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPLuJJ/f2iPKeW0TBiwnhm/QgOUlIWEpv3faFrtEO/ZgVONUXHhkpdIDTsevquQwGs1bzO+eE7vNtX5mBF9+EEbmgz8bGwe1AZBRQlgnOu4dn1I3tuR/wTKFvcnxI0neJsRb41cUdGXWXifiX/MHjJgnR/63kSH/S9MeD3XlPxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFaQnZAO; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFaQnZAO"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-78f03917484so337475985a.3
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808548; x=1714413348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSUPfm/9oJ34aE5Oriq3ee2kIfHtE+EEDyLD4wlqs9I=;
        b=gFaQnZAOnD2V69bZoTt5AasB3M25ie4G0MR+X2BHxZKmUcbzvpFcYpvvG1Du1FJ6+u
         lSiZSF23pCSfVFAVRhoQFU9OUuQrmf6dIw5MDn8LdkpXcByLCdfwjW0kY31Mqsn63QPk
         veIX4GLyExw+OwKMJsKvjk+1jwrAThVdyAeXjOevsuSFJZHvGrDOhHcj0VvVIMdYA6HJ
         B/g1ju/dS0QWw4VGcggvOt1W+SOYhqHZ19sh7sS9karg9qgxIg50Ndp6R8JSU2akWxGG
         PTJdhwXaA+ff1JPy6mr/S+Ng6zQANh+5/pxHA9am5GrvTB4PcPOK0DEVzEr06PmqWnX3
         jaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808548; x=1714413348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mSUPfm/9oJ34aE5Oriq3ee2kIfHtE+EEDyLD4wlqs9I=;
        b=qn00cadfKA1gvQaEgJwMe74c5csxFYtG8ZecvI1B8dkwXattLkkmZpKogSP5tDvUxs
         QjQWgYwkO7wMxxs57AneKgbxONcQJZyIYakHnWpZV1TLQ2OX4m1bD6EKt7fs8FwA3ijB
         a6g+bmrYGT7FD7A4F29sccgJRs569arGcuSKTXPNlDdRwj//vYew2fgYWw0/F+iC7Yak
         Q1dEu3vZsKCfOjcwVdTHRwMv9vRj06X7LbgisLbI4y0n5ea7QlavWiAefr5B/uMsTO04
         Id2dd94piThypHmMdCdIA+L1k6Ch8+Msd4qaPqmRscHSo9+phMKF+Y3gbwM7W3d1euGF
         19Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWI3mmFOLgkZ7EPUi1WCTSwiNjzMNQKqghhqON76ppJ5fQgwsXDbc4LAaplezXEKpGkSYEN4qWyuSsivKk1hbyhkL2l
X-Gm-Message-State: AOJu0YwOR95m/EKaH9yed+w49Ua1Vi6b10tknDkXUoQTiLwjUpglXsv5
	39VViUAltWKNmpraqpwCeGIWy3WB6cJtnSIx3EgosxOcLhGVvD5V
X-Google-Smtp-Source: AGHT+IGgtIA5lM11tquRpnTHm7qJU8O8Ga9yyGF1PaREdq4SqTfQqr1R48sS3rwylxkTN/pPrWv29w==
X-Received: by 2002:a0c:cc90:0:b0:69b:7c92:d880 with SMTP id f16-20020a0ccc90000000b0069b7c92d880mr10761095qvl.52.1713808548001;
        Mon, 22 Apr 2024 10:55:48 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:47 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 5/9] options: reject placement IDs larger than the max
Date: Mon, 22 Apr 2024 13:49:51 -0400
Message-ID: <20240422175522.4614-6-vincent.fu@samsung.com>
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

Placement IDs are a 16-bit value. So we should notify users if the
provided placement IDs are too large.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 options.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/options.c b/options.c
index 09a24652..ece90c72 100644
--- a/options.c
+++ b/options.c
@@ -270,8 +270,15 @@ static int str_fdp_pli_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_DP_IDS)
-		td->o.dp_ids[i++] = strtoll(v, NULL, 0);
+	while ((v = strsep(&str, ",")) != NULL && i < FIO_MAX_DP_IDS) {
+		unsigned long long id = strtoll(v, NULL, 0);
+		if (id > 0xFFFF) {
+			log_err("Placement IDs cannot exceed 0xFFFF\n");
+			free(p);
+			return 1;
+		}
+		td->o.dp_ids[i++] = id;
+	}
 	free(p);
 
 	qsort(td->o.dp_ids, i, sizeof(*td->o.dp_ids), fio_fdp_cmp);
-- 
2.43.0

