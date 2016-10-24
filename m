Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:40260 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbcJXRuU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 24 Oct 2016 13:50:20 -0400
Received: by mail-ua0-f182.google.com with SMTP id u14so3831141uau.7
        for <fio@vger.kernel.org>; Mon, 24 Oct 2016 10:50:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOHuL9h5c-tNKqf-79a_UWDTBANLd+jAS4qJTFdVdTYpKqCLGg@mail.gmail.com>
References: <CAOHuL9gEd8VoDuyirSosdTwyQETskOgTvCyEGEPJoDEQS+9K=A@mail.gmail.com>
 <DF4PR84MB0169198E7CB58F942068F566ABD70@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAF+0mvnc2kyMroFSoXT8FHck54DmHvPmEBfvyvHfuqeChk4ssA@mail.gmail.com> <CAOHuL9h5c-tNKqf-79a_UWDTBANLd+jAS4qJTFdVdTYpKqCLGg@mail.gmail.com>
From: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Date: Mon, 24 Oct 2016 10:50:18 -0700
Message-ID: <CAOmo8Da6qCB8Qmj5OwnxTitTweYJ_WrMjLSEwrNhDw3XYkyENQ@mail.gmail.com>
Subject: Re: Results too good to be true?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tarek <cashew250@gmail.com>
Cc: Matthew Eaton <m.eaton82@gmail.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

2016-10-24 10:24 GMT-07:00 Tarek <cashew250@gmail.com>:
> Matthew
>
> That is a good point, I typically do but had a bug in this latest
> script that ran blkdiscard prior to any fio test. I will rerun and
> report back.
>
> Thanks
>

There is whole documented devoted to performance testing and steps
required to gather reliable data.

http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.1.pdf

I think since you are doing randread workload preconditioning
shouldn't matter too much.
It mostly matters for write operations.
It seems like your workload fetches all the data from kind of cache.
Maybe cache on SSD side.
You can easily investigate it by reading the log pages. C1/C2 for Intel drives.
See http://www.intel.com/content/www/us/en/solid-state-drives/ssd-dc-p3600-spec.html
for details.

Regards,
Andrzej
