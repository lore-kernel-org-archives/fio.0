Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354A4C77B7F
	for <fio@archiver.kernel.org>; Mon, 17 Apr 2023 11:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjDQLpk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Apr 2023 07:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDQLpe (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Apr 2023 07:45:34 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A88B7287
        for <fio@vger.kernel.org>; Mon, 17 Apr 2023 04:44:39 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f16fd9bc0dso10985195e9.2
        for <fio@vger.kernel.org>; Mon, 17 Apr 2023 04:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681731871; x=1684323871;
        h=content-transfer-encoding:mime-version:subject:message-id:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9GHnT50FOXSOz4mATqYMIngIjaEStBlCyr+CA/bZOd4=;
        b=T9+Iv03uWnK2HJlWhKN6s3fkaoHU0BfCQ3KhSSAm43tUiANSOCyYBqyBg9ZJt5S8PB
         Wv5oPUrB2Gj5uiNvIiH19gDUDjDk6TEvESdM64wYXkGrl8ZYAjblXBlnGJ3BGB8YKG8k
         3oP3iUiUbgHBnXzb1IYpzI9RsD5/thnBGc90vA4e8JMrF9avveLrAKdoDl5Y2iWQT6Bd
         jkMtemaFAoKQMaTdAH8YOK0BJ2P9vGQDYsRe474ZuqziRZOZeyC5qO/LZFVNpn2wXUGa
         WK6n3RXW8h7XGn4ExsKWPlrqR9L331Xy1o9VMDVq8u1xmjkD1V+6UBeSzjk7gJAN0Fge
         rgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681731871; x=1684323871;
        h=content-transfer-encoding:mime-version:subject:message-id:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9GHnT50FOXSOz4mATqYMIngIjaEStBlCyr+CA/bZOd4=;
        b=cxIcxkndi6D+iuwzKR1zbS6uc+g86lFKsOxmTOPJBJOlnhhMqPGtc0MTfHB313fitG
         yddIcRXJo36KmZfSHNt39/0unxkYrQjIHkCwe7kDuhSixXoduYeKIpihmPxnFud/st35
         D+4Posoq0zmxN+SZIk9LamfEmuAz20aoRYTbjQY+Y5N5WJSqxt2w+//Wfu6TVfRAO9mR
         M1RmKa7fdUUeZH/MbkJZdkzTOOebGnhPuXDee1XEMw6pMtW6xMFR+OlmuZMXNa9ih1Zz
         RfwUcOs7J52D70txQ+1BAs+oIiz2LiB4DBTm0DaSpU22CkxhfrZPvo/teY0eRo0hx73u
         abtQ==
X-Gm-Message-State: AAQBX9eAX6TzKma8Tac40SEVpFd+c6ri9je/pTiDWySOEYVx25voIrvt
        gUycAAc8MzACnCweY8vZo/2CrvpVDeExSw==
X-Google-Smtp-Source: AKy350ZAfexAgYj+QVuReDkuxXDGSAJe5lKIn361HiMv877oElGRJSwyOMWPHZ6D0M44mKKctHTg/g==
X-Received: by 2002:adf:ef0e:0:b0:2f8:81c1:ea75 with SMTP id e14-20020adfef0e000000b002f881c1ea75mr5627617wro.20.1681731871544;
        Mon, 17 Apr 2023 04:44:31 -0700 (PDT)
Received: from ?IPv6:::1? ([2a02:3032:200:f935:3be0:616a:f015:9d9c])
        by smtp.gmail.com with ESMTPSA id d16-20020a5d6dd0000000b002d6f285c0a2sm10346911wrz.42.2023.04.17.04.44.30
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 04:44:31 -0700 (PDT)
Date:   Mon, 17 Apr 2023 13:44:32 +0200 (GMT+02:00)
From:   mmoole <mmoole@gmail.com>
To:     fio@vger.kernel.org
Message-ID: <f2bd3a9d-8585-4148-8952-9d5ded6f889f@gmail.com>
Subject: fio terse output Write/Read Bandwidth (mean) = zero depending on
 ...blocksize, filesize?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <f2bd3a9d-8585-4148-8952-9d5ded6f889f@gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Dear fio Team,

I am running fio in a loop with varying values for some parameters:
FIO_RESULT=$(fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=$BLOCK_SIZE --iodepth=64 --readwrite=randrw --rwmixread=75 --sync=sync --numjobs=5 --group_reporting --size="$TEST_FILE_SIZE" --filename="/$ZPOOL_NAME/$TEST_FILE" --output-format=terse)

For each run a zfs pool is created and afterwards discarded.

Now the output I analyse in Excel looks strange at some points:
* some combination of those values lead to output of a lot of zeros in relevant columns, especially Write Bandwidth (mean) and Read Bandwidth (mean) and their accompanying columns.
* it seems that small test file size and large block size lead to that, but not exclusively?
* on the other hand Write Bandwidth (KB/s) column gives huge values compared to other runs, how does that make sense?

See picture of collapsed table attached. (https://imgur.com/a/V5FsmmU )



Would it help to provide the full table, or is there a logical explanation for this, like something regarding block size, multipliers, filesize, r/w percentage or so on?


greetings
Sven



