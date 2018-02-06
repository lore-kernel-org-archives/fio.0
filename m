Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36295 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbeBFORD (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Feb 2018 09:17:03 -0500
Received: by mail-vk0-f48.google.com with SMTP id m197so1191842vka.3
        for <fio@vger.kernel.org>; Tue, 06 Feb 2018 06:17:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a4f3cafa-dd28-28aa-551e-85cb27cf234d@cmaisonneuve.qc.ca>
References: <a4f3cafa-dd28-28aa-551e-85cb27cf234d@cmaisonneuve.qc.ca>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 6 Feb 2018 14:16:32 +0000
Message-ID: <CALjAwxhMC7wt6U+EKNvFeo8EoHKyZqkO5qiCac7TNg7ZJJPvLg@mail.gmail.com>
Subject: Re: Curious randwrite results on raid10 md device
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgQ2hhcmFvdWk=?= <jcharaoui@cmaisonneuve.qc.ca>
Cc: fio <fio@vger.kernel.org>

On 5 February 2018 at 04:33, J=C3=A9r=C3=B4me Charaoui
<jcharaoui@cmaisonneuve.qc.ca> wrote:
>
> I've been running some tests on a bunch of disks lately and came across
> a strange result that I'm struggling to explain.
>
> I built a 20-device raid10 md array with SSDs and ran several fio tests
> on it. The randwrite test really stands out because the IOPS starts out
> fairly low, around 800 IOPS, but within a few seconds climbs up to about
> 70K IOPS, which is nearly three times higher than the IOPS I'm getting
> with the randread test (25K).
>
> I tried disabling the drive caches using hdparm -W 0, and also disabling
> the internal write-intent bitmap on the md array, but the results are
> the same.

You didn't include the fio job you're using (see
https://github.com/axboe/fio/blob/fio-3.3/REPORTING-BUGS ) so it's
impossible to say anything too useful. I'd check whether a solo SSD by
itself exhibits similar variation. It's also worth noting the order
you read data back compared to how it was written can impact an SSD
(see http://codecapsule.com/2014/02/12/coding-for-ssds-part-5-access-patter=
ns-and-system-optimizations/
) but I wouldn't have thought it should be to such a degree. Perhaps
http://vger.kernel.org/vger-lists.html#linux-raid or
http://vger.kernel.org/vger-lists.html#linux-block might give better
replies...

--=20
Sitsofe | http://sucs.org/~sits/
