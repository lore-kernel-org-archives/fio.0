Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:63141 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaGHBj4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 7 Jul 2014 21:39:56 -0400
Received: by mail-vc0-f182.google.com with SMTP id il7so4746043vcb.41
        for <fio@vger.kernel.org>; Mon, 07 Jul 2014 18:39:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9E26C6259ACF1842A4815F929194EDD394B57968@phex01.corp.bitmicro.com>
References: <CAFTxqD8+B7BbUCAE5Md2Ro8y4c1FNYV_AZnOT1OvpJd4H2vQ_Q@mail.gmail.com>
	<CAFTxqD-R2AzHnq8B-QEGhkLSb_ftzjQ6evAgOiQn9DR0koHKXw@mail.gmail.com>
	<9E26C6259ACF1842A4815F929194EDD394B57968@phex01.corp.bitmicro.com>
Date: Mon, 7 Jul 2014 18:39:55 -0700
Message-ID: <CAF+0mv==eRemW_AKeZHb1mx4YMjFGWV2pgrohAMxE_0f_STe-g@mail.gmail.com>
Subject: Re: Mix Sequential & Random Access
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Jul 7, 2014 at 12:30 AM, Ritchie Babaylan
<Ritchie.Babaylan@bitmicro.com> wrote:
> Hi,
>
> I am confuse currently of string to put on rw= for the access profile below.
>
>         30% seq 60% read; 8KB
>         60% seq 30% read; 8KB
>
>
> My config file was written in this matter.
>
> [global]
> ioengine=libaio
> direct=1
> ba=4kb
> iodepth=4
> numjobs=4
> runtime=300
> ramp_time=180
> time_based
> group_reporting
> filename=/dev/sdb1
>
> [job-1]
> description=30% seq 60% read - 8kb
> stonewall
> bs=8kb
> percentage_random=60
> rwmixread=60
> rwmixwrite=40
> rw=??
>
> [job-2]
> description=60% seq 30% read - 8kb
> stonewall
> bs=8kb
> percentage_random=40
> rwmixread=30
> rwmixwrite=70
> rw=??
>
>
> Appreciate any help on this matter.
>
>
> Thanks,
> Ritchie Babaylan
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

You should use rw=randrw
