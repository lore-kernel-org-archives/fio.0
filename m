Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f52.google.com ([209.85.217.52]:45477 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJKNAw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Oct 2018 09:00:52 -0400
Received: by mail-vs1-f52.google.com with SMTP id g201so7340505vsd.12
        for <fio@vger.kernel.org>; Wed, 10 Oct 2018 22:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions>
 <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions>
 <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com>
In-Reply-To: <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 11 Oct 2018 06:34:48 +0100
Message-ID: <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com>
Subject: Re: fio on vmware esxi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: eliezer@integritech.solutions
Cc: Mark.Beierl@dell.com, fio <fio@vger.kernel.org>

Hi,

The question of how to compile fio for ESXi comes up every few years
and as Mark suggested it IS doable by building a static fio binary
from an appropriate real distro but there are a few gotchas. You can't
take a "regular" distro's fio because the ESXi environment simply
doesn't match that of the regular distro (for example things like a
glibc are compiled with different options, libraries are missing etc).

The last time it was asked about was over on Github (see
https://github.com/axboe/fio/issues/464 ) where I mentioned the steps
I used to get it going for ESXi 6.0 but note that I no longer have
access to ESXi these days so I can't say what's needed for modern
environments (but the general idea should be the same).

On Wed, 10 Oct 2018 at 21:00, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>
> Ya, sorry I could not be of more help.
>
> I doubt that FIO could be compiled on raw ESXi as there is no compiler av=
ailable on that from what I can tell.  A statically linked one should work,=
 but I really don=E2=80=99t know enough to be able to say why it could not =
start a job.
>
> I do know that ESXi can pass a full device (raw disk) to a VM and that VM=
 takes full ownership of it.  So you could load a VM with CentOS or somethi=
ng and have FIO profile the raw device, but that is probably not going to b=
e useful.  Chances are you are looking to something a little more advanced =
like profile vSAN or some other form of software defined storage?
>
> Regards,
> Mark
>
> Mark Beierl
> SW System Sr Principal Developer
> Dell EMC | Cloud & Communication Service Provider Solution
> Mark.Beierl@Dell.com
>
> On 2018-10-10, 15:56, "Eliezer Nebab" <eliezer@integritech.solutions> wro=
te:
>
>
>     [EXTERNAL EMAIL]
>     Please report any suspicious attachments, links, or requests for sens=
itive information.
>
>
>     Thanks for the quick response Mark.
>
>     Yes, I was looking for documentation or guide on if fio can be compil=
ed or installed on esxi servers.
>
>     From your response it looks like (compile or precompiled) neither wor=
ks.
>
>     Thank you.
>
>     Eliezer
>
>
>     > On Oct 10, 2018, at 2:05 PM, Beierl, Mark <Mark.Beierl@dell.com> wr=
ote:
>     >
>     > Are you asking if FIO can be built or run on the hypervisor itself,=
 like via ssh?
>     >
>     > I have tried a test before where I statically compiled FIO and copi=
ed it to an ESXi server, but I was never able to get any jobs to start.  No=
t sure if the kernel supports the fork() or whatever call FIO uses to spawn=
 the job processes.  So, I=E2=80=99m not sure it can be done.  ESXi is not =
a general purpose OS, so it lacks some features.
>     >
>     > Regards,
>     > Mark
>     >
>     > Mark Beierl
>     > SW System Sr Principal Developer
>     > Dell EMC | Cloud & Communication Service Provider Solution
>     > Mark.Beierl@Dell.com
>     >
>     > On 2018-10-10, 14:24, "fio-owner@vger.kernel.org on behalf of eliez=
er@integritech.solutions" <fio-owner@vger.kernel.org on behalf of eliezer@i=
ntegritech.solutions> wrote:
>     >
>     >
>     >    [EXTERNAL EMAIL]
>     >    Please report any suspicious attachments, links, or requests for=
 sensitive information.
>     >
>     >
>     >    Is fio supported on vmware esxi 5 and 6 servers?  Does anyone ha=
ve any
>     >    helpful guides as to how to install it on vmware?  I've searched=
 google but
>     >    could not find any.  The only reference to fio+vmware is Disable=
 libaio for
>     >    ESXi build - bug#80
>     >
>     >    Thank you in advance.
>     >
>     >    Regards,
>     >    Eliezer

--=20
Sitsofe | http://sucs.org/~sits/

