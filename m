Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD90AC28CF5
	for <fio@archiver.kernel.org>; Wed, 26 Jan 2022 14:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiAZOtt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Jan 2022 09:49:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235611AbiAZOts (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 26 Jan 2022 09:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643208588;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fs/2RtJJ7sW2PEcobARhyu03+XGUpy6ASTY4S7THB5o=;
        b=Rkp+kaoB9E27xEaB/de/RpEEfG094cBUTWWXgIjbOHnaf+gvZBV/yk4fsAc+opSI1IEIg5
        b8yylIDon2HbBzgR7knNdwpHbV8ihij8WRr6dMZg5XfyhLURWCaREpRrTy3IdcztrcOQep
        biujoCm8P+FnVRmtVEgIDmiCF+vz64U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-wlf6Ed97NQuXxVY5UMCKYw-1; Wed, 26 Jan 2022 09:49:46 -0500
X-MC-Unique: wlf6Ed97NQuXxVY5UMCKYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 160901853028;
        Wed, 26 Jan 2022 14:49:46 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.rdu2.redhat.com [10.11.146.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C61DD6F199;
        Wed, 26 Jan 2022 14:49:45 +0000 (UTC)
Message-ID: <b215d78b-55e5-a5a7-5669-c4d9aae28ae0@redhat.com>
Date:   Wed, 26 Jan 2022 08:49:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     fio <fio@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
Reply-To: sandeen@redhat.com
References: <7b124b69-1b3e-bc2b-e251-2b1ef165ef89@redhat.com>
 <0c2fadc9-ab31-d6cb-9209-d2b4030febde@redhat.com>
Subject: [PATCH 2/2 V2] fio: use LDFLAGS when linking dynamic engines
In-Reply-To: <0c2fadc9-ab31-d6cb-9209-d2b4030febde@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Without this, locally defined LDFLAGS won't be applied when
linking the dynamically loaded IO engines.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Seems like V1 inexplicably got whitespace damaged, sorry,
let's try again :/

diff --git a/Makefile b/Makefile
index 5d17bca..00e7953 100644
@@ -294,7 +295,7 @@ define engine_template =
  $(1)_OBJS := $$($(1)_SRCS:.c=.o)
  $$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)
  engines/fio-$(1).so: $$($(1)_OBJS)
-	$$(QUIET_LINK)$(CC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
+	$$(QUIET_LINK)$(CC) $(DYNAMIC) -shared -rdynamic -fPIC -Wl,-soname,fio-$(1).so.1 -o $$@ $$< $$($(1)_LIBS)
  ENGS_OBJS += engines/fio-$(1).so
  endef
  else # !CONFIG_DYNAMIC_ENGINES

