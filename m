Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EA43CB54B
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 19:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789674435; cv=none; b=Iu1a857UZHPnvsCk7vpeP+4OaJmAiCct7FxNzc/5rYG9IxJkBDl0C36gqxVh8OBtwRzU1sGDNuCTbwwwpaOh1nsdJS1MfvN4nN18ZNiWeKLK1i3hj9SE7rqx0gYp+5GQ1bdjTK4zbYHdUdauFocicQTcuYqcWRQMAzT0ACODKq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789674435; c=relaxed/simple;
	bh=vNqR2N8BGQY8VjIr9fN/GnTRaqBQM0/r7YWVqcgWnl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peV1Mfc3ddUwUzi5eQaWA9FMO0eefaaPKabA5g9UnzCSYPCjyNO953aDfzGyzrxykQ3V9bf3EYrKdcNsoNoJKsP9WFh070SMWrr4l7AF4gzAxjDApSnHQbDqgRjYqEW6jS3VzFNTs4L458hZRqIG9mMWrt/IRIFdLGSh54vpht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LYgRD+X8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcOQHsTp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LYgRD+X8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcOQHsTp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789674431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xQwLpZapeKZc0YivS+3FJkcLHUcnZmNfsqMY0v94aSI=;
	b=LYgRD+X8uBVZXMnRGpNJoc5vSrDyIQoOXBlGlfB9EhB/K5nAO2dz/3yp3c1yU2FdzAkIbS
	LP2weBmmMtetI0bnUsXfTjSlDlRTXagWRm16L5yoqDM9xTGMGbOzpRhbHLWwGcb5y6JuFK
	YQfGcCwRdSPtGbB4/iou7Jy8tIf8D/g=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-5X_5l-ixMp-CX9A4SDeukA-1; Thu, 17 Sep 2026 15:47:10 -0400
X-MC-Unique: 5X_5l-ixMp-CX9A4SDeukA-1
X-Mimecast-MFC-AGG-ID: 5X_5l-ixMp-CX9A4SDeukA_1789674430
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-80139a2495aso2045611a34.3
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 12:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789674430; x=1790279230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xQwLpZapeKZc0YivS+3FJkcLHUcnZmNfsqMY0v94aSI=;
        b=OcOQHsTpsf3jG+zEVTNGcbuQEy1LUInfjDes/l5hPEJlj/dok2PeVEzqOrIWPlUNnC
         K4BKWcP6SU+CPa7NLa2UqfTPJe0EnmWFBxxTmez+MHt1UXSlbGyuej9G82KqlxwdU1Kz
         l8pxARK5/cjifNCL7RN4n0HKcWQXHWNCnAa4CJw2cf0JlDisgaXBxkq1U9ldsLa8c1AB
         wIclGC3G81kH93Rn6lhBqPKjCXst2mpfKVONWBuVzSlYly8zLqQ+7TD8HWjl771qLgYd
         7HABLymW9ntr8AJSWDRSdFYSpvHZe+HIOn61w4SOKhI+KmEI6WdCPgidpKks+YSXnaFs
         5X9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789674430; x=1790279230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xQwLpZapeKZc0YivS+3FJkcLHUcnZmNfsqMY0v94aSI=;
        b=s93FCJtI/clNWZmIxPC9Z9gNgmPEavK5GX3ZKWvjuswxx6yHNi9WZnVzomnTRBIWy8
         IC6VeYyjIYsIFKtw1fWO9mjzDFtoMVy0B3c1e87hfqpTx2Mh70BrSvnalP3rZxqvc//P
         0KwFsNmk4TBo3E5CmdnFf9hlv3QyV6mDnDnWReWlVh1df1YCTqEshpYN42v0lcXUzIaI
         S/5x5G+lRsvPdi4++1dHPCY0cv5QBzeNBpRVunru5+TZyEpnAK2Eb92/RX32s9I0TnVP
         OiLQbjUwzpUx1mQrx4h91FmFMaH9gFlnvStP4GovBmSkztFUSrZztpQikdOX+iNuMMdj
         uJeg==
X-Gm-Message-State: AFuF++kDoHnnwZFHMGoMb8W3x9LftHN/ys0yttT2s7hY4O48mkHSosmx
	RnFDWZRo7rXJhwWVG1YBw+x5jPibVYNpcrFxG1QqoztLn3XhfHPNWrvyizmO2+6HbdzKXZYK2f9
	miMcNNAm1FVrsP2i1PB+/vyKZmozHV+hF6B2ew0Hs3Q/UNny4Bb4PrzG+jOThYFnILlcTef1ldb
	e7i7vNqv1O4bU5cgooZWGhJ9dKJbKKwJmFUJ4Y0wM=
X-Gm-Gg: AYBFou2d0pNKcPZwk2vHXAJBXsZ/fM7De5RczQmU6f9tuJaxM7DqmZ/oWbEo17Lf1aC
	8XkjgywgWTqWJIyx5+gxL17t4IYXbxckFDaKdtoDz5s9m/Lf16s7Lo55FRoU4jfxq5Va+h9o6xx
	3DXfXbRz8ntyJOznTIIGUFkQDnSTR2IgvSIenuKv8kp+JWRvZMPajIQh5Q002ugHl+AZIGaYm4o
	32mATos8EUJfUiq2AXcQTqbM1btYyKRoCmTsWPRYtS11qdp9XgIU3vggRcaECyfT2PpMEbdrsyP
	IBf24ptLLZNAK/jJ1VzgGrAiOuQcPK0+sjwbNP33OInNwTVlFjBw575iS295e9XcUDqqn8Vg7NB
	Zi9HmWMhEebXsufL29eEQMyDl53NAmk8fHGgKQQ==
X-Received: by 2002:a05:6830:610f:b0:806:e047:cd7d with SMTP id 46e09a7af769-80de045b1d3mr225429a34.7.1789674429752;
        Thu, 17 Sep 2026 12:47:09 -0700 (PDT)
X-Received: by 2002:a05:6830:610f:b0:806:e047:cd7d with SMTP id 46e09a7af769-80de045b1d3mr225388a34.7.1789674429191;
        Thu, 17 Sep 2026 12:47:09 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a2e63sm3828886a34.15.2026.09.17.12.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:47:08 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] client: sanitize FIO_NET_CMD_SENDFILE requests
Date: Thu, 17 Sep 2026 14:41:24 -0500
Message-ID: <20260917194706.2264798-2-sandeen@redhat.com>
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

A legitimate fio server should only be requesting files from the
client's cwd; reject absolute paths or any paths above the cwd.

Since this adds yet another failure mode, move fail: to the end of
the function as is a bit more typical for a goto fail;

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 client.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/client.c b/client.c
index 374a744a..b32c2852 100644
--- a/client.c
+++ b/client.c
@@ -1809,12 +1809,18 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
 	size = sizeof(*rep);
 	rep = malloc(size);
 
+	/* Sanitize requested path to reject files not under cwd */
+	if (pdu->path[0] == '/' ||
+	    strstr((const char *)pdu->path, "..") != NULL) {
+		log_err("fio: rejecting sendfile request for unsafe path: %s\n",
+			(const char *)pdu->path);
+		rep->error = EPERM;
+		goto fail;
+	}
+
 	if (stat((char *)pdu->path, &sb) < 0) {
-fail:
 		rep->error = errno;
-		sendfile_reply(client->fd, rep, size, tag);
-		free(rep);
-		return 1;
+		goto fail;
 	}
 
 	size += sb.st_size;
@@ -1822,14 +1828,21 @@ fail:
 	rep->size = cpu_to_le32((uint32_t) sb.st_size);
 
 	fd = open((char *)pdu->path, O_RDONLY);
-	if (fd == -1 )
+	if (fd == -1) {
+		rep->error = errno;
 		goto fail;
+	}
 
 	rep->error = read_data(fd, &rep->data, sb.st_size);
 	sendfile_reply(client->fd, rep, size, tag);
 	free(rep);
 	close(fd);
 	return 0;
+
+fail:
+	sendfile_reply(client->fd, rep, size, tag);
+	free(rep);
+	return 1;
 }
 
 int fio_handle_client(struct fio_client *client)
-- 
2.55.0

