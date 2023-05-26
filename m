Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7172BC77B73
	for <fio@archiver.kernel.org>; Fri, 26 May 2023 15:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244160AbjEZPit (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 May 2023 11:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244058AbjEZPir (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 May 2023 11:38:47 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C57114
        for <fio@vger.kernel.org>; Fri, 26 May 2023 08:38:43 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id 71dfb90a1353d-456f7ea8694so241264e0c.0
        for <fio@vger.kernel.org>; Fri, 26 May 2023 08:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685115522; x=1687707522;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I9q7iE1DvESPz6ahGjyzS6NY50VCNfiGBTMSQ1T7RAM=;
        b=n+BiDIJdvRdVSqHJqMfcsioWiSkB8DpyHvEOXrgNk1Y6lhE3j2egiVlvlUZxkgiyev
         C1g4yzQYC7ZVOK5YK1CPibCd6Rd3FgeftFecqGvGywhVddoA2TWzH7I2oYm8t1HaWs91
         LQUtE2OiqUcIo0GVcL9Y9AJRKwZ0B1o96TxfJqqetuCb6mnsoa4z/i9bCwiA5+i9TYB9
         NfJMOOnpeeONzwgt10VRpLA9KMIMzZxY2mOWr/P9JlLgT71Sjj7ysWwHUZSIVDK9fOcF
         rhn8VajA8oWNf+5vPhItm+haTjm7dbpl+gQlVw05uSM77LrtRZaJcAgy6WSIvyiP0Ybf
         xJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685115522; x=1687707522;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I9q7iE1DvESPz6ahGjyzS6NY50VCNfiGBTMSQ1T7RAM=;
        b=Q8rswvuizB8sORT3rEHl1Llsoq0W5woz4pw+rcqP7OAjxHOqD4lKLTG2zs3SZDcwf1
         a2kyWPxmTMt6rVUTpXNDhFJUZdjp7gMZT0GZNHQe1gWFHomrmJabelqQzh1lV+/Sl9b2
         YrdYt48BCoRkkcArTg297zkn4GSch4BYBCAuahYn8V5MKhLhOtOViktLw1HMcXOHmyx3
         GEpaKlJiIGv7al9jruKUDyCQvqTK9UFYF3ZZhrlFq2E1xQ5OMxIwyaT2xwfj4BJYBr62
         PDD+fEgOsZUUZoez4tunWPvMBlfxr07jEz1KLwvJv39mNoHpeRKKJjnczsgraIoNgTqy
         3Pmg==
X-Gm-Message-State: AC+VfDwwaFYgWVU+5aLgwhQ4xrUr0+DPmdj0pKA0fbpKJ7ZjIUTGJeR/
        fef7XNZ9sG5jivDUNGvUFIPaUFNQJyNI9TLNRwp0TlBKujivZw==
X-Google-Smtp-Source: ACHHUZ50Ecy+0vQqtCTQwH2h+hpxWK7nB2B1jI5e7ZyHQVM9DKojg2cTmei9hgJzelcYl2Rtr+8x2mIMGuDi2wncQ/A=
X-Received: by 2002:a1f:5043:0:b0:43f:8928:151c with SMTP id
 e64-20020a1f5043000000b0043f8928151cmr542916vkb.11.1685115522093; Fri, 26 May
 2023 08:38:42 -0700 (PDT)
MIME-Version: 1.0
From:   Travis Downs <travis.downs@gmail.com>
Date:   Fri, 26 May 2023 11:38:05 -0400
Message-ID: <CAOBGo4wFOxyXXhjeqk6MJ-QkjsaypQYOBaL8wCVkMpk6H-khsw@mail.gmail.com>
Subject: Ending condition for non-rr file service
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I guess I understand when fio "stops" when using 1 file per job: after
`io_size` IOs,
which is usually the same as `size` if `io_size` has not been
specified explicitly.

When size == io_size, this means that all blocks of the files are
written exactly once
with linear or random writes, except if norandmap=1, in which case
some blocks will
likely be written 0 times and others 2 or more times.

How does this work for nrfiles > 1 and linear writes (rw=write) and
file_service_type
set to one of the random ones? For the non-uniform distributions some
files will be
written at a higher rate than others: does the write pointer just loop
when it gets to
the end of the file? So io_size writes will still be done, but some
files will not be
completely written while others may be written more than once?

Travis
