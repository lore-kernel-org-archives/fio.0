Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1812C7EE29
	for <fio@archiver.kernel.org>; Fri,  9 Jun 2023 01:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjFIBMK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 21:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbjFIBMK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 21:12:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9FC2D5F
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 18:12:06 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5162d2373cdso2223290a12.3
        for <fio@vger.kernel.org>; Thu, 08 Jun 2023 18:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686273125; x=1688865125;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0xGLBWkIhf2AGqnCvAm1w1UxdHQZBT0Evs78jvmKln0=;
        b=ruMv2T0ty13Z/Th6iYiAfwS9SjQ6ZpW6oAC8yxZNN2X6ZDf8zIXBt2VoWFkLBcaSG1
         zFgrKdCl0OBjHQnYIfV6bOxQQRx9PA7Orxia9HfPwuSzHhHQWOwc/+7FPJWnLxmaCT2P
         9W9xDPcf2ryFrFfRQbCBirot/IB8Yv1j/tUFdghWM7J7+J05FfaRTyBCzikTHJeKD3MJ
         G7BS3/xyKDZApwZj0RTx5eug6f6ghExyFSlTpm2we5tglBXvDffu+y0jdHf8uzU/RB1i
         WUdA6e1nmjIRRga25bU3h8vYg0bl3AwSfTd8ainHfDVELrZWtBlEDFNHt8I7Y+SrjeT7
         MRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686273125; x=1688865125;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xGLBWkIhf2AGqnCvAm1w1UxdHQZBT0Evs78jvmKln0=;
        b=eXLzXz/A+FwNOph/Q1Atjv2HZmDF5A5dmgLPpH8VSorGCLusiD/seOxXB+kwchlstC
         lUiC4v8trQY1v3hl/ejxXDlSF8OHSDUSg0m57aY8bgq3S8LuiTE9bbne4I/7ms3o+zgW
         D5VM5pTjDtfHKjIy8NiyqQbh0jHPtS4RwDY5WcOZtciZIgUnnDqdxvVZLVhcQHTi46JN
         vore4x9W54JfkXK9sQOgnWUHAj11y4kwKwghMxSreHXIwJrBwa8tRzxQzaHEP9xoDsCI
         FUk1eON+7NFlIlM76FY4GIbvGq3lJs+ANWOwQ58EJzf9tRk5rXx8YsjDHhBRuefGmB3f
         vGeg==
X-Gm-Message-State: AC+VfDy1DDLIDxskuOKh5Dpcqa7/PXBlj+G0DxyqTmIPQHjGSV+2Fxaz
        PSTyme0pYbZq/ttPwU5pqhCrfhIHyvv0WU8LZqxV5eOG0xw=
X-Google-Smtp-Source: ACHHUZ5PleVK63XnyY2fDgF5FSUTQxho90DZ1GXE9s2YBZWX0AVS7DLeRDths8zIGE/p5hr7/N9ORiEGBW1vrGXZKb8=
X-Received: by 2002:a17:907:25ca:b0:94e:4489:f24d with SMTP id
 ae10-20020a17090725ca00b0094e4489f24dmr191837ejc.61.1686273124987; Thu, 08
 Jun 2023 18:12:04 -0700 (PDT)
MIME-Version: 1.0
From:   Surbhi Palande <csurbhi@gmail.com>
Date:   Thu, 8 Jun 2023 18:11:54 -0700
Message-ID: <CAMBkX3dN8d5kSNUDpPBBmx34+Ov7JzgK=dmgwAfeAaecLX+-7A@mail.gmail.com>
Subject: Requesting help with random I/O distribution
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi All,

I am trying to performance test my device mapper for zoned devices; I
am trying to repliate the 80 - 20 principle for I/O. I understand that
this can be done in the following three ways using fio.

a) zoned - simplest of the three :
zoned:80/20:20/80
However, this restricts the first 20% space to get 80% of the I/O and
vice versa. The good thing though is that zoned distribution can be
used to achieve a russian doll effect.

b) zipf:1.2

I used fio-genzipf to visualize the random I/O pattern:
fio-genzipf -t zipf -i 1.2 -b 4096 -g 100GiB
Generating Zipf distribution with 1.200000 input and 100 GiB size and
4096 block_size.

   Rows           Hits %         Sum %           # Hits          Size
-----------------------------------------------------------------------
Top   5.00% 93.31% 93.31% 24459924 93.31G
|->  10.00%  1.34% 94.65%  352314  1.34G
|->  15.00%  0.77% 95.42%  201010 785.20M
|->  20.00%  0.51% 95.92%  132667 518.23M
|->  25.00%  0.47% 96.39%  122386 478.07M
|->  30.00%  0.34% 96.73%   89402 349.23M
|->  35.00%  0.23% 96.97%   61193 239.04M
|->  40.00%  0.23% 97.20%   61193 239.04M
|->  45.00%  0.23% 97.43%   61193 239.04M
|->  50.00%  0.23% 97.67%   61193 239.04M
|->  55.00%  0.23% 97.90%   61193 239.04M
|->  60.00%  0.23% 98.13%   61193 239.04M
|->  65.00%  0.23% 98.37%   61193 239.04M
|->  70.00%  0.23% 98.60%   61193 239.04M
|->  75.00%  0.23% 98.83%   61193 239.04M
|->  80.00%  0.23% 99.07%   61193 239.04M
|->  85.00%  0.23% 99.30%   61193 239.04M
|->  90.00%  0.23% 99.53%   61193 239.04M
|->  95.00%  0.23% 99.77%   61193 239.04M
|-> 100.00%  0.23% 100.00%   61188 239.02M
-----------------------------------------------------------------------
Total 26214400

I need help with this interpretation. Does this mean that 5% of the
LBAs get 93.31% hits, the next 5% gets 1.34% etc. It seems that way to
me.
However, this does not have the Russian doll effect  - ie the 5% of
the rest of 95% does not get the rest of ~93% I/O.

Is the 5% range - scattered over the disk or is this similar to zoned
distribution, in that a contiguous
space gets the 93% I/O. In that case, this is similar to zoned
distribution, right?

c)  pareto -
fio-genzipf -t pareto -i 0.04 -b 4096 -g 100GiB
Generating Pareto distribution with 0.040000 input and 100 GiB size
and 4096 block_size.

   Rows           Hits %         Sum %           # Hits          Size
-----------------------------------------------------------------------
Top   5.00% 93.04% 93.04% 24388831 93.04G
|->  10.00%  0.99% 94.02%  259143 1012.28M
|->  15.00%  0.60% 94.63%  158285 618.30M
|->  20.00%  0.59% 95.22%  154826 604.79M
|->  25.00%  0.35% 95.57%   92138 359.91M
|->  30.00%  0.30% 95.87%   77413 302.39M
|->  35.00%  0.30% 96.16%   77413 302.39M
|->  40.00%  0.30% 96.46%   77413 302.39M
|->  45.00%  0.30% 96.75%   77413 302.39M
|->  50.00%  0.30% 97.05%   77413 302.39M
|->  55.00%  0.30% 97.34%   77413 302.39M
|->  60.00%  0.30% 97.64%   77413 302.39M
|->  65.00%  0.30% 97.93%   77413 302.39M
|->  70.00%  0.30% 98.23%   77413 302.39M
|->  75.00%  0.30% 98.52%   77413 302.39M
|->  80.00%  0.30% 98.82%   77413 302.39M
|->  85.00%  0.30% 99.11%   77413 302.39M
|->  90.00%  0.30% 99.41%   77413 302.39M
|->  95.00%  0.30% 99.70%   77413 302.39M
|-> 100.00%  0.30% 100.00%   77395 302.32M
-----------------------------------------------------------------------
Total 26214400

This to me looks pretty much similar to the zipf distribution above.

Is this understanding correct ? Or am I missing something here?
Thanks a lot for your help!
