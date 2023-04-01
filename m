Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89367C761A6
	for <fio@archiver.kernel.org>; Sat,  1 Apr 2023 01:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbjDAB51 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 31 Mar 2023 21:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbjDAB5M (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2023 21:57:12 -0400
Received: from mail-oa1-x43.google.com (mail-oa1-x43.google.com [IPv6:2001:4860:4864:20::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8E93A87
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 18:55:00 -0700 (PDT)
Received: by mail-oa1-x43.google.com with SMTP id 586e51a60fabf-17ebba88c60so25049440fac.3
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 18:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680314051;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KmuJBCjiUQ5C4Hc32JcE+4DU+2BZW3jrm9h1Ab+hgmU=;
        b=IIXBJ9+pl+MMk1JhIAORUCsmbWzlAvLDjdIIUnBkOt+Iao5YbJCXMvymM5CVDDkAPY
         IuLsk8baWkNrJ+VOLDMUbd9DM9dX0xpHiRN7ifnJr1MaVtQ12uDTzs0Ec98SZi7x44RJ
         MFqgJh0tAULSVLPH8M0kX3josxG7VAvk4Eu/0FG1wW32phe+EBMc7otalQjBtpvrOBzS
         ndDDkw9L/FwdxzflltT+3sbpW7xo/681x1ObBvkJszAeikToG5F2r8VJzkF8JcdcOvhG
         2S4FYLbHm0yhrwbzdULDAKtHewMPibOwOHdb7KS9Ko2vUxvCvB7cfYpuKuphUKRb6Gjz
         y51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680314051;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KmuJBCjiUQ5C4Hc32JcE+4DU+2BZW3jrm9h1Ab+hgmU=;
        b=LQiZf3kJ5ZVu7rYTJgetaLdK8u9ughFV9SD4kaB8TfAuH7PdsdrsDAnFSgMnHRw6pT
         g6QcTNtZyE3I+eK579VlBiEr4iBOyvTpRJ/ay2+/njkzPh7l3WOYBa7uApCCYlbS+9qu
         zLAv9vvCOJGy59PXR9EEIahTD6rn2m4eBq1biYejX2MTFxlGOqAXfjRPxfS/+/wF8slJ
         kUjgOSR5G9aPPzUYHrz9svf5VHSM8w/YhN8nxMFqzr7Dt7z0T5GtVtcA+urmqc1pjHJa
         K8yBisD+hL6Lcf2xW3ZQP3Uyl+OuCj2GT6b+eBke8g2PRqLg5G86WJWi7g2JwczO0gxC
         j7Lg==
X-Gm-Message-State: AAQBX9dkfvtfOslnwPMpOgvOuZM29vTMi6XaaCr1zjfbpc77tn+7iJw6
        oj9pfPVEVOxouOQNKMQh1WVYgeU5ObA0kfk50N3TBvLkjn1TGCi8
X-Google-Smtp-Source: AK7set9JK2s1zqcbcaY1upFQnuuSWHMU3JATbbeXrukbdXuh4+z5mBumN6+BsmSvEgjt1fZzjuEj56nRtDt74ZBfnn0=
X-Received: by 2002:a05:622a:88:b0:3e1:934d:ba1a with SMTP id
 o8-20020a05622a008800b003e1934dba1amr11433136qtw.3.1680313482877; Fri, 31 Mar
 2023 18:44:42 -0700 (PDT)
MIME-Version: 1.0
From:   Sadman Sakib <sadmankiba@gmail.com>
Date:   Fri, 31 Mar 2023 20:44:32 -0500
Message-ID: <CALy08mb+6uq=ds2fVZ2B8YF5P4FvZgMsD0qx3ZTEY6EuFJ2ADw@mail.gmail.com>
Subject: Does fio support running workload with NVMe-oF on top of SPDK?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I was wondering if Fio supports running workload on remote SSD with
NVMe-oF on top of SPDK. I was able to run fio on local SSD with
"xnvme" engine on top of xNVMe driver, which builts on SPDK driver. I
followed the "xNVMe ioengine Part 2" guide in fio-blog repository. The
job file I used is as below:

[job1]
ioengine=xnvme
xnvme_dev_nsid=1
thread=1
rw=randread
bs=4k
filename=0000\:22\:00.0
direct=1
iodepth=1
size=1G

I was also able to run workload on NVMe-oF with SPDK perf example that
is shipped with SPDK using a command like below-
spdk_nvme_perf -q 128 -o 4096 -w randread -r 'trtype:RDMA adrfam:IPv4
traddr:192.168.100.8 trsvcid:4420' -t 300

So, I think to run Fio with NVMe-oF on SPDK, I will need to set
transport type, address and port with fio options. But, I did not find
such options in the fio doc page. Does fio currently support NVMe-oF
on top of SPDK which may not be documented in the doc page?

Best,
Sadman
