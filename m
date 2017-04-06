Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:36421 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdDFUSW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Apr 2017 16:18:22 -0400
Received: by mail-vk0-f42.google.com with SMTP id s68so53987664vke.3
        for <fio@vger.kernel.org>; Thu, 06 Apr 2017 13:18:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8A97F2CE-0E54-4E15-8C11-DA4E09558107@nutanix.com>
References: <b83e861c86f9423b947b12336d08e75b9e6d80d437aa41ab8775f7673db0ecf8BL2PR02MB19712B5A9DD0B600FC59ABC8810A0@BL2PR02MB1971.namprd02.prod.outlook.com>
 <CABtFm2UGCb55eCivd9rG6f8Nz7h0HNTK+cCFY-BwoCo3q8+bYA@mail.gmail.com> <8A97F2CE-0E54-4E15-8C11-DA4E09558107@nutanix.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 6 Apr 2017 21:17:51 +0100
Message-ID: <CALjAwxhc8d9_2pacEoZrJVjZAy_AiNn_QrCKooZCuz=OYiMPCg@mail.gmail.com>
Subject: Re: FIO does 2x IOPS with 'bssplit' option and 'rw=randwrite or rw=randread'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: GV Govindasamy <gv.govindasamy@nutanix.com>
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

HI,

On 6 April 2017 at 17:46, GV Govindasamy <gv.govindasamy@nutanix.com> wrote=
:
> Thank you, Yes. when I remove =E2=80=9Crate_process=3Dpoisson=E2=80=9D, t=
he IOPS are down to about 85% - 90%.
>
> I checked with rate_iops=3D100 and rate_iops=3D1000. In both cases, I got=
 85%-90% of rate_iops given.
>
> How do I accomplish 100% of IOPS?

>     > [db-oltp-w]
>     > bssplit=3D8k/90:16k/10,,
>     > size=3D128G
>     > filename=3D/dev/sdg
>     > rw=3Drandread
>     > iodepth=3D8
>     > rate_iops=3D100

It seems to be a quirk of using bsplit with rate_iops. If the
difference between the bsplit sizes is larger then the drop in the
iops achieved will be even higher...

--=20
Sitsofe | http://sucs.org/~sits/
