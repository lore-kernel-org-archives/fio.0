Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:33761 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdCPRfy (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Mar 2017 13:35:54 -0400
Received: by mail-vk0-f53.google.com with SMTP id d188so28205766vka.0
        for <fio@vger.kernel.org>; Thu, 16 Mar 2017 10:35:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87shmd1k11.fsf@curie.anarc.at>
References: <87fuie2p40.fsf@curie.anarc.at> <CALjAwxjrNpTQTitcZCFA205m6mtE04OC_R_zmsK593hEUK3bPg@mail.gmail.com>
 <87shmd1k11.fsf@curie.anarc.at>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 16 Mar 2017 17:35:22 +0000
Message-ID: <CALjAwxi=Z+RbQeee2S6e-LPmu1Rey3WsPE+cjh1zy3DTG82OKg@mail.gmail.com>
Subject: Re: could fio be used to wipe disks?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?Q?Antoine_Beaupr=C3=A9?= <anarcat@orangeseeds.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 16 March 2017 at 12:30, Antoine Beaupr=C3=A9 <anarcat@orangeseeds.org> w=
rote:
> On 2017-03-16 07:42:48, Sitsofe Wheeler wrote:
>
> Yeah, I know about nwipe and everything. As I mentioned originally, I am
> not sure this is in the scope of my project...

OK.

>> Further it may not easier than you think to get at stale internal
>> mappings the "disk" might have which is why you use SECURE ERASE on
>> SSDs. fio does none of this.
>
> ... I also mentioned I was aware of SSD specifics, thanks. :)

OK - my bad :-)

>> Since you mentioned stress you may want to look at using a deeper
>> iodepth with the libaio engine (assuming you're on Linux, other
>> platforms have asynchronous engines too) and only doing the sync at
>> the end.
>
> Even after reading this:
>
> http://fio.readthedocs.io/en/latest/fio_doc.html#i-o-depth
>
> I don't quite understand what iodepth does or how to use it. Could you
> expand on this?

Sure. If you're using an fio ioengine that can submit I/O
*asynchronously* (i.e. doesn't have the wait for an I/O to come back
as completed before submitting another I/O) you have a potentially
cheaper (because you don't need to use so many CPUs) way of submitting
LOTS of I/O. The iodepth parameter controls the maximum amount of in
flight I/O to submit before you wait for some of it complete. To give
you a wild figure modern SATA disks can accept up to 32 outstanding
commands at once (although you may find the real depth achievable at
least one less than that due to how things work) so if you end up only
submitting four simultaneous commands the disk might not find that too
stressful (but this is highly job dependent).

A different way of putting is: if you're on Linux take a look at the
output shown by "iostat -x 1". One of the columns will be avgqu-sz and
the deeper this gets the more simultaneous I/O is being submitted to
the disk. If you vary the "--numjob=3D" of your original example you
will hopefully see this changing. What I'm suggesting is: a different
I/O engine may let you achieve the same effect but using less CPU.
Generally a higher depth is desirable but there are lot of things that
influence the actual queue depth achieved. Also bear in mind that you
might stress your kernel/CPU more before you "stress out" your disk
with certain job types.

--=20
Sitsofe | http://sucs.org/~sits/
