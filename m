Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1758C433F5
	for <fio@archiver.kernel.org>; Sun, 16 Jan 2022 08:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiAPIuP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Jan 2022 03:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiAPIuO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Jan 2022 03:50:14 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A43C061574
        for <fio@vger.kernel.org>; Sun, 16 Jan 2022 00:50:14 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id o15so45705860lfo.11
        for <fio@vger.kernel.org>; Sun, 16 Jan 2022 00:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=s3za/NGa2tW0fcfiTYe4Aji9I8dt4255+qCLwH1vdNE=;
        b=ITX6v2u8kryIEhl16edKSb+JeiZYWXyUqJkJPiwo8gQrjsp4ppgS9NXd6Anr8mfxom
         WBiZEMPJ/bsJ/YYCfZE3HS/sykXYSghDewxpLpC8YnbONT9f1bMotFwbguOlI36k70t2
         GgQVqpEovbA85p86rt6EkrCTpRsyG8t9WqAMKCZPV0LKeZeyydo0R2HtMgTaZorbMlsp
         xkGRAI+yGnbrgYV+yfRZd90tI/YiQOeu/PPlw6ghK/uL+tS5mJw1N/bxsr7mJCoc+TyE
         33c1rUKucDU06M8/N2vgjnsiS9gET7JMDIixOWhUXbJhZ3IE0EG5JXaF6AsI82ZmgzeM
         0UGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=s3za/NGa2tW0fcfiTYe4Aji9I8dt4255+qCLwH1vdNE=;
        b=Mt33qmf7YVOPANmPC+CgtUDJCeZG7XgBOERRg7VwsBGGu1Pc4057/VpaK2LYRdx6NQ
         c3iVknbQxD6DDdWXk1RoVe7rfhTiOpSNAhT2yylLGQKQtstALQsdfD7AzVvtKVFAmhLn
         B5CnOkhcGo7Rcy4xcTdAQ+gtbzfFzQ/Ax+2bmVn2KiVQxWM6c/nzVroPhf/fFKxwSe0z
         pLUrCdzboztA8viTyt2n/oTHMf8CQyBhGgKdA/2jksrSOEpHAqJLrHXriTn9wtY8efPj
         tZRbCl7gy3HohB2DJth5/NcZgWJ1JwqEdplQ1V7JSzqmDMw6h/v8sVXLCLvMlX15SIZr
         ScFw==
X-Gm-Message-State: AOAM530nZsgfXwwcvLr3t0mrq+QWve7LkusSOTTks8JEFuQ8bifgsVX3
        FVm7Ky4tMmWVtG63s2X5/trJOsh0lUU=
X-Google-Smtp-Source: ABdhPJwLwKvleFOxdgxAI2kVJBz55TlStNvC5c02Gb58aml3oMu00Azv+3j7LQNKn+XNB8Jtmqxqng==
X-Received: by 2002:a05:6512:3c98:: with SMTP id h24mr13470893lfv.87.1642323012116;
        Sun, 16 Jan 2022 00:50:12 -0800 (PST)
Received: from [192.168.1.11] (77-121-241-86.kra.volia.net. [77.121.241.86])
        by smtp.gmail.com with ESMTPSA id 4sm539676ljq.65.2022.01.16.00.50.11
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 00:50:11 -0800 (PST)
Message-ID: <51b79acb-c314-143b-514c-a22ff9462829@gmail.com>
Date:   Sun, 16 Jan 2022 10:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: ru
To:     fio@vger.kernel.org
From:   Professor Pro <annivation@gmail.com>
Subject: Can we build fio 3.29 without system zlib dependency?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Any prev version supports building without system zlib dependency
But the latest version breaks that behavior
Is it made on purpose?

I'm maintaining fio GUI and I built precompiled portable fio binaries 
for a range of OS and architectures. All the binaries, I built, are 
compiled without system gzip dependency for portability.
I would like to have new versions of fio that can work without 
unnecessary dependency such as system's zlib

How to reproduce on debian/ubuntu:

apt purge zlib1g-dev

./configure # reports zlib no
make # fails

t/dedupe.c:27:10: fatal error: zlib.h: No such file or directory
    27 | #include "zlib.h"
       |          ^~~~~~~~


