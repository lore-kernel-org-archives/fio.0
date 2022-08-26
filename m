Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E2CECAAA3
	for <fio@archiver.kernel.org>; Fri, 26 Aug 2022 13:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344362AbiHZNaa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 26 Aug 2022 09:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245689AbiHZNa1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Aug 2022 09:30:27 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E1ED9E90
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 06:30:25 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l16so577351ilj.2
        for <fio@vger.kernel.org>; Fri, 26 Aug 2022 06:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=+7z403ewNB3PObKPDvJmUvXjR9Im3pBjmlbS/GEDdmg=;
        b=dd2YeM8nb8dB9TlnudtSic1L7DoxUVBsKly2zwjJVNNe9tdZ484Qst6FAPjz+NUhvw
         3n75otVmN+Ib6juoh8/P9fg4+DYlVbGp2ml+8m/XxItbS6XDXVjtrsaQHa0FP4oUSG1i
         K93C4g8Iheftb8RBbbqsh2GPr05XpvD78HKdfEHFrC/JmIsdv417816FjgkPRIG9s/4M
         nyJY/UmKWfqBFEBBEyjUDz+5X4Bs7ImGHISOAdr3eOLTPTK9WSwPjuK61fl5PI5y1lWh
         wgpqcq55J6pppmgMhZurU3LtU2LDEf0ePn/TmHyXE7MgVEsGcUZrzHQKOpDqFciHxZy1
         Izyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=+7z403ewNB3PObKPDvJmUvXjR9Im3pBjmlbS/GEDdmg=;
        b=P7DEeXI3/AAZGJ9a96hLYuXvMUHBpzxe6pf9prxkc2aWRz+OjvArwZbWr1YCygbqwg
         2OWfPHIz4VVjLTCPKXAN2XvMwPAp3oM/fcSVAbli6fO1m/cJx/5XsKQJ9Yr9iHLxU5ON
         Ft+BXVQ8DeZqeH4urXhQ7QOFYBfeXu7I8uSUZ37KVb505rs5HAGz6lsFON7pl+a3Lu/N
         aszd/DtbsmgB44K2L8C0yfw/DhPg7acOvl5ok3EwaNcgupMfC3TH8YUtw1XDITAxDOTb
         r4gtx/gyPkjdssoYAulMK4T/z1IcH1NLye4993oO07a5bCfmSqaFKH41nZQITyzJh/nD
         6NYw==
X-Gm-Message-State: ACgBeo3N8HJmtPC0NzLUUdHcQLp3mzGo3zaN32fVVzuT6ETbAu36TS9l
        0qJ4fV5oR9pqq3jqvM96frzsQg==
X-Google-Smtp-Source: AA6agR4apAF+dFWLDbJE5DLFulOtWxlPhcNMN9H9pIogY5WA1YixKrs0KMuLn78R+YPodwI/r2+LAQ==
X-Received: by 2002:a05:6e02:18cd:b0:2de:73e8:3f0 with SMTP id s13-20020a056e0218cd00b002de73e803f0mr4174822ilu.69.1661520624331;
        Fri, 26 Aug 2022 06:30:24 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h16-20020a92d850000000b002ddc8e785desm1119502ilq.15.2022.08.26.06.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 06:30:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     vincentfu@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Cc:     ankit.kumar@samsung.com, joshi.k@samsung.com, fio@vger.kernel.org
In-Reply-To: <20220826113306.4139-1-anuj20.g@samsung.com>
References: <CGME20220826114305epcas5p4a5636b062f33534f75f0d907af31bc50@epcas5p4.samsung.com>
 <20220826113306.4139-1-anuj20.g@samsung.com>
Subject: Re: [PATCH v2 0/2] Add support for uring-passthrough in t/io_uring
Message-Id: <166152062246.20608.667927693070648273.b4-ty@kernel.dk>
Date:   Fri, 26 Aug 2022 07:30:22 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 26 Aug 2022 17:03:04 +0530, Anuj Gupta wrote:
> This series adds support for measuring peak performance of uring-passthrough path
> using t/io_uring utility. Added new -u1 option, that makes t/io_uring to do io using
> nvme passthrough commands.
> 
> Uring-passthrough on nvme-generic device:
> 
> root@test-MS-7C34:/home/test/upstream/github/fio# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
> submitter=0, tid=5415, file=/dev/ng0n1, node=-1
> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=1.97M, BW=959MiB/s, IOS/call=32/31
> IOPS=1.96M, BW=956MiB/s, IOS/call=32/32
> IOPS=1.96M, BW=957MiB/s, IOS/call=32/32
> IOPS=1.96M, BW=956MiB/s, IOS/call=31/31
> ^CExiting on signal
> Maximum IOPS=1.97M
> 
> [...]

Applied, thanks!

[1/2] t/io_uring: prep for including engines/nvme.h in t/io_uring
      commit: c409e4c2a549ccc0334f2c084a76e80314d42c42
[2/2] t/io_uring: add support for async-passthru
      commit: 7d04588a766308d5903f6cfe34ed72f6c7612d19

Best regards,
-- 
Jens Axboe


