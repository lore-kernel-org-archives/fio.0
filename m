Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A103CC433FE
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 18:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242719AbiKRSaZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 13:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242437AbiKRSaD (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 13:30:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398B6725D7
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 10:29:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x102so8379356ede.0
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 10:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=808FmQPwKUA3auMIHIsURoKPkJ31lCXKdBALIKn7mAs=;
        b=pW7tGsvA62T2PdVQF0tmoFe96NkhtNOtRUpsbPIE6MGxS/0uNMZxH11QNiJo628VH8
         eFtQtPnHSLsUq0EZE+tRTVL830B0ri24TFYp3+jbOAGd6/84KOpnpQnzp/8VJP0cdsDh
         5L5+Eh4sdo5Q/yVRhnFyLyG9BgS8uc+TaU1UtMCvGem53mnBH7LEbD5yjzwGap+su/ok
         K+xlxmPmCIQ472dBTfRthYmNlmz2RrZKcQ9VDzkrPIuvLq7tlCIE+u75r6V4gsgc7ElQ
         5FwjUJs8P02jazoWiuiI74qvOKDs1kHZCc21Lyrl60OneodrzQTXK/kYkfKmyTXZrPJ9
         jofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=808FmQPwKUA3auMIHIsURoKPkJ31lCXKdBALIKn7mAs=;
        b=NT7R9lFR16cjlSSyMGpWxOFoc31I1BN+aAwfbcuApHSbdRQjd7D+Dxxduj2iLJ9rzU
         cE5gEMrn138gIfmrifAi9Drui2JsrT2ETU8onlf4S9gxBm1I/rj53gNP2jtgp3aQFgBG
         aJOMq7PmTFtT0TWek9a6UyqyrwMp1mFRZ/+HjEEyg/lOih5PTNrvyBpSDYXDR0YRG0pc
         UWQ87aJvk+Cr+GDC+Tj9eE0im3amJIj8pOvmoYmEsiPZhBeruc3swJkNmMhacP7Q+qNf
         ik7ObHQq7x8JTYLOimbIpnI0Ilq1wb3FYse/b+Xd783L60V53vQRKVf+lFWcn4Kszf1v
         I/MA==
X-Gm-Message-State: ANoB5plYIim58QfqxH/6YfURBPCY7EO4NoWgPxt3ORCTqxDwMW1rmYh0
        X1AsdIDPnTS5F6w3PJ5EzCggkUyQbBHdvKg4bgwiA4jHnOw=
X-Google-Smtp-Source: AA0mqf6JGppg8fN7Qf9m308FXHbKXWpImeVXzb9w1egNGXt3U8IF5QOXKI2J9zB0MmU80GeMGwHR+P8Ah3EAcwCC8mQ=
X-Received: by 2002:a05:6402:1207:b0:467:5e8a:bce3 with SMTP id
 c7-20020a056402120700b004675e8abce3mr7191060edw.334.1668796183473; Fri, 18
 Nov 2022 10:29:43 -0800 (PST)
MIME-Version: 1.0
From:   Matthew Eaton <m.eaton82@gmail.com>
Date:   Fri, 18 Nov 2022 10:29:31 -0800
Message-ID: <CAF+0mvnVZED8wvQwcaptuQshA4rLzQ+rJBd2P7+1otq2W85NVA@mail.gmail.com>
Subject: Replay blktrace does not respect --loops
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello fio group,

I tried replaying a blktrace in a loop using --loops=2 but fio does
not seem to respect this flag.

I used fio 3.33 with this command:

fio --name=replay --ioengine=io_uring --direct=1 --iodepth=1
--read_iolog=blktrace.bin --replay_no_stall=1
--replay_redirect=/dev/sdb --loops=2

I think this would be a useful feature to have so I'm bringing it up
to the group.

Thanks!
