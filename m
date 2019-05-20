Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44068 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfETF61 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 May 2019 01:58:27 -0400
Received: by mail-wr1-f41.google.com with SMTP id w13so2286536wru.11
        for <fio@vger.kernel.org>; Sun, 19 May 2019 22:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <CA+=P2MuECGCj+zdvP-=3DfPD71VyYHX1RoOxCCDz2Uea=ZL9_g@mail.gmail.com>
 <CALjAwxjDh5UhbeP=VATCPq0vBcoUmms=nbQoh8cqrFsK-xfJjw@mail.gmail.com>
 <CA+=P2MubaS=U+XPgjLXQKaf+-1nm+C5B-KdWD5z2Tu1nb56Axg@mail.gmail.com>
 <CALjAwxiKbeKjPc3eY8L6D6FB3jZVnSRwEtnyZ_6NC_eDNCjQXg@mail.gmail.com> <CA+=P2MsGQFDbr+31aauO-8YxNFQLEnsbXBrRJy2+wps6=c8isQ@mail.gmail.com>
In-Reply-To: <CA+=P2MsGQFDbr+31aauO-8YxNFQLEnsbXBrRJy2+wps6=c8isQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 20 May 2019 06:58:09 +0100
Message-ID: <CALjAwxjmBpt+dUtvYpqXpkU+Tn_bahkUYEYiRz3EeCd=f_8t+A@mail.gmail.com>
Subject: Re: How is numjobs & iodepth related?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Manu K.S." <cse.manuks@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

Command 1 TLDR; IO depth will be (up to) eight but there are caveats.
Logic used per job: asynchronously queue an I/O at a time but once
four I/Os are outstanding wait for at least one of those I/Os to
complete before queuing any more. There is a case where if I/Os
complete fast enough you end up achieving a depth lower than expected
but if that really concerns you there are ways around that (which come
with their own tradeoffs).  As there are two concurrent jobs (thanks
to numjobs) it means you could get up to eight outstanding I/Os <but
insert caveats about kernel transforming I/O mentioned in the NB of
the reply to your first mail:
https://www.spinics.net/lists/fio/msg07872.html >. You make it sound
like you're not seeing that - can you tell how you are determining
this?

(I'm a little worried you've got "prio=0" in your command though.
Generally when you're starting out with fio extra unknown options can
lead to more confusion. I'd remove it until you're happy with your
current command line)

Command 2: I think I'm going to ask you to reply with what YOU think
the answer is and WHY :-) Don't forget you can actually run the
command and fio will tell you the depths a job achieved over its
lifetime so I'm also going to ask you to post the full OUTPUT of
running that job in your answer!

On Sat, 18 May 2019 at 12:46, Manu K.S. <cse.manuks@gmail.com> wrote:
>
> These are the commands :
>
> Command 1:
> fio --filename=/dev/sdb --time_based --rw=read --name=fiotest --prio=0
> --bs=4k --direct=1 --ioengine=libaio --runtime=60 --numjobs=2
> --iodepth=4
> Command 2:
> fio --filename=/dev/sdb:/dev/sdc --time_based --rw=read --name=fiotest
> --prio=0 --bs=4k --direct=1 --ioengine=libaio --runtime=60 --numjobs=2
> --iodepth=4
>
> For command 1, what is the logic used ? If I'm specifying numjobs=2 &
> iodepth=4, will each job get 2 IO depth, or does it mean each job will
> be running with IO depth 4? This is a bit confusing for me.
>
> For command 2, will each disk have :
>  1. 2 jobs per disk with 4 IO depth for each job?
>  2. 2 jobs per disk with 2 IO depth for each job?
>  2. One job per disk with 2 IO depth for each job?
>  3. One job per disk with 4 IO depth?
>
>
>
> --
> Cheers
> Manu K S
>
> On Sat, May 18, 2019 at 5:02 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> >
> > Hi,
> >
> > I'm going to stop here for now because the command line you posted
> > earlier is missing something if you are really using libaio so I'm
> > getting confused (maybe you are saying you are using a new command
> > line but you forgot to post it in your new email?). I'm afraid we need
> > to see the full current command line (and the contents of any job
> > files) to be able to answer questions like this - see
> > https://github.com/axboe/fio/blob/master/REPORTING-BUGS for the type
> > of information that is required. Could you follow up with ALL the
> > information requested there? To maximize the odds of getting to a
> > resolution ensure you include the fio output as mentioned in
> > REPORTING-BUGS - don't be tempted to skip sending it to us in this
> > case!
> >
> > On Sat, 18 May 2019 at 09:43, Manu K.S. <cse.manuks@gmail.com> wrote:
> > >
> > > Thank you for the information.
> > > Yes I'm indeed using libaio as the ioengine on a linux server.
> > >
> > > For command 2, what is the logic? If I'm specifying numjobs=2 &
> > > iodepth=4 will each job get 2 IO depth, or does it mean each job will
> > > be running with IO depth 4? This is a bit confusing for me.
> > >
> > > For command 3, will each disk have :
> > >  1. 2 jobs per disk with 4 IO depth for each job?
> > >  2. 2 jobs per disk with 2 IO depth for each job?
> > >  2. One job per disk with 2 IO depth for each job?
> > >  3. One job per disk with 4 IO depth?
> > >
> > >
> > > --
> > > Cheers
> > > Manu K S
> > >
> > > On Sat, May 18, 2019 at 12:43 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Fri, 17 May 2019 at 16:20, Manu K.S. <cse.manuks@gmail.com> wrote:
> > > > >
> > > > > Hi, what will be the iodepth for each job with below 3 commands?
> > > > >
> > > > > COMMAND 1
> > > > > -----------------
> > > > > fio --name=fiotest --filename=/dev/sdb --rw=read --numjobs=1
> > > > > --iodepth=4 --size=1G --bs=4k --runtime=120 --time_based
> > > > >
> > > > > COMMAND 2
> > > > > -------------------
> > > > > fio --name=fiotest --filename=/dev/sdb --rw=read --numjobs=2
> > > > > --iodepth=4 --size=1G --bs=4k --runtime=120 --time_based
> > > > >
> > > > > COMMAND 3
> > > > > -------------------
> > > > > fio --name=fiotest --filename=/dev/sdb:/dev/sdc --rw=read --numjobs=2
> > > > > --iodepth=4 --size=1G --bs=4k --runtime=120 --time_based
> > > >
> > > > Hard to say without more context but assuming you're on Linux:
> > > >
> > > > COMMAND 1
> > > > You're going to get a depth of 1 because the default ioengine chosen
> > > > when you don't specify one on Linux is synchronous (see the iodepth
> > > > description in the fio help for warnings about depth and synchronous
> > > > ioengines - https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth
> > > > ). Maybe you wanted to use libaio with direct=1 (see the libaio
> > > > section in https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-ioengine
> > > > for more details)?
> > > >
> > > > COMMAND 2
> > > > I'd guess you will get an overall depth of 2 (1 per job).
> > > >
> > > > COMMAND 3
> > > > I'd guess you will get an overall depth of 2 (1 per job). Multiple
> > > > files in filename won't impact the depth only which file each I/O goes
> > > > to (which is roundrobin by default -
> > > > https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-file-service-type
> > > > ).
> > > >
> > > > NB: fio will try and report the depths it is achieving see the "IO
> > > > depths" output in the example on
> > > > https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
> > > > . What your disk actually sees can be different though depending on
> > > > what the kernel chooses to do with the submitted I/O.

-- 
Sitsofe | http://sucs.org/~sits/

