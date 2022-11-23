Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684E3C4708B
	for <fio@archiver.kernel.org>; Wed, 23 Nov 2022 20:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiKWUjK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240298AbiKWUie (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Nov 2022 15:38:34 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F29B65
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 12:38:33 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 130so18374538pfu.8
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 12:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zElUTUDcPnZZKCBrI9x6cJ1V47KVc0DiFMmEj00CDJo=;
        b=ZX62LlB5onzZlrrcZ85r7ZpV8g8xJUNWGJSJxV4vVXgaGpN7SAfnY9Ib6ZqgG3gwTS
         kLC122fYy/tSA2qDhlHmCr64CT+8N2RHn9UawHxhWzgTIx//qk+loUvBtg5wR1UHyofE
         3/83cXuuEuMMFlWZhs6kce6gtDG3ekBAYQ5Db+fnAzbQr0zXSu+IugBNqs3/t+rauPPI
         5iaW8VeyE9mB7pB6NlLtw53FjY19PfTVaz6liQ1LN2WRWw6rmQYnQCDMVSrxPY38WaXz
         pWBdfmAQqaJUJvSglFd13bc+bGjGNUOCAo8V9ISKqjJtt8c37q9slebPMTmC6itdx9IU
         YIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zElUTUDcPnZZKCBrI9x6cJ1V47KVc0DiFMmEj00CDJo=;
        b=NACJ0sDtgBz81XJWxUziinVcyhPstG0GUEPb1niC0TB/Hm1BG+pc10t79PxKMScJe0
         Csw2/JwzhXwEYZMQMM4/AwFUThWDl5ro+L2BnCaHdkiw00z2BfPSqHn573CD+3+1bbtI
         1dfQBuz5EpHxRR1QBdza8qPETFITYf7PGdJWodL3ux/7+QE6gxJsxx1BauH+17s9UY3p
         iwQp0+rzM1LgDdDEC/eT8of9UTLdluY9bs+0ACFhsN4eUiZwv11SSlQ+gx5ukJGzEAnJ
         mn05gS5T5NFg99MSpFuftJzwRd3aFmJq1Tjt0GY18zsHa+c9yd0i4pC0QHVchAczfLF6
         dWvQ==
X-Gm-Message-State: ANoB5pkWCifGFs36Qf2p08EEpwTzFIbb+oCUqaDOo2L7aDA9G1lNvVJQ
        3qlXLWKC+ALZYd8imGO48dp+f5GvsB+Jqv/7jCF01RsYxhQ=
X-Google-Smtp-Source: AA0mqf6syZaRxq8DaVD3WOx9sN4TNhRVgIDitYDMbxKT9kXRZIykeakmHNBX3M5PMnZF03LB9ztGt6gXljn80km4+PU=
X-Received: by 2002:a63:4545:0:b0:460:936b:ded7 with SMTP id
 u5-20020a634545000000b00460936bded7mr8863942pgk.149.1669235912759; Wed, 23
 Nov 2022 12:38:32 -0800 (PST)
MIME-Version: 1.0
From:   Mateusz Masiarz <matimasiarz@gmail.com>
Date:   Wed, 23 Nov 2022 21:38:21 +0100
Message-ID: <CAON0+B8Tq+yH+Uqoxi6QbO82mEqipc2sz1rBtnAEurc6cuxkLg@mail.gmail.com>
Subject: fio bug (?)
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello, I'm trying to benchmark pendrives with fio. I'm running:
fio --name=test --ioengine=posixaio --direct=1 --rw=randwrite --bs=4k
--size=4g --numjobs=1 --iodepth=1 --runtime=60 --group_reporting
--time_based
the io file creates normally, but then the job starts. Firstly, the
write speed is not shown. Secondly, after the job runs for one minute,
the completion percentage drops to 50 and the eta shows a few thousand
days and the job doesn't end. After about 5 minutes of running the job
ends, but write speed is supposedly only a few bytes per second, which
(I think) is wrong, because crystaldisk mark shows around a few
megabytes per second with a similar random write test. I'm running
fio-3.33 and I tested this on MacBook M1, raspberry pi, some old
kubuntu system and on Windows, and every result was similar.
By the way, is it normal for "Laying down IO file" to take a while?
