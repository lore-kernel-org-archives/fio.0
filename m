Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:46465 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0ADOw0 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 4 Jan 2010 09:52:26 -0500
Received: by pxi4 with SMTP id 4so11032750pxi.33
        for <fio@vger.kernel.org>; Mon, 04 Jan 2010 06:52:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <328428.66762.qm@web55006.mail.re4.yahoo.com>
References: <328428.66762.qm@web55006.mail.re4.yahoo.com>
Date: Mon, 4 Jan 2010 07:52:25 -0700
Message-ID: <f3177b9e1001040652r574e12a4m7fb4b988bb22b250@mail.gmail.com>
Subject: Re: io scheduler merges control
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: fio@vger.kernel.org

On Thu, Dec 24, 2009 at 12:12 PM, john smith <whalajam@yahoo.com> wrote:
> IOPS-reported numbers for a test vary (more than 30% in my case) from one=
 run to another depending on kernel io scheduler merges (reported in "Disk =
stats/merges=3Dreads/writes") making it hard to measure/compare performance=
 of block drivers, for instance.

Are you trying to measure sequential I/O?  Most application traces
I've seen show that despite the sequential/random mix reported, the
vast majority of "sequential" accesses are two blocks.  Of course this
isn't true for applications that only do logging and a few others...
but, it means that for most applications, there really isn't any
sequential access to worry about.

Are you disabling the VM Cache w/ Direct I/O?

Maybe tell us more about what you're trying to test.  It may be more a
matter of control and preconditioning than a fio issue.

Chris
>
> I don't see any way to turn off kernel io scheduler merges (cfq or others)
> and I'd ask if you would consider adding support for it, disabling the me=
rges per individual device, using sys-fs maybe?
>
> If you do, adding an option to fio for controlling the merges would be us=
eful too,
>
> thanks,
> John
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>
