Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BADC10F1B
	for <fio@archiver.kernel.org>; Tue, 27 Dec 2022 23:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiL0XvT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 27 Dec 2022 18:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL0XvS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Dec 2022 18:51:18 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03467265
        for <fio@vger.kernel.org>; Tue, 27 Dec 2022 15:51:17 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-12c8312131fso17080634fac.4
        for <fio@vger.kernel.org>; Tue, 27 Dec 2022 15:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EhQ0wn/Z5i/qwbzO5vuv1cpmqGaA728SxLhO3yj7GL4=;
        b=VkentAu9C1hNftmv6Nz2pRAGijSvNTWYsAy/OoGRLVsI6ebyjRcDqDeCO8iAfYj8yc
         cPzDHpOA9d4IZpgrOuP1k9ecpAxVtkXgL/hPSJwAoFhpIVZpG3DTxt6IaQc546ETsVob
         YNTVhCBkEaYzvn5I8KCNL8DBnho4bp9UpJb270lHpbjYyuJP3ECev/dmrnq6/X9QC2po
         mP6eDKEohX04py4OL1rLzGsdvel0secr/FdIV24NAJ+BmlLUrp+w45Qb149iJbXSEZTn
         OhzTJRkq4sl1o+qZlcmlrPsDYF3YFIydhBNc0TGrQWZHX19Ewaif7/GfiukQa3RfTLJj
         erQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EhQ0wn/Z5i/qwbzO5vuv1cpmqGaA728SxLhO3yj7GL4=;
        b=fMuCSagrxVFM9JoqLoWjCrTJffzLZ5c5rPrW3vf6VjVFHFbyF8rEw5adRsy59tQezf
         FXwJxqrCuQkAbLhjvrjyKLEqnbr9zoU27/0A8zlkLqV8XbcpAeGh9m2OTAIPKyFilERR
         Ls0K/Ogt5LIeTle5CJe4LD25YBLkgck8RtrmGpZjR72CynogS9/NgHwkmKWr5FIdG+5L
         fvVR14mdXld43/9Fib5TO2gAVEqm1az5Z0hI5S1Kty9VWzYPbuLjBTFg1OxQdjJewqyN
         T9jGGuLMr5gOBOVZS7spw5INz042hF8BIjjDZzdsznKtHdJ2kGOkxua2TZpFQXUKULKl
         6HqQ==
X-Gm-Message-State: AFqh2kpIGujhvDcZaQz9Ai0sR9pCiOdHE8gJ2clDJeHmOkdsqdEtrgQe
        Nn3rXfNhz/UINrgTgWl3p9DRTW9y1zBcCFPS6gR1rycStOc=
X-Google-Smtp-Source: AMrXdXs50EqM8wSmrSQflTNKAVkclBOpVY7psVbR+4AXIVn68YwVpZKa5Ced3E1PpFnZKVoeAFO2I7X8AT6Z//dz6N8=
X-Received: by 2002:a05:6871:4193:b0:144:d060:72e with SMTP id
 lc19-20020a056871419300b00144d060072emr1536890oab.287.1672185076131; Tue, 27
 Dec 2022 15:51:16 -0800 (PST)
MIME-Version: 1.0
From:   M Kelly <mckelly2833@gmail.com>
Date:   Tue, 27 Dec 2022 18:50:40 -0500
Message-ID: <CAD5ox-FDUjeZRe9_h_2NtCOCSx2szCVnemO50GwGHa0R_PvqeA@mail.gmail.com>
Subject: fio question
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

Thank you for fio.
Apologies if this is the wrong place to ask.

I am running fio on a laptop with an nvme ssd and have a question
about differences between results.

test.1 - test.8 are each 900 Mb files of random data created beforehand

run 1 -

echo 3 | sudo tee /proc/sys/vm/drop_caches

fio --name=fiotest
--filename=test.1:test.2:test.3:test.4:test.5:test.6:test.7:test.8
-gtod_reduce=1 --size=900M --rw=randread --bs=8K --direct=0
--numjobs=8 --invalidate=0 --ioengine=psync

results:

   iops        : min= 6794, max=86407, avg=26989.80, stdev=33609.35, samples=5
   iops        : min= 6786, max=84998, avg=26818.40, stdev=32972.35, samples=5
   iops        : min= 6816, max=83273, avg=26422.20, stdev=32200.02, samples=5
   iops        : min= 6838, max=88227, avg=27462.20, stdev=34405.56, samples=5
   iops        : min= 6868, max=85788, avg=26870.00, stdev=33332.10, samples=5
   iops        : min= 6818, max=84768, avg=26719.60, stdev=32880.23, samples=5
   iops        : min= 6810, max=86326, avg=27005.60, stdev=33581.89, samples=5
   iops        : min= 6856, max=81411, avg=26165.00, stdev=31345.85, samples=5
   READ: bw=2644MiB/s (2773MB/s), 331MiB/s-332MiB/s (347MB/s-348MB/s),
io=7200MiB (7550MB), run=2709-2723msec

run 2 -

echo 3 | sudo tee /proc/sys/vm/drop_caches

fio --name=fiotest1 --filename=test.1 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest2 --filename=test.2 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest3 --filename=test.3 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest4 --filename=test.4 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest5 --filename=test.5 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest6 --filename=test.6 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest7 --filename=test.7 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
fio --name=fiotest8 --filename=test.8 -gtod_reduce=1 --size=900M
--rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
--ioengine=psync &
wait

results (from each) -

  iops        : min= 5836, max= 6790, avg=6481.37, stdev=140.90, samples=35
  READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
(53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17777-17777msec
  iops        : min= 5924, max= 6784, avg=6476.54, stdev=126.85, samples=35
  READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
(53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17785-17785msec
  iops        : min= 5878, max= 6766, avg=6475.23, stdev=138.57, samples=35
  READ: bw=50.6MiB/s (53.0MB/s), 50.6MiB/s-50.6MiB/s
(53.0MB/s-53.0MB/s), io=900MiB (944MB), run=17792-17792msec
  iops        : min= 5866, max= 6788, avg=6478.74, stdev=139.18, samples=35
  READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
(53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17782-17782msec
  iops        : min= 5890, max= 6782, avg=6477.91, stdev=135.21, samples=35
  READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
(53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17783-17783msec
  iops        : min= 5838, max= 6790, avg=6450.11, stdev=137.17, samples=35
  READ: bw=50.3MiB/s (52.7MB/s), 50.3MiB/s-50.3MiB/s
(52.7MB/s-52.7MB/s), io=900MiB (944MB), run=17892-17892msec
  iops        : min= 5922, max= 6750, avg=6454.06, stdev=125.76, samples=35
  READ: bw=50.3MiB/s (52.8MB/s), 50.3MiB/s-50.3MiB/s
(52.8MB/s-52.8MB/s), io=900MiB (944MB), run=17880-17880msec
  iops        : min= 5916, max= 6724, avg=6465.94, stdev=127.54, samples=35
  READ: bw=50.5MiB/s (52.0MB/s), 50.5MiB/s-50.5MiB/s
(52.0MB/s-52.0MB/s), io=900MiB (944MB), run=17816-17816msec

Question: if I am really doing 900 MiB of random reads from 8 separate
files in both tests, and the page-cache was empty before each test,
does this difference in performance make sense or am I reading the
results incorrectly ?

thank you for any info/ advice, suggestions,
-mark
