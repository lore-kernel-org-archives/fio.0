Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35485 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgA3IlN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Jan 2020 03:41:13 -0500
Received: by mail-wr1-f54.google.com with SMTP id g17so2997038wro.2
        for <fio@vger.kernel.org>; Thu, 30 Jan 2020 00:41:12 -0800 (PST)
Received: from [10.0.1.35] (ip-213-127-252-215.ip.prioritytelecom.net. [213.127.252.215])
        by smtp.gmail.com with ESMTPSA id q124sm14099215wme.2.2020.01.30.00.41.10
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 00:41:10 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Louwrentius <louwrentius@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: Strange benchmark results of SSD - any ideas
Date: Thu, 30 Jan 2020 09:41:09 +0100
Message-Id: <B6E610B0-856D-411B-9712-CDAFFB6B461D@gmail.com>
References: <CALjAwxjzn8KR2H7dRz9w+EEnkaepdz1Zp4KU38ZWokXmHYh9-Q@mail.gmail.com>
In-Reply-To: <CALjAwxjzn8KR2H7dRz9w+EEnkaepdz1Zp4KU38ZWokXmHYh9-Q@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: fio <fio@vger.kernel.org>

Ok thanks a lot for the feedback, I=E2=80=99ll take your comments to heart.

> On 30 Jan 2020, at 08:34, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>=20
> =EF=BB=BFOn Wed, 29 Jan 2020 at 23:14, Louwrentius <louwrentius@gmail.com>=
 wrote:
>>=20
>> Thanks a lot for your reply. I have not erased or trimmed the drives.
>> I actually wanted to see how the SSDs would behave under worst
>> possible circumstances.
>> But maybe this causes me comparing apples to oranges.
>=20
> To do this fairly, you really would have to the same preconditioning
> from an "empty" device on all of them before starting your benchmark.
> See the links in the previous email for more on that.
>=20
>> So the explanation for the golden gate bridge pattern could be an
>> interaction between the benchmark and the garbage collection kicking
>> in.
>> Maybe if I do erase the drive properly, mark all blocks as empty, the
>> pattern should be gone and look more like the intel?
>=20
> That's the hope. If it is garbage collection related, starting with
> all the blocks erased will hopefully make it take much longer before
> garbage collection has to kick in. It could be some SSDs had more
> empty cells than others or were better at garbage collecting or had
> been written with a data pattern in the past more amenable to the
> workload you're doing now etc.
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/

