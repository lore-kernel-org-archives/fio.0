Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f45.google.com ([209.85.217.45]:38249 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBSal (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 May 2019 14:30:41 -0400
Received: by mail-vs1-f45.google.com with SMTP id v141so1987482vsc.5
        for <fio@vger.kernel.org>; Thu, 02 May 2019 11:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAJQBtgm5kTYnn0Qjs_CHXDqirr+7=qVhev0ScXq0x6wxoib8QQ@mail.gmail.com>
 <AT5PR8401MB11693A24BC27035F38619B85AB340@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB11693A24BC27035F38619B85AB340@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Left Right <olegsivokon@gmail.com>
Date: Thu, 2 May 2019 18:30:25 +0300
Message-ID: <CAJQBtgksHEjb5oR-yA2eUHkDyuiboLc+MPV-dWJLNdm8v04YWw@mail.gmail.com>
Subject: Re: How do reads and writes overlap?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks a lot for your answer. Just to clarify, the reason I wanted to
know this isn't really data validation. It's important for
understanding of the results of my benchmarks. Since the program that
I'm testing is a kind of iSCSI server, which needs to, for example,
acknowledge writes based on user's policy pertaining as to how far the
data had propagated, a read from a block with a write pending might be
served from the server's cache, rather than going the full circle to
the physical storage and back.

Thus, understanding the percentage of such overlaps would be very
important for me. So, I was wondering if there is any way of
controlling this behavior.

Thanks!

On Thu, May 2, 2019 at 6:50 PM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Left Right
> > Sent: Wednesday, May 1, 2019 10:06 PM
> > To: fio@vger.kernel.org
> > Subject: How do reads and writes overlap?
> >
> > I was looking for this info, online, but with no luck so far. What I'm
> > really interested to know is this:
> >
> > * Say, you have a mixed sequential workload 75% reads, 25% writes with
> > queue depth greater than one, then:
> > ** are all writes executed before all reads?
>
> No.
>
> > ** are there any reads from the blocks not yet written to?
>
> Yes.
>
> > ** are there any reads performed against writes that are not ack'ed yet?
>
> Yes.
>
> > ** are there any writes performed to the same blocks that have a
> > pending read request?
>
> Yes.
> > * Does any of the answers change if we modify the ratio of reads to
> > writes, sequential to random?
>
> No.
>
> Remember that fio is a primarily a workload generator, not a data
> validation tool. It doesn't care what data it gets back from reads
> (comparing all the bytes would take too much time, interfering with
> performance). You can run special verify threads, but those are
> separate from the normal read workloads.
>
>

