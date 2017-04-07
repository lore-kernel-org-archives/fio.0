Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35416 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbdDGFx5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Apr 2017 01:53:57 -0400
Received: by mail-vk0-f48.google.com with SMTP id r69so64372350vke.2
        for <fio@vger.kernel.org>; Thu, 06 Apr 2017 22:53:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E2F79123-964F-43E9-BEC3-E5BCE287BFE3@nutanix.com>
References: <BL2PR02MB19714074E460C8EA219FFA85810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
 <CALjAwxgrt8byoEsSkjaSNbPiXg69+P2bH=+yGpoFs3ZKpJNnRg@mail.gmail.com> <E2F79123-964F-43E9-BEC3-E5BCE287BFE3@nutanix.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 7 Apr 2017 06:53:26 +0100
Message-ID: <CALjAwxg+jgV8GUcE6L2T9o6U0vB2AbQAQNDXv0ps8zs-XxHn7A@mail.gmail.com>
Subject: Re: FIO achieves only 50:50 of read:write IOPS when rwmix is not
 50:50 and achieves only about 40% of total IOPS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: GV Govindasamy <gv.govindasamy@nutanix.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 6 April 2017 at 22:13, GV Govindasamy <gv.govindasamy@nutanix.com> wrote=
:
> Thanks Sitsofe. After removing =E2=80=9Crate_process=3Dpoisson=E2=80=9D a=
nd giving =E2=80=9Crate=3D<in-bytes>=E2=80=9D, I can see the IOPS I have ca=
lculated for. In this case, 90 read ops and 10 write ops.
>
> =E2=80=9Crate_process=3Dpoisson=E2=80=9D is a bug in this case then?

I'd say so because I'd have expected each I/O direction to have
poisson applied to it independently of other I/O directions IF it has
a differing submission rate to other I/O directions. Without doing
this I'm unsure how the rates achieved could be independent of each
other.

--=20
Sitsofe | http://sucs.org/~sits/
