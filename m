Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f179.google.com ([209.85.221.179]:36135 "EHLO
        mail-vk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbeKRQVT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 18 Nov 2018 11:21:19 -0500
Received: by mail-vk1-f179.google.com with SMTP id u62so6117242vkb.3
        for <fio@vger.kernel.org>; Sat, 17 Nov 2018 22:02:02 -0800 (PST)
MIME-Version: 1.0
References: <CAHt2jbtMQ3Hcxk0o4+-AauE6iOcZOewCBpfv0_VdNu4ZiX4kKA@mail.gmail.com>
 <CALjAwxicij8N=d6qCQoDz33tbjw4epM_MZtN1LoKQ7B5+X8nTA@mail.gmail.com>
 <CAHt2jbus+sKPf=X=bhonZ3HG9J=4AMqF9Fu73zrcqUp6ukR4Rg@mail.gmail.com> <CAHt2jbsHx4YUHNFUAjkf2of5Bqnv2m7=CNwZheMLWJj48Ko5Sg@mail.gmail.com>
In-Reply-To: <CAHt2jbsHx4YUHNFUAjkf2of5Bqnv2m7=CNwZheMLWJj48Ko5Sg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 18 Nov 2018 06:01:35 +0000
Message-ID: <CALjAwxiBHr3nq0ejox8Fdu6ZL9zmnHtFYEP-fftz7D3Ps4qFXg@mail.gmail.com>
Subject: Re: Save verify_state continuously
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mousumi Mullick <mousumi.mullick@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Mousumi,

Putting aside the corrupt checkpoint file issue (maybe you have to
write two in a transactional fashion), another problem with writing a
checkpoint periodically is what happens if you have an overwrite of
previously written data between when the checkpoint was last taken but
before the next checkpoint could happen (because you powered off in
between)? How do you know that you actually need to expect something
different / ignore that overwritten data? To cope with that you'd need
to record an intent log of what you are going to do before the next
checkpoint so you knew what NOT to check as well. If you're
checkpointing by time how do you know what that's going to be?

You can always ask but to be clear (and speaking just for myself) -
I'm a volunteer on this project on my personal time so I don't commit
to a roadmap or to implement new features etc (plus there's a big list
of things that'd I'd like to do with fio and that will keep me busy
for a long time). If you need a new feature done in fio, the best
approach is to create the code that implements it yourself (or find
someone to code it up for you :-) and then send the patch/pull request
to the fio project for review.

If fio currently doesn't quite fit your use case and you can't use it
then no worries - that's just the way things turn out sometimes :-)

PS: Don't forget if you are operating fio in client/server mode then
there is both a local and a remote trigger and those fios running as
servers can send their job states back to the client for safe storage
(Last paragraph of "Verification and triggers" on
https://fio.readthedocs.io/en/latest/fio_doc.html#verification-and-triggers
)...

On Thu, 15 Nov 2018 at 19:31, Mousumi Mullick <mousumi.mullick@gmail.com> wrote:
>
> If its possible to get this feature in a test/private build, I can try
> it out. It would be very helpful if I can continue using FIO in our
> framework.
>
>
>
> On Thu, Nov 15, 2018 at 10:37 AM Mousumi Mullick
> <mousumi.mullick@gmail.com> wrote:
> >
> > I did think about trigger file but I have some constraints with our
> > infrastructure that makes it difficult to create a trigger file in the
> > VMs before resetting the physical hosts. Also, I thought of having NFS
> > mounts on all VMs and using that location for trigger file but again
> > the infrastructure constraints are not helpful in this regards too.
> > Given all the constraints and the solutions that I have thought of
> > (mostly around trigger file) I am not able to come up with a solution.
> > This may not be an issue if there is a way in fio to checkpoint the
> > state file periodically from the start of a test.
> >
> >
> > On Thu, Nov 15, 2018 at 3:31 AM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, 15 Nov 2018 at 06:57, Mousumi Mullick <mousumi.mullick@gmail.com> wrote:
> > > >
> > > > I am planning to run fio on a dozens of virtual machines across
> > > > multiple physical hosts and at some point will power off a physical
> > > > host. As fio workload is running I will be triggering random VM
> > > > migrations across a set of physical hosts. Since powering off a
> > > > physical host will abruptly power off all VMs running on that host,
> > > > none of the fio processes in them will have a verify_state file saved.
> > > >
> > > > Given this test, I was wondering if there is a way for fio to
> > > > continuously save verify_state to a file so that I can use it
> > > > unconditionally on a subsequent power on to verify the data written so
> > > > far?
> > >
> > > Why not create a trigger file (see
> > > https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-trigger-file
> > > , https://fio.readthedocs.io/en/latest/fio_doc.html#verification-and-triggers
> > > ) to let fio know it needs to do a state save (it will also exit
> > > itself)? You may even be able to arrange for fio to send a command
> > > that powers the host off if you're using the client/server model with
> > > the appropriate trigger type. Further, don't you need to know fio has
> > > finished doing the state save correctly (note the that the trigger
> > > file will be deleted when fio is done with it)? If you power off a VM
> > > halfway through fio saving its state you risk generating/getting an
> > > incomplete/corrupt state file...

-- 
Sitsofe | http://sucs.org/~sits/

