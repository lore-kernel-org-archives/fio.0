Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA18C7619A
	for <fio@archiver.kernel.org>; Sun,  2 Apr 2023 18:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjDBSRI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 2 Apr 2023 14:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDBSRH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 2 Apr 2023 14:17:07 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7920A61A4
        for <fio@vger.kernel.org>; Sun,  2 Apr 2023 11:17:03 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id f188so13918794ybb.3
        for <fio@vger.kernel.org>; Sun, 02 Apr 2023 11:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680459422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qh7ZKSYZFrY/xE6AMEUTWP0qk1qQMY6fLeCbAAYyhXU=;
        b=P7p2QkxiOVYXDXrS0zINedm5er4YXVsBhNg+SLt/1m2kITngnaWqSB9j73T+VG+hr3
         VO11MSLadfIMnG7WVQQE6D77gmwlX5ZVGhc6EvSS39pIgNNqe94NgfJ/MJ4dtbsM6nYA
         bcWiSf33MIoreg1WRfI1A5px1R19KL7nXvg7dprANwr+W9wAh9+MTG0VLczTlzlVSth+
         609Yh8iX2pu2CrY89xECGMCB+k9x7sNOzA/XQHdBRE4bltIgxwXoduxSr/A4An9LFpbf
         zyfeowCJHfdFnnP4wqVnDAgYNz4FyOXbtCyLGpVoOQ0CrMuMTjljMEuIkXeGInniuJhh
         Jc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680459422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qh7ZKSYZFrY/xE6AMEUTWP0qk1qQMY6fLeCbAAYyhXU=;
        b=7XibGNrc2Qn/OYNb9PZSW2rY9jbJ0HLPPcQ/kc3tyVxymr9n4pXGieo7krRYL4a/Kp
         vmdGfGpGl0p3MyAEQoCNcZ/kUb3cQItvkwIsa+Xi09a7/ptZQHBtjesTIzmlPc5b/bhm
         tIdrjSXbcyKJs+yem1qx9eXlDpF95+gE9PVGq5rl5p+tQYr1111glcrJM/GuM5s/CjCl
         6MT9iPXEQIn+TawnU57/7hnkgKEherbE+8HK3FtSIcGQ6EiMp/5XhqiKBtNcXjasqFgY
         oLRwirZl+2dSoQ1PDA6LU24+SoGz20I6I6peJN4Wxf3Oi8Yt8KwotWPpW4l+LWv2EOxG
         UISw==
X-Gm-Message-State: AAQBX9fCBGe6fwWXIgcSUcZsQoKNjs604Jd5mJf8xdiT+zpVMU6G8H05
        ZXFpuwyZkzmitMUFR+IcH0+qXvgiYlNQgTbXREOOd0RzhN0=
X-Google-Smtp-Source: AKy350YWTFfJst7dKdvd/QQg+FkPCRl2QAzzdXcTfyafqdZiiF68VJyzEVlIMbBlm1jg8lLVe4JPsvMSNl39JQLSrHw=
X-Received: by 2002:a25:2f84:0:b0:b6e:d788:eba0 with SMTP id
 v126-20020a252f84000000b00b6ed788eba0mr21658366ybv.11.1680459422499; Sun, 02
 Apr 2023 11:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <CALy08mb+6uq=ds2fVZ2B8YF5P4FvZgMsD0qx3ZTEY6EuFJ2ADw@mail.gmail.com>
In-Reply-To: <CALy08mb+6uq=ds2fVZ2B8YF5P4FvZgMsD0qx3ZTEY6EuFJ2ADw@mail.gmail.com>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Sun, 2 Apr 2023 23:45:12 +0530
Message-ID: <CAKi7+wdhri-BAD8UzzS6oG3uCZMW17RoRfa5HX9ShFLNnu6QHA@mail.gmail.com>
Subject: Re: Does fio support running workload with NVMe-oF on top of SPDK?
To:     Sadman Sakib <sadmankiba@gmail.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Sadman,

Yes you can run fio on NVMe-oF fabrics setup with xnvme ioengine,
using the SPDK driver.
Configuring subsystem can be done via:
https://github.com/spdk/spdk/blob/master/scripts/rpc.py

To run fio you just need to specify the backend as SPDK, namespace id
and filename which will contain address and port. Something like this:
--xnvme_be=3D"spdk"
--xnvme_dev_nsid=3D"1"
--filename=3D"192.168.100.8\:4420"

There is also a spdk ioengine, but not part of the fio source code and
it's maintained in the spdk repository.
If you want to run spdk ioengine directly without xnvme, please check:
https://github.com/spdk/spdk/tree/master/examples/nvme/fio_plugin

Regards
Ankit

On Sat, Apr 1, 2023 at 7:30=E2=80=AFAM Sadman Sakib <sadmankiba@gmail.com> =
wrote:
>
> Hi,
>
> I was wondering if Fio supports running workload on remote SSD with
> NVMe-oF on top of SPDK. I was able to run fio on local SSD with
> "xnvme" engine on top of xNVMe driver, which builts on SPDK driver. I
> followed the "xNVMe ioengine Part 2" guide in fio-blog repository. The
> job file I used is as below:
>
> [job1]
> ioengine=3Dxnvme
> xnvme_dev_nsid=3D1
> thread=3D1
> rw=3Drandread
> bs=3D4k
> filename=3D0000\:22\:00.0
> direct=3D1
> iodepth=3D1
> size=3D1G
>
> I was also able to run workload on NVMe-oF with SPDK perf example that
> is shipped with SPDK using a command like below-
> spdk_nvme_perf -q 128 -o 4096 -w randread -r 'trtype:RDMA adrfam:IPv4
> traddr:192.168.100.8 trsvcid:4420' -t 300
>
> So, I think to run Fio with NVMe-oF on SPDK, I will need to set
> transport type, address and port with fio options. But, I did not find
> such options in the fio doc page. Does fio currently support NVMe-oF
> on top of SPDK which may not be documented in the doc page?
>
> Best,
> Sadman
