Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF96DC7EE26
	for <fio@archiver.kernel.org>; Mon, 22 May 2023 06:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjEVGl0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 22 May 2023 02:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjEVGlZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 May 2023 02:41:25 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C21DDB
        for <fio@vger.kernel.org>; Sun, 21 May 2023 23:41:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-530638a60e1so5140300a12.2
        for <fio@vger.kernel.org>; Sun, 21 May 2023 23:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684737683; x=1687329683;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YTVTaBCE7QeK/5CtKc0PJVcY5F2Of01RIK92YbOardQ=;
        b=KYd4oEZR1QglHIzezzBott0rwE5SgZefT1JxHJ87x67lr1Tp7g0//HCANJr6em2Djs
         X2nP0Yg6NCte+V8fsoo565jBAUTZ0qmEbmNOgj9DhgeSYO999Wwdl8yucmtAYIhEyuhS
         gwdyMAsn0smgLAr6i4ZCJVKDXMbnNOnWSGwE2f3zOeuIPOVR/zLR49WnBrd/clyJxYLE
         1/ES3rdCdnv4vviw6LXAWp4JTg/IobbK3nwxMJD6B9A4ioS6/77GrhOtIiATfWqZ9ggs
         NruMltreSLndONo5hmYPndsQiMKZ7lIF6tA1zj+3ntTpSt3a3RMH3UDo8cW/TEsMmIuk
         93Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684737683; x=1687329683;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YTVTaBCE7QeK/5CtKc0PJVcY5F2Of01RIK92YbOardQ=;
        b=TTUJIjlcec1zJos7HQRnUsLQ7Kiuzn1hGA2Gv+OAHmKOaWHA7Gf5+pXNWOKhUgD/mq
         rhkT+vJMkYZkYbfTjrqqIjAu0WYkdaExhaxf9+uBl8rVFffxMon2N6aL5dueJNvaShtA
         8q3E9o2qBBlRd9qv3S1ByT+o18Rq41fXmGj32O4XNSSvYXCk84RmKOVrsc1NmPlB5B6N
         qWd22IE/gP2j+E8H5v9MipaGH7Mbj6PmU3HJ+GSKpJyWTKzHHbz26mNmur3WPKPa61Ag
         J2MlMf9rOSC08TwwvpFjZb9E0AIrQgN7z4sDgpjUMvGbM8eChdMLZXWw1Zk/zXH/d9wA
         7P3g==
X-Gm-Message-State: AC+VfDxWeFKon9UyZLo95Fe4ES5zWdl+Yw3zcMt7Qqmjo4Kv8KPIXLiU
        iJsGOQDY+9g5L2zaKCwrWad7PCMIQ5mcZ8w1XdA5kZBBjWM=
X-Google-Smtp-Source: ACHHUZ5x6GeKvo2qFY1SH4HYmg8y8ghhETxNCuewCymUruiDK4/ZI+XdkxoLo51bD/rojeMSt6fgyGY/2AS5x4Icg4s=
X-Received: by 2002:a17:903:2444:b0:1ae:3a5d:f9e0 with SMTP id
 l4-20020a170903244400b001ae3a5df9e0mr14318977pls.55.1684737683260; Sun, 21
 May 2023 23:41:23 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Veentjer <alarmnummer@gmail.com>
Date:   Mon, 22 May 2023 09:41:12 +0300
Message-ID: <CAGuAWdASfWpjti8sX4ncbEVGe_EnV+SPBQebhrHBcpcXMynomw@mail.gmail.com>
Subject: IORING_OP_WRITEV fails with EAGAIN
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm working on an io_uring binding for Java and one of my integration
tests is failing. In this integration test, I'm writing large payloads
(up to 10x1MB) to the same non-blocking socket using IORING_OP_WRITEV.
The purpose of this test is to see if io_uring is going to
asynchronously complete the request when the socket needs to send more
data than it can send in 1 go.

The strange thing is that the CQE indicates the request failed with an
EAGAIN on Fedora 38 (Linux 5.16.12-200.fc35.x86_64). But on On Arch
Linux (linux 6.3.2.arch1-1) the test runs perfectly fine.

My question is under which condition an IORING_OP_WRITEV can fail with
an EAGAIN.

Regards,

Peter
