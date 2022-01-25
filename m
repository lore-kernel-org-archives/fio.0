Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA6DC433F5
	for <fio@archiver.kernel.org>; Tue, 25 Jan 2022 18:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiAYSzJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 25 Jan 2022 13:55:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231688AbiAYSzF (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 25 Jan 2022 13:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643136905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gb9pCLGLhCof3sw+q6rMqpsWNfsX23n65cKrqk8vmX4=;
        b=Lt3wFifdcvnORsrpp59VGmzw0zrtls007lmMlItqyVAaEeUqyM+SjaTFZYh9X7y+aAMPlI
        /RA1tXrWVuxnPqayU+DlNox1WqAM4RFUId2YDsaH4+ieN66XvD/OQSRLhFoglsXdLVTR3v
        WVuNjg+L+y25NvlRhxEHjEDUVZqfbDQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-8uQWGrgrPkaF8toc41ZOCg-1; Tue, 25 Jan 2022 13:55:03 -0500
X-MC-Unique: 8uQWGrgrPkaF8toc41ZOCg-1
Received: by mail-io1-f69.google.com with SMTP id m185-20020a6bbcc2000000b00605898d6b61so15265557iof.17
        for <fio@vger.kernel.org>; Tue, 25 Jan 2022 10:55:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:cc:subject:content-transfer-encoding;
        bh=gb9pCLGLhCof3sw+q6rMqpsWNfsX23n65cKrqk8vmX4=;
        b=DJzHTtUaWAe7LQTgtLSBxodkz5+Kpr7PQl4OlMjW4CyBVA8g293feLq8lc/BnR0vCd
         cGZiKK2N9YCMbgWZV/HxFxxMpm0jtSmDF2K/fMoZ10O54qHbBX63TbYBJjGS4ADhdFym
         sh5pdSJUNRJSn8OaKLJUJySuQ/3zdR5RKXFRXxMcX9XOoI0vdWqGkIv067Q1crZ6OEgT
         4M+ZsHEBx6eoZjrfmwwzHbgPKVz+TY7mfv7NfQ2shNUCLh/Eo8fM4l6SmA1MbFGco3Ir
         3AfycsFIlAz/Npde5D0FJrDo4298wN9xXbcJ918QV1mp035g3tszgZmjdDPdtYvGSTKM
         2F7Q==
X-Gm-Message-State: AOAM532li8irwlztSCEfsIZwTqESYX7JYAwBb/3OykGHug5lwCh7sJjG
        ow8L1gbWTJmkQ/bnZgTh9NZzSNmDIHByCCHmW9rwVamv4mWLkDFulklG0ORtLJ0ILx6zX3gsqtK
        R7X4H3Fu+7kpTMLWfIdTO2zAk9UhDi56kk0Z6TAO0PGN0RHmYR31MmS8wdFUbHDEI
X-Received: by 2002:a05:6602:1656:: with SMTP id y22mr11329620iow.71.1643136902928;
        Tue, 25 Jan 2022 10:55:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzF2grcj/ISmfMMAfPNHStw3wK0rQHLcN4oHPeu7N80V1aO15FabHaWXGZvOD88mGuoCnJsFw==
X-Received: by 2002:a05:6602:1656:: with SMTP id y22mr11329609iow.71.1643136902634;
        Tue, 25 Jan 2022 10:55:02 -0800 (PST)
Received: from [10.0.0.147] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id b10sm9625626ilj.76.2022.01.25.10.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 10:55:02 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <7b124b69-1b3e-bc2b-e251-2b1ef165ef89@redhat.com>
Date:   Tue, 25 Jan 2022 12:55:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
To:     fio <fio@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 0/2] fio: a couple build fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Maybe it's just me, but t/io_uring.c doesn't link for me without -laio when CONFIG_LIBAIO
is set.

I also got a report that dynamic engines aren't properly picking up LDFLAGS set by the
build system (in this case, -Wl,-z,now).

So these two patches try to resolve those issues.

