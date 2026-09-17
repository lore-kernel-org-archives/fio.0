Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B82547057
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789678581; cv=none; b=kcuW/2b2UeKkbLRotSXZiuMDAowyNmTIl7xUuJ1lo02GClcJPRv5loSvU+2Kqk9w3P01H6Fk5loG7fLcqVOHfmx6Ps/PVK+GMRVI8417VopOVnAH8+7mMwTn26uue1DyxEJj0tdVYPINIh/gKuIojAlDCgCw2bihZaU5mBQKgVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789678581; c=relaxed/simple;
	bh=LZePaUlyxmDHvUtFEM9erRBpHtz7IP/ynr7tZYxcYyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aOIWcfGgGWUELaH2jyttL4m07xEPkZnJTl9u7vUeabgoK8iDZWPKMxM2tU1ql2Jfn+JHBVbiGj49gGTFOCdDQFGQ47CJQLhtmy9RjcBnNX0JWE1SsoAyDIdW4mMFX6XFVJSwMELIRisUknOa/Zi3LvjQkQIe6pDwJgaOEtc//cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uho6yGRB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmv0qTXG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uho6yGRB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmv0qTXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789678578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Va5MyqypeBE3GBZ8fZt9hem5/FqUpuqKm21jWrl4gh0=;
	b=Uho6yGRBq9akmXRuAlaU32WY+yr4dLqbUS1ztAbUCwF8Jw0+F/H3CHaQ3LMJ4I8VpV1iQ5
	/RTryVtysNr7jPtK3yp6rYxjhTjycCORTlyYQUFJ4X/5kZDkfyRfkh4UYW2XQRd0YWe8UQ
	524bdTs6Vn9XbOTRi4UK5O5lhQNUImg=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-WRbh8w57ND2ET2O-2HZtZA-1; Thu, 17 Sep 2026 16:56:17 -0400
X-MC-Unique: WRbh8w57ND2ET2O-2HZtZA-1
X-Mimecast-MFC-AGG-ID: WRbh8w57ND2ET2O-2HZtZA_1789678577
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-806ef75f2ceso21417a34.0
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789678577; x=1790283377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Va5MyqypeBE3GBZ8fZt9hem5/FqUpuqKm21jWrl4gh0=;
        b=cmv0qTXG0YmAv+fHsz68HmG+4CAeskDB9jeiqIuIMX3Di9sU3QkSgQaYjizAbPsjbs
         +rBP5Y9euXgeRHAacNyePPoeFhM9tgdMOWP5Z2+/lH278gJXmij2MgwrPa73f8ut4FaN
         vOC50x2M0sVebBrG+UjPtemNwsBTf4ZHn9IAdO+P+JV1d/xrYWclAYxkdU5CQjTwFGtn
         lcT5Hk8ANVYVb914R2f6ARqp4RDWBklXfvYQREdx6HJq7ytQulimeiSAN5/74u8x2Wvl
         aoG5yW9YOquX/bJBIAqEsH0+Ym03+1mYNrEcls9fFBNaINo3/+gVt8/D+T/5C/wvnWYJ
         iLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789678577; x=1790283377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Va5MyqypeBE3GBZ8fZt9hem5/FqUpuqKm21jWrl4gh0=;
        b=ypaH/Z0HbLc3qjWl/cIugcFQQF97SHt1lL2NRFAYvMpbuOG73dzRg6HIU0Lwk06UWb
         qW5VoDvyau95jbp1pNpEuNsGnt9IPCjzpPoysY3ijTdN/fKS1rooJDcIju7UVbshPLMF
         zPuvYidRdS+HW3l4ZxU7ZwkcMjyko3Cg/+fHdXPb9Wfd6p/T7KIYRtAMMR4S0nxtTdHe
         214uY7BiEurY1S3Y5aVL98m88j5IZvZQpcPeAaQ1H11ogrp0rxsiqXugvMSE2HwRj46M
         ziCN7wb2pFkGajCFyyYPQoR95mLs1OOPOU4HvlCy4KN4rdUJzdtg9nQ05AETiV8Vb7SY
         peKw==
X-Gm-Message-State: AFuF++kect6lmfGUxLOARRUyXkSWUKwKYdEXbz4ZL+V8IYGq92sZVKKX
	KGsgNqgiJsQnUVeC73iCETqAz2AK3Hao9jtvYMZCn/T+sIq23jK8k7g11rFtwGpKP8oMXDOaXgo
	D96iEJgQvl/3sN/Bs85dXgYyXQNJQjbyntMyijN48M5qwr9ry0iOO20j+f2HkLGWerfmKE6y0ap
	PMkaox5I2SQMKKR2IujhCLjP8Cvyj4d7bWsM2etXo=
X-Gm-Gg: AYBFou1BOBdqr4Er5b5UMS8QnBLN7T89JVpFAYmKbQiZedKcq+/CrIQ6JRn2D+NpDgd
	YTmTmBtVbtwX7N8HarfyecVjGrdG2iC/Wnp2/UrbWtTXYBr9wW0HFam64FmffD8rh3KfEb0jFIc
	FgSHLNe/z0d8wEMk2eJbHqFkqZxv3n2aGSAlM8+KDwVAi7lDowUvq/6UVKZaoZhCmXYG0BmpiJf
	xU3h4bD4BerkkWpiv0vNDY774h6KcEbMNnpv+nKjBF0pi2RPo38uG7yWLeNBqMpN2ryTpZ7f2Aa
	2ilkjUwJIpLg4ZvaiXnAqiUIZ3eFKRGDCSo/SIcR3Nv00NTu+7hr45yUrdC8WcanvyE7VDmSBFp
	Y//OHRVYyja85fqYKbu8Ias49kygZDoQFZLFtmQ==
X-Received: by 2002:a05:6830:83bc:b0:807:7a6f:386a with SMTP id 46e09a7af769-80de1db1f27mr433282a34.19.1789678576747;
        Thu, 17 Sep 2026 13:56:16 -0700 (PDT)
X-Received: by 2002:a05:6830:83bc:b0:807:7a6f:386a with SMTP id 46e09a7af769-80de1db1f27mr433252a34.19.1789678576221;
        Thu, 17 Sep 2026 13:56:16 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c46dbacc7sm3917208a34.17.2026.09.17.13.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 13:56:15 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] client: don't send uninitialized data in fio_send_file error replies
Date: Thu, 17 Sep 2026 15:55:53 -0500
Message-ID: <20260917205554.2281093-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various error cases in fio_send_file() might send an uninitialized
buffer over the wire. The server should ignore this when errno is set,
but it's best practice to not ship heap data over the wire, so fix that
by:

- using calloc vs malloc in the initial allocation so that early error
  paths send initialized data.

- grow the buffer via realloc only after open() succeeds, so that an
  open() failure doesn't send a grown/uninit buffer back with the error.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 client.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/client.c b/client.c
index 374a744a..c1d80783 100644
--- a/client.c
+++ b/client.c
@@ -1807,7 +1807,7 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
 	int fd;
 
 	size = sizeof(*rep);
-	rep = malloc(size);
+	rep = calloc(1, size);
 
 	if (stat((char *)pdu->path, &sb) < 0) {
 fail:
@@ -1817,14 +1817,14 @@ fail:
 		return 1;
 	}
 
-	size += sb.st_size;
-	rep = realloc(rep, size);
-	rep->size = cpu_to_le32((uint32_t) sb.st_size);
-
 	fd = open((char *)pdu->path, O_RDONLY);
 	if (fd == -1 )
 		goto fail;
 
+	size += sb.st_size;
+	rep = realloc(rep, size);
+	rep->size = cpu_to_le32((uint32_t) sb.st_size);
+
 	rep->error = read_data(fd, &rep->data, sb.st_size);
 	sendfile_reply(client->fd, rep, size, tag);
 	free(rep);
-- 
2.55.0

