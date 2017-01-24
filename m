Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33628 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdAXKDF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Jan 2017 05:03:05 -0500
Received: by mail-wm0-f50.google.com with SMTP id d140so41322808wmd.0
        for <fio@vger.kernel.org>; Tue, 24 Jan 2017 02:03:04 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <974E4982-D808-4CAF-ACCF-85866C0050A7@intel.com>
 <c7fc722c-f3ca-4abe-7202-8ca67b5e59a0@gmail.com>
 <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <652647e7-94f2-d897-2eff-72c0d73b09e8@gmail.com>
Date: Tue, 24 Jan 2017 11:03:02 +0100
MIME-Version: 1.0
In-Reply-To: <9D5B6947-2DF8-46B9-AEAD-62132C19A0D3@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

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

It doesn't work with LBAFormat=3 either:

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ sudo isdct start 
-nvmeformat -intelssd 0 \
 >   LBAFormat=3 \
 >   SecureEraseSetting=0 \
 >   ProtectionInformation=0 \
 >   MetaDataSettings=0
WARNING! You have selected to format the drive!
Proceed with the format? (Y|N): y
Formatting...

- Intel SSD DC P3608 Series CVF8551400324P0DGN-1 -

Status : Interrupted system call

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ sudo isdct show -all 
-intelssd 0 | grep LBA
LBAFormat : 0
MaximumLBA : 3907029167
NativeMaxLBA : 3907029167
NumLBAFormats : 6

-----

And using exactly the same parameters as the article above:

oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$ time sudo isdct start 
-nvmeformat -intelssd 0 \
 >   LBAFormat=3 \
 >   SecureEraseSetting=2 \
 >   ProtectionInformation=0 \
 >   MetaDataSettings=0
WARNING! You have selected to format the drive!
Proceed with the format? (Y|N): y
Formatting...

- Intel SSD DC P3608 Series CVF8551400324P0DGN-1 -

Status : Interrupted system call


real	0m26.901s
user	0m0.048s
sys	0m0.032s
oberstet@svr-psql19:~/scm/parcit/RA/user/oberstet$


----

I see the following in kernel log:

[417528.128501] nvme nvme0: I/O 0 QID 0 timeout, reset controller
[417786.440977] nvme nvme0: I/O 0 QID 0 timeout, reset controller


What should I do?

Thanks alot,
/Tobias
