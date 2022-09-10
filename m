Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FC6ECAAD5
	for <fio@archiver.kernel.org>; Sat, 10 Sep 2022 07:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiIJHFv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 10 Sep 2022 03:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiIJHFu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Sep 2022 03:05:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E3386C00
        for <fio@vger.kernel.org>; Sat, 10 Sep 2022 00:05:48 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f20so1109278edf.6
        for <fio@vger.kernel.org>; Sat, 10 Sep 2022 00:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=H/TVFRIyh2M5IE67upK5PUfDi+IY9VrkiakE3xyFpME=;
        b=R/Jb342/h2pXY4NnprSdzx/YgkfxUrYe8QyC2nLAE19IKNv1UUqx+ltMGrJxrUqx6l
         +ok55GDNjglYDbD6fRXs32Uq9rb96zhr7xa65EpwD1i2TcbZ3qHG1nqWsYWFpBgcQ4Dk
         ZQ30adt6sC1E8bGxHHZNfrOjXCzV32A+0K9BFeH9xXW4KJ0Q4uG4eD28oQNJwCPEbHWx
         uMK8yPQUSz+0Rk3X0xxJkrhaiWWMGA6BQRkhUEXvW1sMheNZVtaqeC5RaGy1XhYS7zOO
         VjSw1obvbvo2YW+pjbzbCSiwYSMjak4I3ZF/yM9Ph7/k5LmNMe0LPTFQ5r4Y3nJ/7Ngn
         7gLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=H/TVFRIyh2M5IE67upK5PUfDi+IY9VrkiakE3xyFpME=;
        b=MNAEjUDZ+/j1/Rj2ABy6K4zSzUNbVhbN6vs7M1xzkA3SRDDdB2lNEIbIb0hOIpntVU
         b736PCtitqmoHwOWQEMOG2GbCniXvGVuSRmbvswLnZp78l6kX1/GPfLxHmmZ7ZKhLi1z
         Vf/1Sgz89Ds7Mqz9wtM4CX7/q3wSRUoQpgnrAjo7tJiXQ6rt3Ekc4s+5pGELvgsX5TWk
         py10g/3vg+kbqnw5EiIM8SHjxokZI8jWWfA85UJekp7EQLDQN11lssflTIl77tCk3yau
         xQckwTlcAbJAYIQRDREf1z/xbRS9TNe7kml75+F+iODRPkrPU6Ea2+ki09HsIszGO1/6
         iYqQ==
X-Gm-Message-State: ACgBeo3EFh7/M5Geuzp/pmYAzsWCD7T6AFpvkpwVUD+ASFato1BVtrdR
        zQURddKFOFh7QW4M51ED6ewYFMk+DX439AnIcf0avHpKzUI=
X-Google-Smtp-Source: AA6agR7jG81Ys50SKRFS37D5PvBJRfQkzTuXzTn+DMXqW8RyCjq7Af/FTUJaKSogbbGFDGDE2Y6mwdUPkxKuWhrgw2c=
X-Received: by 2002:a05:6402:1283:b0:44f:2daa:d423 with SMTP id
 w3-20020a056402128300b0044f2daad423mr11723576edv.52.1662793546681; Sat, 10
 Sep 2022 00:05:46 -0700 (PDT)
MIME-Version: 1.0
From:   Matthew Eaton <m.eaton82@gmail.com>
Date:   Sat, 10 Sep 2022 00:05:35 -0700
Message-ID: <CAF+0mvkU08G6DJnvpaRcwxkMKLzQGcrYO_-EyrPz1NxN0ZUOhA@mail.gmail.com>
Subject: Fio latency reporting
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello fio group,

I'm doing some analysis on latency outliers and I read that fio can't
report latency higher than 17.2 seconds. This seems to fall in line
with my testing as my logs show latency outliers max out at ~17
seconds. Can anyone confirm if this is accurate?

https://fossies.org/linux/fio/doc/fio-histo-log-pctiles.pdf
"Note that the highest max latency for any bucket is 17.2 seconds =
(64 * 2^28)/1000.0 ."
