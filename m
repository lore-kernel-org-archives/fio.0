Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34841 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583Ab2C3CPr convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 29 Mar 2012 22:15:47 -0400
Received: by obbeh20 with SMTP id eh20so286539obb.19
        for <fio@vger.kernel.org>; Thu, 29 Mar 2012 19:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
References: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Fri, 30 Mar 2012 10:15:26 +0800
Message-ID: <CAC8teKVFYWs4xv_AisdEB5=qGfHCqD1t4iz2C_B1N_xUBYEybw@mail.gmail.com>
Subject: Re: odd result with iodepth
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: fio@vger.kernel.org

2012/3/30 Chuck Tuffli <ctuffli@gmail.com>:
> I've been testing disk performance using fio, and am seeing results I
> can't explain. This may not necessarily be a problem with fio, or
> perhaps I'm not using the some of the parameters correctly. The
> testing uses the latest fio.git on a RHEL system running a 2.6.32
> kernel.
>
> The fio test is:
>
> fio --name=global --ioengine=libaio --rw=read --bs=512 --size=500m
> --iodepth=32 --direct=1 --filename=/dev/sdb --name=job1
>
> The IOPs reported in this case appears to correlate with an external analyzer.
>
> If I change the iodepth to 64, fio reports double the IOPs reported in
> the previous case, but the performance measured by the analyzer is the
> same as in the iodepth=32 case (i.e. half what fio reports). I tried
> the iodepth=64 case with another disk performance tool, and it is
> reporting the same results as the external analyzer.
>
> Interestingly, using iodepth=32 and adding a second job (--name=job2)
> seems to have the same effect as iodepth=64 (reported performance is
> 2x compared to the external analyzer).
>
> Am I doing something obviously wrong? What else can/should I check? TIA
>
> ---chuck
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Can you see the same result if using  --rw=randread?

--
Regards,
Zhu Yanhai
