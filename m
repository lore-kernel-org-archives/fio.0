Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6611DC433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 07:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbiAQHtD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 02:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbiAQHtC (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 02:49:02 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFD7C061574
        for <fio@vger.kernel.org>; Sun, 16 Jan 2022 23:49:02 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q75so2420950pgq.5
        for <fio@vger.kernel.org>; Sun, 16 Jan 2022 23:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iaRvs715EsxsSycp6UAGm9LP2VthtQmtdTUNy8VsPVo=;
        b=CLgWNK5a/bDkfwkJWbHruHZ7TLKkgaE02DGVNopmm/t5emUmLcp05PTecxf6hkGVS4
         DGF2cRtyAiy/ZBTYbJNk2ZNZWPhkOHl//q5/LW20loeD4RHc/PymZfZ3MdcDaWxaZuUE
         dCtcGdxZiYUFGoGTPk+ewz0RPP1N0JrUj6kw8VoSkVBfgmyyIpjQ+7rQK0mwp9yu6jhn
         6mozvsO/nmZ/MncsTthRgqaH5KoZs57RFDgAQzajg5/5WI65mHk1BbR1Q8svDEtqdfxR
         LgMsaQiBmhFOqrEuboMeiCQYTsmeSS8n9sNNZB/1LjwmPR6jfY7sFvJ9EwQOVTpg9gbX
         /WTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iaRvs715EsxsSycp6UAGm9LP2VthtQmtdTUNy8VsPVo=;
        b=NOI2kD7nc5a8uuzrJkKrjlGXdJ+BAGA3DSuJJvYSEVFIFWmGaIZu7pYJaESZ9yS0bs
         +apK+U2fibbGiZSjtFGeadn1FyGxW0oros3NamtynJw/yLDeEWsgd7pRVGIcUIOk7nhx
         Zsidhtxu69cKcoXVoWCP7Sk+eanF5tUvsTNmaKpf5Vy8vtDhQe5tlFcVzKVfXrCvIjGM
         SgLIND5FZ1aICy4xGRqxrpVml1ndI75oOMtwPMfN5oqJA0rjOiPbP9ugr2v2bxYXVO33
         ARgWpmMr8NZa/h7poytctRBS6cAQkfxdug0u20FO2KHBw5HGA8tRHPFE4ousQw6f0AzF
         3FNQ==
X-Gm-Message-State: AOAM530At1oqGkU4SZe7v0FCHdcZk6D3iUkigj7KxYsvVmJNg2JGZDvy
        CfD2f0rAp9gT4cHNvGPstOwanrDKGa6ZCZPIytADDAlRnmk=
X-Google-Smtp-Source: ABdhPJy4VwxjBculV9wE918BCYkbPaKkGiiKw7gCfkvhfJ9BMGDQVX6KBixr9rYdyM+5PRo50L3jU5NYIPe3srM0W7s=
X-Received: by 2002:a05:6a00:26c5:b0:4bd:4ad6:9c71 with SMTP id
 p5-20020a056a0026c500b004bd4ad69c71mr19832481pfw.45.1642405741702; Sun, 16
 Jan 2022 23:49:01 -0800 (PST)
MIME-Version: 1.0
References: <CAA4OwwXP+YTqcGdsS6Dbi7WwCQh1HRTd=4zc=e3ytMmn8Ke=Zw@mail.gmail.com>
 <17570043-aa80-3ed1-3fd0-23eb235f0d0b@opensource.wdc.com> <CAA4OwwVU9Pg595xu99E621f-LspUcDd=sg2zOqZ_jyTTfPQaaw@mail.gmail.com>
 <CAM5EYbmExSVAtEKzYWE+quTQk-5J4iSnnW4+qoMLg0+MF5sbJw@mail.gmail.com>
In-Reply-To: <CAM5EYbmExSVAtEKzYWE+quTQk-5J4iSnnW4+qoMLg0+MF5sbJw@mail.gmail.com>
From:   Robert Balogh <ethrbh@gmail.com>
Date:   Mon, 17 Jan 2022 08:48:50 +0100
Message-ID: <CAA4OwwVv+364MrZ8=1zUrWf2-+uechnkmdLVj_aa176H3pA2sw@mail.gmail.com>
Subject: Re: FIO performance measurement between volumes
To:     Ben England <bengland@redhat.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

hello Ben,

Thanks for your reply. I will try out how dd works for me.

thanks again,
/Robi

On Fri, Jan 14, 2022 at 2:59 PM Ben England <bengland@redhat.com> wrote:
>
> dd can do this.   Beware of caching effects, you can drop cache + use dd =
conv=3Dfsync  to ensure the data makes it to the target volume.
>
> On Fri, Jan 14, 2022 at 2:48 AM Robert Balogh <ethrbh@gmail.com> wrote:
>>
>> hello Damien,
>>
>> Thanks for your quick reply. I am afraid I made a mistake to not
>> describe clearly what my goal is. So I can perform the FIO test for
>> the 2nd attached volume similar to what is done for the 1st volume.
>> But now I would like to do a performance measurement between the
>> volumes.
>>
>> So my idea is, there is a e.g: 10G size file stored in volume1, and
>> this file is going to write to volume2, then read back. But now, I am
>> not sure this can be done with the FIO tool.
>>
>> Thanks for your help.
>> /Robi
>>
>> On Fri, Jan 14, 2022 at 12:20 AM Damien Le Moal
>> <damien.lemoal@opensource.wdc.com> wrote:
>> >
>> > On 1/13/22 20:47, Robert Balogh wrote:
>> > > hello FIO experts,
>> > >
>> > > I am a beginner in FIO, and I met with a problem.
>> > >
>> > > Currently in my Ubuntu based server the "/dev/vdb1" volume is attach=
ed
>> > > to the "/home/batman/fio/cindervolume" path. FIO job is configured
>> > > like this
>> > >
>> > >     [global]
>> > >     filename=3Dfio-172_20_2_13
>> > >     directory=3D/home/batman/fio/cindervolume rw=3Drw
>> > >     rwmixread=3D60
>> > >     rwmixwrite=3D40
>> > >     bs=3D4k
>> > >     rate=3D500k
>> > >     direct=3D1
>> > >     numjobs=3D1
>> > >     time_based=3D1
>> > >     runtime=3D14d
>> > >     verify=3Dcrc32c
>> > >     continue_on_error=3Dall
>> > >     group_reporting=3D1
>> > >
>> > >     [file1]
>> > >     iodepth=3D1
>> > >     ; -- end job file --
>> > >
>> > > FIO is started like this and works well:
>> > >     /usr/bin/fio --size=3D10G
>> > > --output=3D/home/batman/fio/cindervolume/fio-172_20_2_13-process.log
>> > > /home/batman/fioApp/fio-seq-RW.job &
>> > >
>> > > FIO version I use: fio-3.25
>> > >
>> > > My next step would be to attach a 2nd volume for example "/dev/vdc" =
to
>> > > "/home/batman/fio/cindervolume-2" path, and I would do performance
>> > > measurement between the volumes. I was checking the FIO user=E2=80=
=99s guide,
>> > > https://fio.readthedocs.io/en/latest/fio_doc.html but unfortunately =
I
>> > > cannot figure out which parameter might help me to solve this topic.
>> > >
>> > > By-the-way is this possible to do with FIO? If so, could you please
>> > > help me by giving some direction/hints?
>> >
>> > Move the directory=3D/... option from global section into the job sect=
ion
>> > and add a job for your other volume with directory=3D again added in t=
hat
>> > job section to point to the new volume directory. The 2 jobs will run
>> > simultaneously targetting different volumes, unless you add "stonewall=
",
>> > in which case the jobs will run one after the other.
>> >
>> > Or you could just write another fio script for the second volume.
>> >
>> > It is not clear if you want to run the perf tests on the 2 volumes in
>> > parallel or one after the other.
>> >
>> > >
>> > > thanks for your help,
>> > >
>> > > /Robi
>> >
>> >
>> > --
>> > Damien Le Moal
>> > Western Digital Research
>>
