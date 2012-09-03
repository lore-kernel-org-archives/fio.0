Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41420 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2ICAOL (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 2 Sep 2012 20:14:11 -0400
Received: by vbbff1 with SMTP id ff1so4835704vbb.19
        for <fio@vger.kernel.org>; Sun, 02 Sep 2012 17:14:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAyzu8gsSK+1n26FfKmAqJtBjbrMTufFMNo4f5D1U2J9B8Cp0w@mail.gmail.com>
References: <CAAyzu8gsSK+1n26FfKmAqJtBjbrMTufFMNo4f5D1U2J9B8Cp0w@mail.gmail.com>
Date: Mon, 3 Sep 2012 01:14:10 +0100
Message-ID: <CAAyzu8gnC9ukuSV5UUxPcp-x9Q-6sf5OV2nPpOVnchMZ5LqKDw@mail.gmail.com>
Subject: Re: verify with norandommap
From: Gary Foster <gpfwestie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I realise most people are using Fio to do performance testing, ie
replicating Windows IOMeter.

But surely there are some guys using Fio for data integrity testing,
could you guys give me some help with this ?

On 10 August 2012 15:16, Gary Foster <gpfwestie@gmail.com> wrote:
>
> Hi all.
>
> I've been running some random IO tests where I want to verify the data
> was written correctly.
>
> I have set norandommap=1 as I was running out of memory, but the man
> page indicates
> the data will not be verified
>
> --- cut ---
>        norandommap
>               Normally  fio  will  cover every block of the file when
> doing random I/O. If this parameter is given, a new offset will be
>               chosen without looking at past I/O history.  This
> parameter is mutually exclusive with verify.
> -- cut ----
>
> However, the output to stdio seems to indicate it is verifying (see
> the 'V' below) - but is it really verifying
> anything ? and if so, whats the difference between the verify with
> norandommap being set to 0 ?
>
> -- cut ---
> fio 2.0.7
> Starting 13 processes
> bs: 13 (f=13): [wVwwwwwwwwwww] [0.0% done] [3695K/3679K /s] [902 /898
> iops] [eta 84d:23h:10m:19s]
> -- cut --
>
> Here's my job file
>
> [global]
> blocksize=4K
> readwrite=randwr
> ioengine=libaio
> verify=crc32c
> verify_backlog=10
> iodepth=1
> direct=1
> norandommap=1
