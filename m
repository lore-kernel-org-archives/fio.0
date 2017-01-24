Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36858 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdAXJqp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jan 2017 04:46:45 -0500
Received: by mail-wm0-f44.google.com with SMTP id c85so172263347wmi.1
        for <fio@vger.kernel.org>; Tue, 24 Jan 2017 01:46:45 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <974E4982-D808-4CAF-ACCF-85866C0050A7@intel.com>
 <c7fc722c-f3ca-4abe-7202-8ca67b5e59a0@gmail.com>
 <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <3a817d19-a507-9ddc-f16d-6bc83dbbd0eb@gmail.com>
Date: Tue, 24 Jan 2017 10:46:42 +0100
MIME-Version: 1.0
In-Reply-To: <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Andrey,

Am 23.01.2017 um 20:06 schrieb Kudryavtsev, Andrey O:
> Hi Tobias,
> Yes, “imsm” is in generic release, you don’t need to go to the latest or special build then if you want to stay compliant. It’s mainly a different layout of a raid metadata.
>
> Your findings follow my expectations, for QD1 sync engine does good results. Can you try libio with QD4 and 2800/4 jobs?
> Most of the time I’m running Centos7 either with 3.10 or latest kernel depends of the scope of the testing.
>
> Changing sector to 4k is easy, this can really help. see DCT manual, it’s there.
> This can be relevant for you https://itpeernetwork.intel.com/how-to-configure-oracle-redo-on-the-intel-pcie-ssd-dc-p3700/
>
>

I have gone through the whole manual, but I cannot find info about the 
meaning of different LBAFormats.

The Oracle article above uses

LBAFormat=3

which I presume means 4k secor size.

The P3608 seams to support a value up to 6:

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ sudo isdct show -all 
-intelssd 0 | grep LBA
LBAFormat : 0
MaximumLBA : 3907029167
NativeMaxLBA : 3907029167
NumLBAFormats : 6

So is this the correct mapping for the value?

LBAFormat	Sector Size
0	512
1	1024
2	2048
3	4096
4	8192
5	16384
6	32768

In this case, I'd use

LBAFormat=4

to get 8k sectors, sine my workload is purely 8k.

Cheers,
/Tobias

