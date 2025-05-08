Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD7D2882BA
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730750; cv=none; b=XpyRBTuTF6WOSFl2lLEptjJix3vHogCCbpI2bmOZhm3uM5pz1vs8C+hbEzMUmnY9OIYvUiQjdSfXSWQ0iJiLxog2ZpUjifJ2gqu3genZrOzZx4T8sEqtjwhmFNsxP8X7nRDxva02fQjeZ4HNo8jQpY1NUDuWjxl6xUNSXSPdY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730750; c=relaxed/simple;
	bh=rBYwTwtY3+uwNsMB7zorVq4nAXDKR9c+JDnwBVzROvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJyDuQQjD+w29L3izpjj9jdlKRjgZCb0OAu8wzKZX/d75qYslmYnHvAgtftmTz6Z/GpQEOb0b3kfcXOft4GtCmzEwXOKjn1fhNV6QFQwpKExv+2aTIaEsD5Lmrv+VPhTAK6RNvMCnZP6LFR3Xdu71Mb68zb4wVSayGgnIdKH170=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GloXUWO2; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GloXUWO2"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7cad57f88eeso89769285a.2
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730747; x=1747335547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZK8y+/s7L1guBbqzb6nFHB5CZm9NxpDnV859BFmo6YQ=;
        b=GloXUWO2g9Hr0jPn1ss/vpxQbL+mMbKUgkwHyfoJsp+dmT13Nvhh8g7ESpODo1HQNi
         kkRwcO1GOumbVv/q8jDssGwZU2jXVdJ+Yw+5WrCiTj9KKzrQVPMDb1AaG3zrli09bFMI
         ULAD+76SfkJEzjHFFNJkvEK1aj+fP3jT6S2P+zddHLNIqCGP56rwpKrSjaBAa7CHr4/r
         q9x+ho7PgmQDSpWySGUhChv3879rJYd+blK5KfNTREc5PptCF91IRnN3aNYCkw7s5/GK
         vbeS8603xJHzY/sjUmS9UY6tIIEAtseZAozrCs7DA9Q1xOggojg864e0AATAXKNA6kxV
         DxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730747; x=1747335547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZK8y+/s7L1guBbqzb6nFHB5CZm9NxpDnV859BFmo6YQ=;
        b=PzKPN/tOOpjPgE1CvTauh+l5AeNXPZpY2O87nWnikB8mV6SqkmjyglUPSyVcgX69N5
         sG3VZlC74cHCB78l+njzHPZMnqGRQyJKz50Y2jSemXH6gc51qq+BGtajYpmliZJN1FnE
         j/FOwXcY8uBFR8Vv46jcyw3derAe0TzgiLeIJ2qSCuvch0u8TovhiKN9IPzjzzv32Jx5
         6mDNr9z0YKskyEwQ0pkL69CGJEi1oyUiZDS94U5VaDPv23NelF+iv+d1roL+N5VSpDGz
         kF4ZDpKRP0+AzVMs8ZQ6NwpateYQAF5Eb1aKWIzqOZuQgPy+PBhTnL2oQvwqvDU+2OZP
         ldLw==
X-Gm-Message-State: AOJu0YxHsmnyMDYrghsxug9JaPAnC7wtm05eqb1ZfQN7tgEcUgmkVsEK
	iffk7LgUxwwqsVW6Ge9QWHY/4LH2xDxUoXZXhH2LhkQlf+fAwhFA09nmYOrD
X-Gm-Gg: ASbGncuUtxEdos8Nh0sfS8Ki4z37LYm7GjRmnC1NHqlkJmmGDkuphisDyfT4bwN1Qbx
	NgDU9MNbs5fo5P7Fsk8ezZS64JSVWJ8oQdRSKMyrpbIYIb+S7W1MdKTAL34WCWvJFySi95T/Dpe
	UnvTP55i1/PnQsqg3fdWMd0rwCPF1Y9p+3kZQtNk1iYeTkzntLrehlKgtZfgi8D+8TI1QRReOKG
	5m1o87Wp90+wudJKtrfHxR8GXUChwMB8hKyKYZBST+CajuhHY6HJVBOqpqMsQ2yuwpRDc4QWvyT
	DyS5I53P0Vv3EjHj5nZEw3HeRlx7N0ah1VHGA5Kb1XY7ZCkhQt2JoevmjMDy6viHlphAooh/oce
	NwWC1mEluXDZLjTBqp+ytfu546W7Kgg==
X-Google-Smtp-Source: AGHT+IG2Oz6+mNVCnST4GLkL+MIC6w2yi+d+RqudFuxzLeLgiyukmfnkHoUROkHd0O+YX2uhb7LdwQ==
X-Received: by 2002:a05:620a:4552:b0:7cd:25:8a77 with SMTP id af79cd13be357-7cd010d0ffamr136615485a.9.1746730746645;
        Thu, 08 May 2025 11:59:06 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:04 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 04/11] verify: omit verify type mismatch error message for pattern verify
Date: Thu,  8 May 2025 14:58:12 -0400
Message-ID: <20250508185832.3702-5-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508185832.3702-1-vincent.fu@samsung.com>
References: <20250508185832.3702-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we are carrying out pattern verification without a header we should
not print out an error message about a verify type mismatch because
there is no header on the media specifying the verify type.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/verify.c b/verify.c
index c90c008c..cffe5999 100644
--- a/verify.c
+++ b/verify.c
@@ -1031,7 +1031,7 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 			ret = EINVAL;
 		}
 
-		if (ret && verify_type != hdr->verify_type)
+		if (ret && verify_type != hdr->verify_type && verify_type != VERIFY_PATTERN_NO_HDR)
 			log_err("fio: verify type mismatch (%u media, %u given)\n",
 					hdr->verify_type, verify_type);
 	}
-- 
2.47.2

