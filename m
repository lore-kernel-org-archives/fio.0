Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14CFC433F5
	for <fio@archiver.kernel.org>; Fri, 14 Jan 2022 07:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiANHsF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Jan 2022 02:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiANHsF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jan 2022 02:48:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CD0C061574
        for <fio@vger.kernel.org>; Thu, 13 Jan 2022 23:48:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso12299426pjd.1
        for <fio@vger.kernel.org>; Thu, 13 Jan 2022 23:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KN6asvc/CKDjVO3pd1JuPl5CjXP/47+M/Yn3cwX/UJA=;
        b=lfSaodMecwjrEFNwGli80Gac3OFn800KN6XXE9dTJtuJIvmazWfUOaqDAZUYh/6nqu
         oEzNqE2HFJ100MG5CcKbej+qziHdl19o3e8jSnbDKsxY71ha5i3XgrwanHvlY2uYKugi
         /c5h/+W/HHgPhgGSL4AXNRr/iNuYczqD+nsCuZ4Se3nL0UnhdvYxd7JdQufHxsrAbkNZ
         DsdYr82lRA/r6k7Exkvq/feonDEnGz3hLge31h3AwkA7hCPe098DQPhf3B65ATlv3B/i
         oosTlwo4iKDjuPkuIpPp1yfmshvO9WiB5at2ewf1UlppCEx6095DSdZqvMXK9iPhSlS7
         43yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KN6asvc/CKDjVO3pd1JuPl5CjXP/47+M/Yn3cwX/UJA=;
        b=zhGD+W58y2mY74x3/WXeKvRY9n4yR0jHyKA/xt1d/EKT7fG1GY2l6a/kag9x3MeK+R
         ReOS7km7j/UHzOu3Q1LK+nDVLyyPA2HtI1AgMxGI8B9CcO/x/RDpX77dJFGcTGzCBJC9
         2kZxklR4PPNsct5o4ZlG2uYZZNdHAjFgsBqbGWfgck13BZ62hScnvI/i7qzneOlas4c0
         xak5groE2CvYaNOfTPoSrGuo3OsXBy2ZJ6cSJi8xIAu+vLn8/xHqz/223N6+VMdRzXDC
         YWMwDeA1eCRbqdCAfdTI9/D0oD0duYDhZmJBGoQ/Xl9a1QW5Ql60BurEMD4xECK0Llj0
         /UYg==
X-Gm-Message-State: AOAM533pwhVu7bkyidXoOjxnkgH0nHiEVayfwy/JOPp8rtN4ibLPpS9M
        d+JHmM/1GOaJwImtvpv0O50uHBGMk+t8JVnU1AyIDMRgOPs0iKrr
X-Google-Smtp-Source: ABdhPJwWLPtm9PmmVwU9TTyS/YO1HWUuWlvxe2J8iqXRHNQT8JHaizTJrfmab4YzEaAk+Ux+IZZ+xGc2eynjf2upyk0=
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr9542685pjb.4.1642146484267;
 Thu, 13 Jan 2022 23:48:04 -0800 (PST)
MIME-Version: 1.0
References: <CAA4OwwXP+YTqcGdsS6Dbi7WwCQh1HRTd=4zc=e3ytMmn8Ke=Zw@mail.gmail.com>
 <17570043-aa80-3ed1-3fd0-23eb235f0d0b@opensource.wdc.com>
In-Reply-To: <17570043-aa80-3ed1-3fd0-23eb235f0d0b@opensource.wdc.com>
From:   Robert Balogh <ethrbh@gmail.com>
Date:   Fri, 14 Jan 2022 08:47:53 +0100
Message-ID: <CAA4OwwVU9Pg595xu99E621f-LspUcDd=sg2zOqZ_jyTTfPQaaw@mail.gmail.com>
Subject: Re: FIO performance measurement between volumes
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

hello Damien,

Thanks for your quick reply. I am afraid I made a mistake to not
describe clearly what my goal is. So I can perform the FIO test for
the 2nd attached volume similar to what is done for the 1st volume.
But now I would like to do a performance measurement between the
volumes.

So my idea is, there is a e.g: 10G size file stored in volume1, and
this file is going to write to volume2, then read back. But now, I am
not sure this can be done with the FIO tool.

Thanks for your help.
/Robi

On Fri, Jan 14, 2022 at 12:20 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 1/13/22 20:47, Robert Balogh wrote:
> > hello FIO experts,
> >
> > I am a beginner in FIO, and I met with a problem.
> >
> > Currently in my Ubuntu based server the "/dev/vdb1" volume is attached
> > to the "/home/batman/fio/cindervolume" path. FIO job is configured
> > like this
> >
> >     [global]
> >     filename=3Dfio-172_20_2_13
> >     directory=3D/home/batman/fio/cindervolume rw=3Drw
> >     rwmixread=3D60
> >     rwmixwrite=3D40
> >     bs=3D4k
> >     rate=3D500k
> >     direct=3D1
> >     numjobs=3D1
> >     time_based=3D1
> >     runtime=3D14d
> >     verify=3Dcrc32c
> >     continue_on_error=3Dall
> >     group_reporting=3D1
> >
> >     [file1]
> >     iodepth=3D1
> >     ; -- end job file --
> >
> > FIO is started like this and works well:
> >     /usr/bin/fio --size=3D10G
> > --output=3D/home/batman/fio/cindervolume/fio-172_20_2_13-process.log
> > /home/batman/fioApp/fio-seq-RW.job &
> >
> > FIO version I use: fio-3.25
> >
> > My next step would be to attach a 2nd volume for example "/dev/vdc" to
> > "/home/batman/fio/cindervolume-2" path, and I would do performance
> > measurement between the volumes. I was checking the FIO user=E2=80=99s =
guide,
> > https://fio.readthedocs.io/en/latest/fio_doc.html but unfortunately I
> > cannot figure out which parameter might help me to solve this topic.
> >
> > By-the-way is this possible to do with FIO? If so, could you please
> > help me by giving some direction/hints?
>
> Move the directory=3D/... option from global section into the job section
> and add a job for your other volume with directory=3D again added in that
> job section to point to the new volume directory. The 2 jobs will run
> simultaneously targetting different volumes, unless you add "stonewall",
> in which case the jobs will run one after the other.
>
> Or you could just write another fio script for the second volume.
>
> It is not clear if you want to run the perf tests on the 2 volumes in
> parallel or one after the other.
>
> >
> > thanks for your help,
> >
> > /Robi
>
>
> --
> Damien Le Moal
> Western Digital Research
