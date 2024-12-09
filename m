Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05815AD9C
	for <fio@vger.kernel.org>; Mon,  9 Dec 2024 05:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733723297; cv=none; b=a7YwfvYHmhQBE7TM+WU9Q0boLzx6EdWYTaX6abYGC+X3d6fdcVYeqEWIWB6rvHmww4f9YrZi3T7dDdi9UjTklAhQDrHAchHcD5LwE+hFO3WqTyFV+J5bDPlU+aQ+Rt4ywYekigc6azvhAzz4kQe5wjME5P1b/796WLMbIAd1R4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733723297; c=relaxed/simple;
	bh=NYFlHIefL8slMLSCnJJI2oB+yQ91r3NeCwRXeD2j4wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZNDB9lz2R18iTvNJtfXM/zjvYw7fqlNhwJvag2cPc9xV9vOHfeWeO96J/IfwvIzoWSh0kE/SOG4I1PHwuWcp5fPf5sDEnei4sUahtpOtiHKcgZ8l/8kO30KcTL3HS4BFcTZ2YDHAtbRZOI8kBbcT+c88SG5lNMHVKKKFDN3OmM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGuug55R; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGuug55R"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21644aca3a0so7554935ad.3
        for <fio@vger.kernel.org>; Sun, 08 Dec 2024 21:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733723294; x=1734328094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fUNtUJvF1U3uWSg72Tl55idIZrSLRGQk/ire5gIcjvE=;
        b=lGuug55RtKVUCOO1XsTNsp1zeX84SGv5Fd16LpEYcC3jtcQ+1kzSGUW0zs2fl935SE
         bXe40Ti2eMZc2cZNdD7WxjQ8H5N6TgCbLVcNWvjP4wf6lFD+Hs2NzVSw7Ad3OsuVk58e
         lhxSjdhH/FxNO44Am6Zw4wPYy4CSjAuMoT1A0r5142X1WCI5BejOZmDGPRCzmV/fkLD2
         miisyQ6kDsAA+U0dUfDdExT4EmEpJRmIUOTvbpF1H5kz299LelPEMV7xL+oTtA4blzVd
         uksrJnXXqx3S52SvEb8+JwGCInKTERxFQQkYT4xv1+92bIqx7PBSwiTkUxzYwsuJMuH9
         Iyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733723294; x=1734328094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUNtUJvF1U3uWSg72Tl55idIZrSLRGQk/ire5gIcjvE=;
        b=OqXJ58mMGojKzt4z5TJGz900TEbu6XjY7ZltonWISt5ov/EsNUo3uAGxOwPU4/3mR3
         63BoPTOMOsDC4MeVtWZeAHcxAqM7YyXsjY+PGHa9f/dr+zsKbFsDd4xDi9nSmUCdznra
         tz22LQBRy5UByUeFRuVAlpqRy6d44oY2wmr461XLJVs+RhvgTcVOGoZNTtSK/4F4Yqq5
         8iPMFnCtsoG2jElp9BU0534Lx7oiEyCfUlwPrlmpvDYmLOHMyV+LjVd30mD0ibW98wlW
         dCpYjf3QTVQRnn7W9cTOQQ+kdHUiKs4S2PawgOgxrroFQHgIEIv1wLBADTkBdX70OFWD
         5h6Q==
X-Gm-Message-State: AOJu0YyfbUAiW1mR96JHs8uPi7fbTH6IAoDwyzgxoWn6HPLPMxh7LNqj
	s9k4tRaicmMUAsDp7IlWxzvrl58mNqx8Ge26FVRH0CwW3cxXXn4AaDn1Mg==
X-Gm-Gg: ASbGncs0IfQ9kMmcyYu2KrsCE3oTepRrcJInRnCcaYC9F30augl3RM7TLEUasWwefpU
	uaBCabSsN2Q6qoQezRg3/GkCpMY6JPuMPMJpNncWQRCLewt1v/GOdE3uzydZ9toObpdLQyp6CNX
	u8ekidNyaNuMxFIUTygu32tOEdV1E03ALHNi5jCuwZaKSqXXoifl4bo4wTIFqkFpoDgq1zfYyB8
	t1IbBV5OJluYOkXLoxNR9gphQH2vLdFL/H/tgfBdUBiQp7Xi6QpVWBB5wfcz3qNa6KX
X-Google-Smtp-Source: AGHT+IF+yWK9JN6AyF1WgSAKnm+WbHl8bcOSINDs5y6mjy0+fPr4Hh6iKCv/dw82KNpeqWtkPCZ8Ow==
X-Received: by 2002:a17:902:e741:b0:216:501e:e30e with SMTP id d9443c01a7336-216501ee90amr39604885ad.35.1733723294402;
        Sun, 08 Dec 2024 21:48:14 -0800 (PST)
Received: from localhost.localdomain ([180.216.6.175])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm28576475ad.197.2024.12.08.21.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2024 21:48:13 -0800 (PST)
From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: fio@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH] nfs: add support for new libnfs API
Date: Mon,  9 Dec 2024 15:47:58 +1000
Message-ID: <20241209054758.3269700-1-ronniesahlberg@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New update of libnfs will have a new API that changes some signatures,
primarily in order to make nfs_[p]read[_async] calls
zero-copy in the sense that (almost) no data copy is done in the library
and READ3/READ4 payloads are read straigth from the socket into the
application buffer.

In-library zero-copy only works for !krb5 and !tls sessions but can provide
significant boost for read-intensive workloads when can be used.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
 engines/nfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/engines/nfs.c b/engines/nfs.c
index 6bc4af1f..13b55038 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -157,16 +157,28 @@ static int queue_write(struct fio_libnfs_options *o, struct io_u *io_u)
 {
 	struct nfs_data *nfs_data = io_u->engine_data;
 
+#ifdef LIBNFS_API_V2
+	return nfs_pwrite_async(o->context, nfs_data->nfsfh,
+				io_u->buf, io_u->buflen, io_u->offset,
+				nfs_callback, io_u);
+#else
 	return nfs_pwrite_async(o->context, nfs_data->nfsfh, io_u->offset,
 				io_u->buflen, io_u->buf, nfs_callback, io_u);
+#endif
 }
 
 static int queue_read(struct fio_libnfs_options *o, struct io_u *io_u)
 {
 	struct nfs_data *nfs_data = io_u->engine_data;
 
+#ifdef LIBNFS_API_V2
+	return nfs_pread_async(o->context, nfs_data->nfsfh,
+				io_u->buf, io_u->buflen, io_u->offset,
+				nfs_callback, io_u);
+#else
 	return nfs_pread_async(o->context, nfs_data->nfsfh, io_u->offset,
 				io_u->buflen, nfs_callback, io_u);
+#endif
 }
 
 static enum fio_q_status fio_libnfs_queue(struct thread_data *td,
-- 
2.47.1

