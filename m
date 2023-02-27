Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313DFC7EE2E
	for <fio@archiver.kernel.org>; Mon, 27 Feb 2023 18:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjB0SPX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 27 Feb 2023 13:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjB0SPU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Feb 2023 13:15:20 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287B8212B5
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 10:15:17 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id s12so7627287qtq.11
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 10:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHh4wbR7rFT+7CCGLLFfiBCe0Rqhv57o7Vma67U4Vc0=;
        b=N3lWUbG9oe5tq1Fhxwv5CHDi1L+TRzsM8MvrtpxWOUgQJwgGdURj0pjrACa4T10D1t
         WlraGPhCyG7E/Hd+FbachwhPmnxxysuWeDhHX6z/zVzRJfm5ov6HV5vCGKySEw/d9LgB
         IpfLZdZcAiFZIbt71xUchF+S/4w1IgmbABnM9tdil0iCke7a+SlhdueYn/qhASnRhmcS
         tsDSBUVFsUKLBUdpYFwa79Lzq2u8nBWBTpFcqfb18UX1nm4NiGw2arZZoZ3zz+YFXh5+
         tepvhLMoELU/nYERu7wmSZ9XOq3atHGtaSyUeAfdfHCJFMWWc2loz5P9ZUD1FaoF4IPH
         HE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QHh4wbR7rFT+7CCGLLFfiBCe0Rqhv57o7Vma67U4Vc0=;
        b=VIET9d4jO0iWEGW2lpuYQ4zzkG3TD28OYpKRBlot/REuM2zP0wB21pjtyZUhykof1s
         lRFHs0ds6XHY0lWI/pQtowRH07KDi9qnuprOtBSm36kDRDt67gu4EmkO8NAf3samR2O0
         OZlFe7vodlob4wpc6N8l1wtLSfzs6wstNSuYtX6BdWKPp+DsyP7ivNYucM9X6bNBAQYI
         tWOLqr/j1dRlTTbNBTTYDrQMGnoXDq7iF0QfHkQVghoAJUjYcPzMHjPxF8a8a97FPb6i
         s0rTtuV9SoDTAs+W98ItXUlrzPaNq69QPTXJkkZ2jfEx/O+A5/kxE1gXm5UiyjoHP0HD
         wVcw==
X-Gm-Message-State: AO0yUKUZTAH7myTt6Tlkfw9tBPtX80QVYJqgSfz4NJ5tw5Ps0MtUA7Fm
        Avz1CnGYAbD55ofmDmO5IF1mWP50BCE6Tj0ef46YRvAjipUZTw==
X-Google-Smtp-Source: AK7set/o1raO8I3mPRTmQdFJiScTE9bQtFqirftndqFelKW53uKPsDSVD6vSvx33bfpX+Ika/yJa72hrEEyU5lpPhx4=
X-Received: by 2002:ac8:5608:0:b0:3bf:e153:89d8 with SMTP id
 8-20020ac85608000000b003bfe15389d8mr56292qtr.0.1677521716157; Mon, 27 Feb
 2023 10:15:16 -0800 (PST)
MIME-Version: 1.0
References: <CAKJOkCpUwrGbXHF3xnwX_Q_XK7rPekdA+aXLDvZuSMOQKFN4HA@mail.gmail.com>
 <CAKi7+wfVLF7xmk8u3cZ_Ctwhii0c7UqHMfUdEDAhpf4XAJtG3Q@mail.gmail.com>
In-Reply-To: <CAKi7+wfVLF7xmk8u3cZ_Ctwhii0c7UqHMfUdEDAhpf4XAJtG3Q@mail.gmail.com>
From:   lokesh jaliminche <lokesh.jaliminche@gmail.com>
Date:   Mon, 27 Feb 2023 10:15:05 -0800
Message-ID: <CAKJOkCqWQmpauBVo3Xh=VC04ZP45+Bmrp=H9ioYTAsZu9_cV2Q@mail.gmail.com>
Subject: Re: thinktime and thinktime_iotime do not work as expected
To:     Ankit Kumar <ankit1455@gmail.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Ankit,

Thanks for the quick response.
The latest fio master branch works as expected, however
I still see more IO requests being issued.

Run status group 0 (all jobs):
READ: bw=3D1023B/s (1023B/s), 1023B/s-1023B/s (1023B/s-1023B/s),
io=3D20.0KiB (20.5kB), run=3D20001-20001msec

To investigate more I looked at the blktrace log we can see that
fio issues more requests per second even with
rate_ignore_thinktime. In the following blktrace logs, we can
see that in the first io phase, 2 requests were submitted and
in the second io phase, 3 IO requests were submitted. is there
any other parameter I should use to prevent this?

259,3 26 2 0.000003132 2713717 Q R 1650183824 + 8 [fio]
259,3 26 5 0.999898056 2713717 Q R 1692964272 + 8 [fio]
259,3 26 8 10.000133491 2713717 Q R 1699437744 + 8 [fio]
259,3 26 11 10.999891950 2713717 Q R 1675960000 + 8 [fio]
259,3 26 14 11.999888574 2713717 Q R 1671675368 + 8 [fio]

Thanks & Regards,
Lokesh

On Mon, Feb 27, 2023 at 9:45=E2=80=AFAM Ankit Kumar <ankit1455@gmail.com> w=
rote:
>
> Hi Lokesh,
>
> Can you please try out with the latest fio master branch.
> It should work as per the documentation.
>
> Regards
> Ankit Kumar
>
>
> On Mon, Feb 27, 2023 at 10:58=E2=80=AFPM lokesh jaliminche
> <lokesh.jaliminche@gmail.com> wrote:
> >
> >  Hi Everyone,
> >
> > As mentioned in the readthedocs, thinktime, and thinktime_iotime
> >  can be used to simulate the IO phase followed by the idle phase
> >  of the workload. For example, --thinktime_iotime=3D1s --thinktime=3D9s
> >  repeat the 10-second cycle with IOs for 1 second and stall for
> >  9 seconds. However, in my test for the first 10sec, fio keeps submitti=
ng
> >  without respecting thinktime and thinktime_iotime. After the first 10
> >  seconds fio starts simulating mentioned IO phases according to paramet=
ers.
> >  Following is my fio script.
> >
> > [global]
> > direct=3D1
> > runtime=3D20
> > time_based
> > [job_1]
> > rw=3Drandread
> > bs=3D4k
> > rate_iops=3D1
> > numjobs=3D1
> > ioengine=3Dlibaio
> > iodepth=3D1
> > offset=3D40G
> > size=3D30G
> > filename=3D/dev/nvme0n1p2
> > thinktime_iotime=3D1s
> > thinktime=3D9s
> > rate_ignore_thinktime=3D1
> >
> > Results:
> > Run status group 0 (all jobs):
> > READ: bw=3D2457B/s (2457B/s), 2457B/s-2457B/s (2457B/s-2457B/s),
> >  io=3D48.0KiB (49.2kB), run=3D20001-20001msec
> >
> > From the results, we can see that the total IO is 48KiB it should be
> >  ideally 8KiB.
> >
> > Is this a known issue?
> >
> > Thanks & Regards,
> > Lokesh
