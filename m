Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7DCECAAD8
	for <fio@archiver.kernel.org>; Thu, 22 Sep 2022 20:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIVU3s (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 22 Sep 2022 16:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIVU3s (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Sep 2022 16:29:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160CA24F29
        for <fio@vger.kernel.org>; Thu, 22 Sep 2022 13:29:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r7so17374243wrm.2
        for <fio@vger.kernel.org>; Thu, 22 Sep 2022 13:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5Ui2pJ/Pi48k0DHQVY2X8NUTu6fdyhhMRMqKGWyexr8=;
        b=DNTN/Y74oupNes2iqG9/aTyY1s4kz5WlXGJF/v+GGn8CrsJZ8QiMzFWPbEFNpk0J1V
         9tzIxeIiFPYbQ0yXyFhIDZXoH1rcFSGjk4AloFsG5G7z2UA3k2n1eD6VuKYZ/cNPVdDJ
         dHnCLLy4oi2uiHnuf4bTEW90xeYqsHy29b+wfYTrLXpBX1Wgd6UNa0zFGseCoteFkfQ8
         eURV94ONaqsavNskonKpWv7MccuFJIcumigx6s9oSWOcw+1oZeupPxXrxuV6nQortqj6
         e3mlN4mIYywNVRKb9WZnH8BwzvYfJ+H7swdxN9yRGIbzi7PUMN/SqlNEP0XEOydhiGvl
         WA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5Ui2pJ/Pi48k0DHQVY2X8NUTu6fdyhhMRMqKGWyexr8=;
        b=v8b40A7MQc2wSI3h5EmARyospIQwUMMLI6E0MIAc2lHiF8cAZH/JN0dQIIGTokhobK
         ZlzO1iA5YVWhuUBPAZE0B0/3kqM38IFekfEAV+H8+qCrQmSQbVf6oHSp68enH0IS07/b
         dwl2E+lK4lsXjp80rS0Bq3qgGI36S2BdRY4Lj7O1skSgNwbITh/UYdaS9xuiK6b36kn6
         rWyFuPM5BKBw7VjLil2DSlIX/xyZO5kujEZpuvVYKweQxHwHDlqb56jThQvbDl0subpk
         JGDxmhrXKsbkwJ1UljronRtz4fbLSWT07+wBcT+jj4XhQL56bcsuWCvxSYQC4qF+/tK/
         gM/A==
X-Gm-Message-State: ACrzQf13dP0989Tz28GL1WI/xvZ128y1vMu/5chwQjGUVBLY43qBPxse
        rMDma+jC6wKXv1gRf08hKqs7buBddG5orrH58P6CjOTf0EEqPjrM
X-Google-Smtp-Source: AMsMyM7c46CCKrYFnTJoEYSIdM3z3cpbYLBcs5rzZSvl39uzVLCv2z6cvvB6g4Ukg0+4RWFwK/Sq0QS2+SMwRRQdn9E=
X-Received: by 2002:a05:6000:1363:b0:228:d605:f9dc with SMTP id
 q3-20020a056000136300b00228d605f9dcmr2970797wrz.109.1663878584557; Thu, 22
 Sep 2022 13:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220907155824uscas1p14b8cddb2c97e9b29b194f25ec3edc4b1@uscas1p1.samsung.com>
 <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <99cd72aca6274227825d5a50b263bab8@samsung.com> <CADqNVTpvftJZaJ2AepPMcbaJJr7vYMaLdivCf85j8Rwrq_02Fw@mail.gmail.com>
 <CADqNVTpkMUVx2+tUXTRivNqsejbP_Sto90pihzm+L210=MC25A@mail.gmail.com> <9b0021d903894664ab0a698ff19588d0@samsung.com>
In-Reply-To: <9b0021d903894664ab0a698ff19588d0@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 22 Sep 2022 15:29:32 -0500
Message-ID: <CADqNVTrzoL+7o1Q8FNE819wO5HgC8a5cTFOhmBVKAPnX9_JTuw@mail.gmail.com>
Subject: Re: Best practices for handling drive failures during a run?
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Sep 9, 2022 at 10:56 PM Vincent Fu <vincent.fu@samsung.com> wrote:
> You could test your theory about max_retries by creating an NVMe fabrics
> loopback device backed by null_blk with error injection. Then try to access one
> of the bad blocks via the nvme device and see if the delay before fio sees
> the error depends on io_timeout and max_retries in the way that you expect.

I finally got a chance to try this. I had to learn enough about nvme
fabrics and combine it with the null_blk bad blocks as before. I think
I'm doing everything right, but I'm wondering if I missed something,
because the behavior trying to write to the nvme fabric device which
has a null_blk device "backing" it is the same as trying to write to
the null_blk device directly - immediate error and termination of fio.
I wonder if this should really surprise me though since the underlying
device doesn't experience a timeout and its error is immediately
propagated to the client over the nvme fabric (apologies if I'm using
any terminology wrong). This was my basic setup:

sudo modprobe null_blk nr_devices=0
sudo mkdir /sys/kernel/config/nullb/nullb0
echo 1 | sudo tee -a /sys/kernel/config/nullb/nullb0/memory_backed
echo "+1-100" | sudo tee -a /sys/kernel/config/nullb/nullb0/badblocks
echo 1 | sudo tee -a /sys/kernel/config/nullb/nullb0/power
# First fio run directly on null device returns error immediately
sudo fio --filename=/dev/nullb0 --name=job --ioengine=libaio
--direct=1 --size=1M --rw=rw --rwmixwrite=100 --bs=128K
sudo modprobe nvme_tcp
sudo modprobe nvmet-tcp
sudo mkdir /sys/kernel/config/nvmet/subsystems/nvmet-test
cd /sys/kernel/config/nvmet/subsystems/nvmet-test
echo 1 | sudo tee -a attr_allow_any_host
sudo mkdir namespaces/1
cd namespaces/1
echo -n /dev/nullb0 | sudo tee -a device_path
echo 1 | sudo tee -a enable
mkdir /sys/kernel/config/nvmet/ports/1
sudo mkdir /sys/kernel/config/nvmet/ports/1
echo 127.0.0.1 | sudo tee -a /sys/kernel/config/nvmet/ports/1/addr_traddr
echo tcp | sudo tee -a /sys/kernel/config/nvmet/ports/1/addr_trtype
echo 4420 | sudo tee -a /sys/kernel/config/nvmet/ports/1/addr_trsvcid
echo ipv4 | sudo tee -a /sys/kernel/config/nvmet/ports/1/addr_adrfam
sudo ln -s /sys/kernel/config/nvmet/subsystems/nvmet-test
/sys/kernel/config/nvmet/ports/1/subsystems/nvmet-test
sudo dmesg | grep nvmet_tcp
sudo modprobe nvme
sudo nvme discover -t tcp -a 127.0.0.1 -s 4420
sudo nvme connect -t tcp -n nvmet-test -a 127.0.0.1 -s 4420
sudo nvme list
cat /proc/partitions | grep nvme
# This guy also returns error immediately
sudo fio --filename=/dev/nvme0n1 --name=job --ioengine=libaio
--direct=1 --size=1M --rw=rw --rwmixwrite=100 --bs=128K
