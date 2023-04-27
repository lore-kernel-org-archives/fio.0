Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8E3C77B73
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 11:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbjD0LxW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbjD0LxV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 07:53:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728F3A8
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 04:53:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b78525ac5so2178761b3a.0
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 04:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682596400; x=1685188400;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZTZmBTyl63kiNrROd7KXrRF3jsa9AaMZgV9KpeR/L3I=;
        b=1e9SjFU/inuBeWpb88/iUFKSJCt9He2EoAOSdWcj7dhz3NEekG0g5DeEWMxlE78SVL
         uhz2EtiteeTnwr7ueD/KexpqKb7dY/Bi1y9xhKHgCTc3zpYBHpH8aUAwcPikzdwYOaRB
         GR6+VAS6v8BKkDmusFgD3qAedTYkxnyJFcPvm59eKyV4psPjgNbfFl8R9siZWAXVLISx
         +1UV6NK9aPq7l6cGwVEAwWp3JByDLRmCDAp/g24fXfotsRrYmDrYzz6YELPo9zZiyJxf
         sKK8dVGlc2BjYyHfTPhA8wOrhroLVk0AzzrYLXsVz0Zrvjnc0TzitzWGd7NMO8NpHhvx
         1Z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682596400; x=1685188400;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTZmBTyl63kiNrROd7KXrRF3jsa9AaMZgV9KpeR/L3I=;
        b=P3EiEdBEMF0zoHGBMBU3AUPxe3R5OrPDkF3SXofP3qLG73w2YIZKZQYFOi2yOMKurn
         r9C+abxFme5dXa51fxnSnKbokgEhwyQ+SH8k3Djb3G/LN3MW9+/XApmheaCCFyeLptTV
         pVSEIbtOV2b08ihIzdt6IkEY+2YQwmXJzVe7CIlmNm+pf+A/miz4766c1dBkg7Uxy5TV
         RXdcXwbahSLbOJzSUqg6DqWSWrkvidafMmJ0UH2IiVJAc8wS1o8VuigLbrYEu2sxRA8A
         4Vrxui2MHA7z1N3a0MMlJ0DAzf/gSVDeYQXwc2+t9Nkw/Gon3yPYctfQDRUZX3G85/Si
         3e3w==
X-Gm-Message-State: AC+VfDwjWcjswavfTpqVfmktLL42vmyNedfuUBEAwK6ckehBCTSvRIZp
        7lwL1cM3sKMQyHmaetTEwc3clw==
X-Google-Smtp-Source: ACHHUZ44rjii0Q7m60nnTTcd0v0BHncmpdvF2TlSYL7pS7AnNT9MSkrLIebSpoHzXMi/DgmXPgCBgQ==
X-Received: by 2002:a05:6a00:2d93:b0:63d:344c:f123 with SMTP id fb19-20020a056a002d9300b0063d344cf123mr1875108pfb.1.1682596399869;
        Thu, 27 Apr 2023 04:53:19 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w132-20020a62828a000000b00639eb4480f3sm13048093pfd.76.2023.04.27.04.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 04:53:19 -0700 (PDT)
Message-ID: <cdbabe77-9b1d-c020-e7fe-528e453af002@kernel.dk>
Date:   Thu, 27 Apr 2023 05:53:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] t/io_uring: fix error handling for setup_ring
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        ankit.kumar@samsung.com, anuj1072538@gmail.com
References: <CGME20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8@epcas5p3.samsung.com>
 <20230427151004.1146679-1-anuj20.g@samsung.com>
 <4e368610-30aa-4f2a-202b-d93050ea1f02@kernel.dk>
In-Reply-To: <4e368610-30aa-4f2a-202b-d93050ea1f02@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/27/23 5:48?AM, Jens Axboe wrote:
> On 4/27/23 9:10?AM, Anuj Gupta wrote:
>> s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
>> incase setup_ring fails. This will cause a segmentation fault.
>>
>> In case setup_ring fails, bail out by setting finish.
> 
> Any reason why we don't just use the return code of submitter_init()
> on whether to abort or not?

Something like this as a prep patch, then do the trivial version
of your patch after that.

Totally untested...


diff --git a/t/io_uring.c b/t/io_uring.c
index 6b0efef85cb7..2f8d63fbe67e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1049,7 +1049,7 @@ static int submitter_init(struct submitter *s)
 
 		buf = allocate_mem(s, bs);
 		if (!buf)
-			return 1;
+			return -1;
 		s->iovecs[i].iov_base = buf;
 		s->iovecs[i].iov_len = bs;
 	}
@@ -1066,7 +1066,7 @@ static int submitter_init(struct submitter *s)
 	}
 	if (err) {
 		printf("queue setup failed: %s, %d\n", strerror(errno), err);
-		return 1;
+		return -1;
 	}
 
 	if (!init_printed) {
@@ -1172,9 +1172,15 @@ static void *submitter_aio_fn(void *data)
 	struct iocb *iocbs;
 	struct io_event *events;
 #ifdef ARCH_HAVE_CPU_CLOCK
-	int nr_batch = submitter_init(s);
-#else
-	submitter_init(s);
+	int nr_batch;
+#endif
+
+	ret = submitter_init(s);
+	if (ret < 0)
+		goto done;
+
+#ifdef ARCH_HAVE_CPU_CLOCK
+	nr_batch = ret;
 #endif
 
 	iocbsptr = calloc(depth, sizeof(struct iocb *));
@@ -1238,6 +1244,7 @@ static void *submitter_aio_fn(void *data)
 	free(iocbsptr);
 	free(iocbs);
 	free(events);
+done:
 	finish = 1;
 	return NULL;
 }
@@ -1277,9 +1284,15 @@ static void *submitter_uring_fn(void *data)
 	struct io_sq_ring *ring = &s->sq_ring;
 	int ret, prepped;
 #ifdef ARCH_HAVE_CPU_CLOCK
-	int nr_batch = submitter_init(s);
-#else
-	submitter_init(s);
+	int nr_batch;
+#endif
+
+	ret = submitter_init(s);
+	if (ret < 0)
+		goto done;
+
+#ifdef ARCH_HAVE_CPU_CLOCK
+	nr_batch = ret;
 #endif
 
 	if (register_ring)
@@ -1383,6 +1396,7 @@ submit:
 	if (register_ring)
 		io_uring_unregister_ring(s);
 
+done:
 	finish = 1;
 	return NULL;
 }
@@ -1393,7 +1407,8 @@ static void *submitter_sync_fn(void *data)
 	struct submitter *s = data;
 	int ret;
 
-	submitter_init(s);
+	if (submitter_init(s) < 0)
+		goto done;
 
 	do {
 		uint64_t offset;
@@ -1429,6 +1444,7 @@ static void *submitter_sync_fn(void *data)
 			add_stat(s, s->clock_index, 1);
 	} while (!s->finish);
 
+done:
 	finish = 1;
 	return NULL;
 }

-- 
Jens Axboe

