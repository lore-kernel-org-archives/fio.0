Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36166 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbDJS3R (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 10 Apr 2015 14:29:17 -0400
Received: by lbbqq2 with SMTP id qq2so19776270lbb.3
        for <fio@vger.kernel.org>; Fri, 10 Apr 2015 11:29:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
References: <CANt18PxHj5p6f9gXsuKCRDNXwgo_nW0MwD0wM6QbYENBtJd1ww@mail.gmail.com>
Date: Fri, 10 Apr 2015 19:29:15 +0100
Message-ID: <CALjAwxjUF7R=GbynqFgj5-1D6F-133oQDXvqv5nPKQKaQ0k=yw@mail.gmail.com>
Subject: Re: during fio scenario with verify=meta some jobs fails
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Samuel Shapiro <samuel.sh79@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 8 April 2015 at 11:37, Samuel Shapiro <samuel.sh79@gmail.com> wrote:
> Hi All,
>
> I'd recently started using fio for NAS FS tests, and it's really great
> tool, as for loading system,
> so for finding various protocols bugs. Thank You :)
> One of the scenarios, I'm using is "fsx", that is slightly modified to
> run with 16 jobs:
>
> ; This job file works pretty works similarly to running fsx-linux
> ; with -r 4096 -w 4096 -Z -N 500000
> [global]
> verify=meta
> verify_dump=1
>
> [fsx-file-job1]
> directory=/mnt/FIO-some-mountpoint-to-NAS-01
> ioengine=libaio
> iodepth=256
> rw=randrw
> size=256k
> bs=4k
> norandommap

^^^ This allows the same block to be overwritten multiple times. Are
you sure this is what you want?

-- 
Sitsofe | http://sucs.org/~sits/
