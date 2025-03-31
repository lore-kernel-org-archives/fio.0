Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC571BDCF
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429757; cv=none; b=i/nQGj//+Y+FATW3wDElgR6NE2abOvMavLla7actVugWfH8jSyegyox+vHuVAl6Yl8LnJD9dlWcsGSLv1amHzqmpNIdjT/5oTnpZJkxuveo9j2unnE5+clNdxPGfE3xMUkn8Wrq70o3QDJtzzkRdr37Nrsa+gYvgOfCcqpuLklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429757; c=relaxed/simple;
	bh=2m+9c3iWEZKpJxg3vbevRePIaCo4v5S6LIa4BmYsvcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwa7o2VoU70p5faKriRGcZ9GGVI12EAjFW5UmA7hRsbCACwxu1gNUqYQX2FgW61p73XP8gfYUulJUH8oyzxnqeR1x7JeDw7TnjY6YzPCyxGPsdbgXKaRjh+H3Y5R6MqFP0s9LmWzc0OjBC4Qi45UC39xByiGlcf13FjjBbCWzDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWNmNZ+Y; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWNmNZ+Y"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6e41e17645dso43618126d6.2
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429754; x=1744034554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dX6HN9ADg6R0TFckXUXtupc0LQklfXSFOzOcMovwiVQ=;
        b=bWNmNZ+Y217AcP0m7j5MFzBUMpP+BXhjVpNH9Oh+SUnbOiNJ2J6L7+nV4oTiubb4Lu
         jDspmP1HbkiYvLS1f2kg/tu8WmIrIpZ6xwMr8olM36yUwYzVOf6L7Fz1W/DYitw9By8S
         wiGhFT+b0dEeU2mUMig08CncyKtaR+/+spqG5yyeoE/IVtrb/oHSubsskyYMwnp1wPb0
         qZ/rsOOuyCPaAjc/Rmaw99Fx4TETtko5duFA79Z4iC+PL2cm3byc7HUflEHC0lajEQ0l
         KvwxhRrlJnrPNdJdVJRWMleGCM6418uMju/V+eWjLhULITkG/FJhK1fQvrQdko2zTNgL
         FuTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429754; x=1744034554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dX6HN9ADg6R0TFckXUXtupc0LQklfXSFOzOcMovwiVQ=;
        b=v5WDXz/osYRgyG5JICXMqTCkQ66hGvx2c3VD3aWDmlWa1GfdknTtG+mhnPg6wXwiN9
         0ZJQxeCA2fZjvUDyGNq1vgvbmlVKoFkrAoA1XPW3cABkvFgxbXfYH3OyVsEn8yfUkRqf
         7HAegNClu5QjIrwmbJOMQleNjrbbSBQwiHydOSMQ/pFFQMNa9iRoNfF7Q9igY+5+C5Ja
         MNDgaFfuJ3Iyt3uxYyl+ivd7OkXM/sLpdzFSgXGC1KJrCeiM8gM2+hO1l78useKQmsU6
         LNL1H8G6zTwCwnNiHSpDO80UJwfz1aeI+jyAlY7rLNWNPTPyWVaZdPilN0V+Qh0U3P6b
         rKXw==
X-Gm-Message-State: AOJu0YyXTCI0hCKFXJ1IFohU/d6t9f2xpdJinpKFbGC/ZPdCkEuq2EoZ
	um/7BGxhD9KhGv5/q/As2H4X21KJbupTXxXpFeKIEiysbeywcKWbOT3LtA==
X-Gm-Gg: ASbGncsLLDYVklnUmzs3NDRClnLjA1E4s+FyQAQ4jLr4hbyBRXGNTrrOhrn2ZMWOAv2
	QSDlqMcSgeV0Z4ZDHcs2yZZH3/iREB0OdZEfJGZ4hu1LOSJ9VX6ei+Wq9dNdlJyQ8fHVbPvrWUA
	5G9h+47qrTTiD/BQ7ooUgOwALBnTIB6dItgRXNy+iNtE7OK7/jvhyzNJ9iH4Yu/lXtOSuod3WE4
	qZr15CsNavLcQFw9op9fy/hN3pWcZON51qkRcy8ZMakuSBHTkWlGpbuSHEeRYxtQqvJQYtXO/h6
	/S1rR/MSYVymgABFrhhG8T1xS4O3rUxiIoQzzfR8tJZZClU2+3JHefDQt5QzfPjHF0sducrDspb
	zzu46Wbi1khoedi1/H/SVK7t2UyH9qHrs5A==
X-Google-Smtp-Source: AGHT+IHrcS6fUbToARpch7cX7TznNDGD5fgsozjE3KfC55DbOLZNoq/iXVKXhAzOAK/RmaOwMYiGwQ==
X-Received: by 2002:a05:6214:f2e:b0:6e8:fabd:ddd with SMTP id 6a1803df08f44-6eed607430dmr95314546d6.1.1743429753991;
        Mon, 31 Mar 2025 07:02:33 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:32 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/7] trim_verify: include a trim panel in the output
Date: Mon, 31 Mar 2025 10:01:29 -0400
Message-ID: <20250331140204.1971-3-vincent.fu@samsung.com>
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

The trim bit in td_ddir is not set when trim_percentage/backlog is
enabled yet fio still issues trim operations. Detect these cases and
produce output describing trim operations if we issued any.

This is similar to the fix (615c794cbf851c994e94fffe8b8f565e64f137a5)
committed for verify_backlog.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 backend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index b75eea80..f2a4ad35 100644
--- a/backend.c
+++ b/backend.c
@@ -1994,7 +1994,8 @@ static void *thread_main(void *data)
 			update_runtime(td, elapsed_us, DDIR_READ);
 		if (td_write(td) && td->io_bytes[DDIR_WRITE])
 			update_runtime(td, elapsed_us, DDIR_WRITE);
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
+		if (td->io_bytes[DDIR_TRIM] && (td_trim(td) ||
+			((td->flags & TD_F_TRIM_BACKLOG) && td_write(td))))
 			update_runtime(td, elapsed_us, DDIR_TRIM);
 		fio_gettime(&td->start, NULL);
 		fio_sem_up(stat_sem);
-- 
2.47.2

