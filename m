Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415083DAAA9
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789674436; cv=none; b=bp8HtAX8JEfMme3SpXeZ+k3QM7Tjvqt87nZ+3/t8gQVDgpTKYVRt0Gxgcp22LN5P5AsBx92RvUZ/m1coxACr9wn2/3+JbKBn/RkDezHh2TKhQ5BX7wFWR7Z9El6gHEHK+2GbfTuM2C3zef2/A9RJIWslJnDReeMnglUK3Wql05U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789674436; c=relaxed/simple;
	bh=5BABXhXMY1Au6pTDI6RNPifFa/YdLCfA+lL6CRbbHYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJyav/6q8UzUyaS02piLoprUJdLTG/edqdyeph0WD3aFS15EAjaR04oLcPkDk/XWvk7jd5QpiaLS8PZZ5LFEcfPgr4lTb0ybW4c8A8zXUFS2Hn8vLyw+y2rS6KVugLidH9x5SdgWG2pYfRCkxNvYJf6yaazqVVzpJhogi/wHcoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZZ0I0ay; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkKrTHYj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZZ0I0ay";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkKrTHYj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789674432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AmD6IivbXNuko7JZJ+kAGFYmYIHAMKkObBOZgKT7+EQ=;
	b=MZZ0I0ayigYf1fLMgNvqjgkU2zngszqmr7GZWg35ooQn3qskwIx5fhNKmUIKboLtesGIEw
	QkWcZBwtn0UZVc4Bk3kFKpLDEOOJm1SBh/QRB7qEGC8pU9vaoYGzhgjsU21pNKQ4G+iK/i
	DkbKMZaekmdOHpy2Is2Xj17NHAWL6tQ=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-SGXU6LW6NsmhJUjN_O41Vw-1; Thu, 17 Sep 2026 15:47:11 -0400
X-MC-Unique: SGXU6LW6NsmhJUjN_O41Vw-1
X-Mimecast-MFC-AGG-ID: SGXU6LW6NsmhJUjN_O41Vw_1789674431
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-80d221f75caso755445a34.2
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789674431; x=1790279231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AmD6IivbXNuko7JZJ+kAGFYmYIHAMKkObBOZgKT7+EQ=;
        b=BkKrTHYjdhmn2Cv6CbcHbLYfF3A36aBZ3oKw8EQSm24H7Kx/TFE/Ejkjup7ryPnshh
         I7bwqeXQBJxABaMLnV6kELhIutF+IXg2OLPiHyBG+uQbRecfb37zuVesqIUcY+cOTUhS
         hdLoaguAyf5vcjReZnkc+IVW5IgnlfHynyA71eJ7ulgicCKupZqTpD8m0WGvqefLskqf
         MPXvYiE6YwuiqrYg5KXq8P17yVq8UUN66xb5BrWF3nRUPr+MSdVG8ni/tEg2cyfnSrGL
         kbPdtRFLLh4MDkRe3YTxCsdxm2YM+ADYebE15es3YzhsXvS2uAhFlbXrPtjRDPy/PAVG
         rIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789674431; x=1790279231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AmD6IivbXNuko7JZJ+kAGFYmYIHAMKkObBOZgKT7+EQ=;
        b=sFXYKEEQcNNxTb65PdSmxuucqYpeL0Ny9A26bQu+0Xvk6Rrj1mM1wA3N+V+gyfWohJ
         58euKJNE0B+I4+5wvJi2/hAXBZMqMHOVIT991h4ZuNQVMIypRl18An8c/BWsiRKxHaRy
         BcvG7J3OanuMHkaA151NjLqMdjvw4Cky/WBIO5mJO3Ul0uaXuvthlqJ5fWozR1p0GMSF
         vGLcwqs7iRfI940pCHAl+D663kmIU7ZmkQOM5PQXrxztchT/Pj3EZvNgsM+5zFF0W0D/
         DnY5CV2uODE7B1z7wUM8Z94HbxoQFp9rzv0wURaQlQ2srM9iCpXLiyeRYyG6G/v7xlaj
         KqWw==
X-Gm-Message-State: AFuF++mAF4w5u7WQ4bcUYEM6qzd/u9sMl7e3BJMms8xDoMfIcWQBUUc8
	0fIaJ1n9P5H4Bm1ssr7GkxGClStZx4zbuFLkDe430TkuPoZUjSv4ooRkj3gFtNw+aDypp2j7dab
	0fafh4kxjx4jXCzvv/fHhUjpH/OBxdY3TlC+p/t40x5usChTVcPWgbBHKiIt+08tsfo64Mrx1IP
	AmDf4AvBKwY+vmsApw3FpYqU+I7GMOehONkxcErXI=
X-Gm-Gg: AYBFou1jKs1lbnTT3yfjbrWknOO9Ba8BQJN+zw1QJZUseHDDVXDNLE0BtDT/Fqf54A9
	Jq8pNfoCCvAHKfkVap2YNIUmllCoNLVTRskoS7dpCtbWxUQoIDAA2hqYVrjb5WA4LQ8ydbdeWco
	uINNm4lamh5jGxIcpwE2CmQBibCCjU8SvAp1AknBhczxrpyil7NQXPx02Ikkb33tp1gbZSL1MVm
	01iGBIGvihvKrwtNTUsVxscBfdueBQam4IKHMzv2bZW8rgmnGkTWJyAURSiJWQx6dpOI72HKBPi
	LvHTeBgPkKMhFY1NuaO1kqGBYyunnDIDBMxemIgi29fuRpoNaWYCHIf1l8IkE5V0Vht2vcFjw6E
	HvCoJKJlN3jDFb9hi8VHcIRWBMtGpvzZkq+p8ew==
X-Received: by 2002:a05:6830:44a2:b0:7f4:eb76:8820 with SMTP id 46e09a7af769-80de0f628eamr206930a34.13.1789674430782;
        Thu, 17 Sep 2026 12:47:10 -0700 (PDT)
X-Received: by 2002:a05:6830:44a2:b0:7f4:eb76:8820 with SMTP id 46e09a7af769-80de0f628eamr206913a34.13.1789674430307;
        Thu, 17 Sep 2026 12:47:10 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a2e63sm3828886a34.15.2026.09.17.12.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:47:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] client: don't send uninitialized data in fio_send_file error replies
Date: Thu, 17 Sep 2026 14:41:25 -0500
Message-ID: <20260917194706.2264798-3-sandeen@redhat.com>
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
 client.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/client.c b/client.c
index b32c2852..a949b5a3 100644
--- a/client.c
+++ b/client.c
@@ -1807,7 +1807,7 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
 	int fd;
 
 	size = sizeof(*rep);
-	rep = malloc(size);
+	rep = calloc(1, size);
 
 	/* Sanitize requested path to reject files not under cwd */
 	if (pdu->path[0] == '/' ||
@@ -1823,16 +1823,15 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
 		goto fail;
 	}
 
-	size += sb.st_size;
-	rep = realloc(rep, size);
-	rep->size = cpu_to_le32((uint32_t) sb.st_size);
-
 	fd = open((char *)pdu->path, O_RDONLY);
 	if (fd == -1) {
 		rep->error = errno;
 		goto fail;
 	}
 
+	size += sb.st_size;
+	rep = realloc(rep, size);
+	rep->size = cpu_to_le32((uint32_t) sb.st_size);
 	rep->error = read_data(fd, &rep->data, sb.st_size);
 	sendfile_reply(client->fd, rep, size, tag);
 	free(rep);
-- 
2.55.0

