Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35996 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1KJGrM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Nov 2011 01:47:12 -0500
Received: by qyk27 with SMTP id 27so5530479qyk.19
        for <fio@vger.kernel.org>; Wed, 09 Nov 2011 22:47:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBB01B8.5070801@hp.com>
References: <4EBB01B8.5070801@hp.com>
Date: Wed, 9 Nov 2011 23:47:11 -0700
Message-ID: <CAKTuRrGcaTvSrVYyh89va=7gZJYkcsMqDfZXnOepdzRp=SHPHQ@mail.gmail.com>
Subject: Re: fio: terminating on signal 15
From: Josh Aune <luken@omner.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: fio@vger.kernel.org

On Wed, Nov 9, 2011 at 3:42 PM, Mike Miller <mike.miller@hp.com> wrote:
> Hello,
> I'm trying to benchmark random reads and I see some strange happenings on
> the server.
> The idea was to have 128 processes randomly reading from a 10GB file and log
> bandwith and latencies. Here's my job file:

...

>
> What I got instead was 128 files of 10GB each with fio 128 processes
> running.

You'll want to add a filename= directive, otherwise fio will generate
one file for each process ( 8 sections * 16 processes = 128
processes).

> After the writing of all the files I see
>
> fio: terminating on signal 15
>
> constantly scrolling in the window in which I started the fio job.
>
> An strace -f -p pid shows:
>
> kill(pid, SIGTERM) = 0

Which version of fio?

>
> If I run `iostat -x /dev/sda1 5 5` the first line of output shows maybe 400
> MB/sec being read. Sometimes it spikes up to 800 MB/sec. Now it's showing
> 176 MB/sec being written. All subsequent lines show zero across the board.
> That's only with the writing phase. The reading phase does not exhibit that
> behavior. So I'm not sure if it's doing anything good.
>
> Can someone tell me what I'm doing wrong? Again, my goal is to benchmark
> some number of processes or threads randomly reading from some large file.
