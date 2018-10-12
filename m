Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f67.google.com ([209.85.217.67]:32992 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbeJLNor (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Oct 2018 09:44:47 -0400
Received: by mail-vs1-f67.google.com with SMTP id e206so10922421vsd.0
        for <fio@vger.kernel.org>; Thu, 11 Oct 2018 23:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions>
 <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions>
 <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com> <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com>
 <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com>
In-Reply-To: <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 12 Oct 2018 07:13:29 +0100
Message-ID: <CALjAwxg9kiEPqOLHD2_-Px9_rXeQyqAzksaf39ABakJnUE1kiw@mail.gmail.com>
Subject: Re: fio on vmware esxi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark.Beierl@dell.com
Cc: eliezer@integritech.solutions, fio <fio@vger.kernel.org>

Thank you for following up on this Mark - I'm sure others will find
that information useful!

Glancing at your steps:

> RUN git config --global http.sslVerify false

I'm not sure you need this as the next line isn't using https:

> RUN git clone http://git.kernel.dk/fio.git fio

I don't know if alpine builds a static version of libaio (e.g. there
isn't a prepackaged *static* libaio on CentOS/RHEL) but if it does you
may find you can nobble fio's configure script to allow its detection
even though you're using the --esx option...

On Thu, 11 Oct 2018 at 14:42, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>
> Hey all, and special thanks to Sitsofe for pointing me at the github fio =
issue 464.
>
> I have fio working on my ESXi 6.5 server.  Here is the procedure I used. =
 Install Docker and use this Dockerfile:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> FROM multiarch/alpine:x86_64-v3.6
>
> RUN apk --no-cache add --update \
>     git \
>     alpine-sdk \
>     coreutils \
>     linux-headers \
>     libaio \
>     libaio-dev \
>     zlib-dev
>
> RUN git config --global http.sslVerify false
> RUN git clone http://git.kernel.dk/fio.git fio
> RUN cd fio && ./configure --esx
> RUN cd fio && EXTFLAGS=3D"-static" make -j $(grep -c ^processor /proc/cpu=
info) install
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
> Then, start the docker container with a dummy command (I=E2=80=99m sure t=
here are better ways to do this, but it works, so hey)
> $ docker run -d fio sleep 600
>
> Note the ID that it spits out.  Use that ID in the next command:
> $ docker cp 69e64de38659d350fb07e45b5d7d2d4098c642ec1ca81a6eb18a9b34e6220=
82f:/fio/fio .
>
> You can now scp that fio to your ESXi server and execute it there.
>
> [root@R156U37ESXI:/vmfs/volumes/5a611782-2d14bf65-c453-246e96146f88/testd=
ir] ~/fio test.fio
> file1: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4=
096B-4096B, ioengine=3Dpsync, iodepth=3D16
> fio-3.11-6-gee6ce
> Starting 1 thread
> file1: Laying out IO file (1 file / 1024MiB)
> Jobs: 1 (f=3D1): [f(1)][100.0%][r=3D1346KiB/s,w=3D899KiB/s][r=3D336,w=3D2=
24 IOPS][eta 00m:00s]
> ....
>
> Hope this works for you, Eliezer!
>
> Regards,
> Mark
>
> Mark Beierl
> SW System Sr Principal Developer
> Dell EMC | Cloud & Communication Service Provider Solution
> Mark.Beierl@Dell.com
>
> On 2018-10-11, 01:34, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>
>
>     [EXTERNAL EMAIL]
>     Please report any suspicious attachments, links, or requests for sens=
itive information.
>
>
>     Hi,
>
>     The question of how to compile fio for ESXi comes up every few years
>     and as Mark suggested it IS doable by building a static fio binary
>     from an appropriate real distro but there are a few gotchas. You can'=
t
>     take a "regular" distro's fio because the ESXi environment simply
>     doesn't match that of the regular distro (for example things like a
>     glibc are compiled with different options, libraries are missing etc)=
.
>
>     The last time it was asked about was over on Github (see
>     https://github.com/axboe/fio/issues/464 ) where I mentioned the steps
>     I used to get it going for ESXi 6.0 but note that I no longer have
>     access to ESXi these days so I can't say what's needed for modern
>     environments (but the general idea should be the same).
>
>     On Wed, 10 Oct 2018 at 21:00, Beierl, Mark <Mark.Beierl@dell.com> wro=
te:
>     >
>     > Ya, sorry I could not be of more help.
>     >
>     > I doubt that FIO could be compiled on raw ESXi as there is no compi=
ler available on that from what I can tell.  A statically linked one should=
 work, but I really don=E2=80=99t know enough to be able to say why it coul=
d not start a job.
>     >
>     > I do know that ESXi can pass a full device (raw disk) to a VM and t=
hat VM takes full ownership of it.  So you could load a VM with CentOS or s=
omething and have FIO profile the raw device, but that is probably not goin=
g to be useful.  Chances are you are looking to something a little more adv=
anced like profile vSAN or some other form of software defined storage?
>     >
>     > Regards,
>     > Mark
>     >
>     > Mark Beierl
>     > SW System Sr Principal Developer
>     > Dell EMC | Cloud & Communication Service Provider Solution
>     > Mark.Beierl@Dell.com
>     >
>     > On 2018-10-10, 15:56, "Eliezer Nebab" <eliezer@integritech.solution=
s> wrote:
>     >
>     >
>     >     [EXTERNAL EMAIL]
>     >     Please report any suspicious attachments, links, or requests fo=
r sensitive information.
>     >
>     >
>     >     Thanks for the quick response Mark.
>     >
>     >     Yes, I was looking for documentation or guide on if fio can be =
compiled or installed on esxi servers.
>     >
>     >     From your response it looks like (compile or precompiled) neith=
er works.
>     >
>     >     Thank you.
>     >
>     >     Eliezer
>     >
>     >
>     >     > On Oct 10, 2018, at 2:05 PM, Beierl, Mark <Mark.Beierl@dell.c=
om> wrote:
>     >     >
>     >     > Are you asking if FIO can be built or run on the hypervisor i=
tself, like via ssh?
>     >     >
>     >     > I have tried a test before where I statically compiled FIO an=
d copied it to an ESXi server, but I was never able to get any jobs to star=
t.  Not sure if the kernel supports the fork() or whatever call FIO uses to=
 spawn the job processes.  So, I=E2=80=99m not sure it can be done.  ESXi i=
s not a general purpose OS, so it lacks some features.
>     >     >
>     >     > Regards,
>     >     > Mark
>     >     >
>     >     > Mark Beierl
>     >     > SW System Sr Principal Developer
>     >     > Dell EMC | Cloud & Communication Service Provider Solution
>     >     > Mark.Beierl@Dell.com
>     >     >
>     >     > On 2018-10-10, 14:24, "fio-owner@vger.kernel.org on behalf of=
 eliezer@integritech.solutions" <fio-owner@vger.kernel.org on behalf of eli=
ezer@integritech.solutions> wrote:
>     >     >
>     >     >
>     >     >    [EXTERNAL EMAIL]
>     >     >    Please report any suspicious attachments, links, or reques=
ts for sensitive information.
>     >     >
>     >     >
>     >     >    Is fio supported on vmware esxi 5 and 6 servers?  Does any=
one have any
>     >     >    helpful guides as to how to install it on vmware?  I've se=
arched google but
>     >     >    could not find any.  The only reference to fio+vmware is D=
isable libaio for
>     >     >    ESXi build - bug#80
>     >     >
>     >     >    Thank you in advance.
>     >     >
>     >     >    Regards,
>     >     >    Eliezer
>
>     --
>     Sitsofe | http://sucs.org/~sits/
>
>


--=20
Sitsofe | http://sucs.org/~sits/

