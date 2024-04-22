Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67B0154425
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808553; cv=none; b=Rb7Ucf/GR474NtOUwtjpG/+pxd+dRTTqONdPYzmsNVxgQd02p0mibuNlo7GtJw7V6Sk0jVZxJKhqFk3+ex2Yni16SHciz2p8h2nzgfrYUyXTGMTZduizN41NUyKZogBEJfS6t2aqYHqpDwU4oXKQM/muYDE8NhTAE0qmgZEZ8SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808553; c=relaxed/simple;
	bh=Jaflxc0IlgormFMXDpoZEbXsZb5fpIWhHddL/9iCT5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXyA4Q7j49vJqqBSIEaXtZ50M0d28oif4kmeqGwgP36dsK9AA0b+MgurV9RyyJKcAxB5rpaSdK8rDxjvMBI2/spYYxKm3ZDLDOaRHInLxPJwZwv1xndjvD3ThNil5jBOtLXGEAYdr8ORuStRJCJ5hDdDLrGqcxpij3q99PCzmnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADDg5sft; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADDg5sft"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-69b514d3cf4so40884766d6.0
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808550; x=1714413350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3INCrv7e7B0S7RrzY1Pe+/zOcufkOVO/a3OCAO+sUo=;
        b=ADDg5sftRcvOU4DvN//1iW6Zf4rJBWtLbdi98KA8Qw/sWarRNX3tdw9ro8DkHesaBE
         dzLmfC0/Faah1qWVXhKKqmm8S2L/L5sIrJTVDd1UN5qANG+cO+C8vMIggHChlTHZEf8y
         nbC9TIhfHI0f/cGp8tD8pojWrD3L3243M+e+i2UUlunmu8KCwTCfBCadb5hxJimDMzHq
         qWvroCbb8A94FWZHJhVU2O4gEmQrUrYvE1Fks+lqeNCCY9gSi8Jv3h9LbRpBlKDVRfDC
         6lSh/Hw9t5VTq89TXF+Nua+5VDrgJg3jrHtTidQGWZC0wx0TRQxJvwtM1vEbNRbJMNQW
         zl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808550; x=1714413350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D3INCrv7e7B0S7RrzY1Pe+/zOcufkOVO/a3OCAO+sUo=;
        b=klcqdKZ4Y7ffZ8lK3+lS0BN83ghRxMAmGo9GBzAbPyawkER/eDb/Kk6J13m5h1SNlh
         d6d0Rd5y9IAIK++b5KW9gZ3z18SsPxZyHp5O1XCzARDJAEzm8SOpKZrznhIOwYpChNIy
         vQgyBNgJNsWvymjsIfFjavfe7Rf+klVchWncVk3AsSh7UZOgEaB5+YDwHVTvuZ9YWM6V
         E2IyRsynZpmmGIl/kiXV3F+YVQ9i6clOdPYzPOEmvx6eeVcXJ08BDONoy519NaDDg8h3
         Qy/TMmqUCNEBCtEhsFtEq9TCoUG53j7oPWdN1JBejWV1ADx8qCa1HbrzFvpGlUL1RFgo
         ONIg==
X-Forwarded-Encrypted: i=1; AJvYcCUk/+ZGUdY/KB3ZSxnmHSdu7JgMqjCWzQmSVj7ooB6s5gr5/4k710caSegx0l9erOCymgZnPC3ruH9lDTPY8Z3oWAdy
X-Gm-Message-State: AOJu0YxK+9HtXKE8U2TuZiyGidG5WYoCRoDDif7PpMfdumjeCuf5EanN
	qOeqs8n6y6WDg5SbVxCFvojUIUg5KOGMC7wGMzIjMCQ2UykqU2YXZ1LsWw==
X-Google-Smtp-Source: AGHT+IEQlxDWk2AlhQx9+b/dWn41f12vMP3s2TSJFYdRD5lWeAFLyHMalAMXR31Koz3wQN4PSP8XMg==
X-Received: by 2002:ad4:59c4:0:b0:696:7597:5141 with SMTP id el4-20020ad459c4000000b0069675975141mr13159688qvb.56.1713808550467;
        Mon, 22 Apr 2024 10:55:50 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:49 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 7/9] dataplacement: add a debug print for IOs
Date: Mon, 22 Apr 2024 13:49:53 -0400
Message-ID: <20240422175522.4614-8-vincent.fu@samsung.com>
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

This is useful for testing.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 dataplacement.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dataplacement.c b/dataplacement.c
index a409b825..1d5b21ed 100644
--- a/dataplacement.c
+++ b/dataplacement.c
@@ -145,4 +145,5 @@ void dp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 
 	io_u->dtype = td->o.dp_type == FIO_DP_FDP ? FDP_DIR_DTYPE : STREAMS_DIR_DTYPE;
 	io_u->dspec = dspec;
+	dprint(FD_IO, "dtype set to 0x%x, dspec set to 0x%x\n", io_u->dtype, io_u->dspec);
 }
-- 
2.43.0

