Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DEFC4332F
	for <fio@archiver.kernel.org>; Tue, 25 Jan 2022 18:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiAYS6H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Jan 2022 13:58:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233813AbiAYS5v (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 25 Jan 2022 13:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643137064;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XElo4NNW8M1dG7p70qlqYVt/SWZZEeE0rP+uOJxIgG0=;
        b=Ty6MrjGip8zpbjznQxmHz9E/B86U6Lf4VCvsAbKsQvwCj1/NQdW+zxJjw4XGZkG5GsNTMM
        kvaorhyiCKngOn0/9+AY6L2tYuG22Ig2QP6g6qaTK8+zElFIdUKrVjhRg0C0KQulL8L59u
        Wi9WSsrvNL6xCi9cLg4viWWmzb0toKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-5nwV11iTP1W-jhNy13rDJA-1; Tue, 25 Jan 2022 13:57:41 -0500
X-MC-Unique: 5nwV11iTP1W-jhNy13rDJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4612E81F019;
        Tue, 25 Jan 2022 18:57:40 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.rdu2.redhat.com [10.11.146.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B990E10A4B2F;
        Tue, 25 Jan 2022 18:57:39 +0000 (UTC)
Message-ID: <66556d08-0bf3-096d-2c8f-427328ba962e@redhat.com>
Date:   Tue, 25 Jan 2022 12:57:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     fio <fio@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <7b124b69-1b3e-bc2b-e251-2b1ef165ef89@redhat.com>
Reply-To: sandeen@redhat.com
Subject: [PATCH 1/2] t/io_uring: link with libaio when necessary
In-Reply-To: <7b124b69-1b3e-bc2b-e251-2b1ef165ef89@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When CONFIG_LIBAIO is enabled, we need t/io_uring to link with it.
(libaio_LIBS only affects the aio engine, AFAICT.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile b/Makefile
index 5d17bca..00e7953 100644
--- a/Makefile
+++ b/Makefile
@@ -99,6 +99,7 @@ endif
  ifdef CONFIG_LIBAIO
    libaio_SRCS = engines/libaio.c
    cmdprio_SRCS = engines/cmdprio.c
+  LIBS += -laio
    libaio_LIBS = -laio
    ENGINES += libaio
  endif

