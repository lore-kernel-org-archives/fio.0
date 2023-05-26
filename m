Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901BFC77B7A
	for <fio@archiver.kernel.org>; Fri, 26 May 2023 21:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbjEZVPa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 May 2023 17:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243467AbjEZVP3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 May 2023 17:15:29 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150B6BD
        for <fio@vger.kernel.org>; Fri, 26 May 2023 14:15:27 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f6e83e12fso188746366b.1
        for <fio@vger.kernel.org>; Fri, 26 May 2023 14:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685135725; x=1687727725;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=71T1LzSOoHkP2U6o87u66UxA8Q7wvOJRfA90k4GXVGY=;
        b=mU1hKT5KB/xktSjoCXqRnYmslP3qVsqNVUQ7dp4Jrlt9WEhVGUwsmBefVQrlJ8SzlF
         /Q2ELIJzAvNTxmWWL74AApWyK1JCKl72Si6Zw/7kJgqYdgfTBCc0ccVbKI6CEjOP/Ll1
         s1BM/Yf2H2Un90rn1F28hNheIRyLsJNlObVszHDNbBRUDsqs1C8Ou7+QJTnffW0Kgw7s
         j76m0+VVKZjfVZvx+7BSR2yQcx26LBZ/SMplfvD/dY02NaoML7L5uv49uIBoGhMkzANW
         T16WFliKAe2sBW7KjMTzoXHk3eHcs4tYeRTphvPr9eSAexrlxJX4CQLN2yIv5w87chDW
         YusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685135725; x=1687727725;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71T1LzSOoHkP2U6o87u66UxA8Q7wvOJRfA90k4GXVGY=;
        b=N5DW0omm+xljNmgdhugimIJ4U6i0jzz+YCM4arCfHn97lmB0NUSQKV34+lD9Wy+3Rd
         3+sGNlVZS9xP/O1iKLZ9mjDj8AX5pTPr9B8PWvWMcfRlAENAQiMk+YKUen63lOi2b4ZT
         JdtlK3RPBWVQGeEQRRapDJA0UFYOoD9tUo99Q0G8tkktI2lnxioWD678vZQpx09TNlj2
         ECAmeKXKjwulUWVlWMsQ4OLMtNTo5WrsIu3YulfVpU/ELN87LuO44uiZnD5jYjv/3Imu
         koWvzfsckWL0JUeq5pQ3gmjP+Sj9il/ozy6GfmXV2cMaaJM7OqQza7zaipjNrDhLWL6O
         KOcg==
X-Gm-Message-State: AC+VfDxk7dTtuYyGzF6JQx7hETs+f0c2wdCdOqUbmyRet01bcNx34HkE
        iGeJWKQJRLAp7FYKSyQO2+fWCATF1KQjIRUXH4MAL1XdHj5njw==
X-Google-Smtp-Source: ACHHUZ5y8/HoioM9p3KTbdZEStyWCirsAhSV/PTOvuZYHt/EII9650ci2wpCd9ZXAUHoliJlfEJtU7+pQ8mv1FhAdiw=
X-Received: by 2002:a17:907:c26:b0:968:892b:1903 with SMTP id
 ga38-20020a1709070c2600b00968892b1903mr3462958ejc.5.1685135725098; Fri, 26
 May 2023 14:15:25 -0700 (PDT)
MIME-Version: 1.0
From:   "jashax64@gmail.com" <jashax64@gmail.com>
Date:   Fri, 26 May 2023 23:15:13 +0200
Message-ID: <CANvHRkAN5_rMb0gZbo+EXQVbNxPrSDWTnFGsSHCb3+o5AZd2VA@mail.gmail.com>
Subject: fio reports "io_u error: Value too large for defined data type"
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Dear sir or madam,

fio reports an error "io_u error on file /dev/nvme0n2: Value too large for
defined data type: write offset=51539607552, buflen=65536" on my computer.
I am using Western Digital ZN540 1TB. Do you have any idea on this? More
importantly, **when I ran the same command a few days ago there were no
errors**.

Thank you!
-Yijun Ma

P.S. The command and original output are as follows:

$ sudo fio --ioengine=psync --direct=1 --filename=/dev/nvme0n2 --rw=write
    --group_reporting --zonemode=zbd       --bs=64k --offset_increment=8z
--size=8z --numjobs=14 --job_max_open_zones=1 --name=seqwrite1
seqwrite1: (g=0): rw=write, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
(T) 64.0KiB-64.0KiB, ioengine=psync, iodepth=1
...
fio-3.28
Starting 14 processes
fio: io_u error on file /dev/nvme0n2: Value too large for defined data
type: write offset=51539607552, buflen=65536
fio: pid=76338, err=75/file:io_u.c:1845, func=io_u error, error=Value too
large for defined data type
