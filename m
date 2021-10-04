Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25441C433F5
	for <fio@archiver.kernel.org>; Mon,  4 Oct 2021 10:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDE9613AC
	for <fio@archiver.kernel.org>; Mon,  4 Oct 2021 10:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJDKRu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 4 Oct 2021 06:17:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55134 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhJDKRu (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Oct 2021 06:17:50 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AFC8D22260;
        Mon,  4 Oct 2021 10:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633342560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aalXRYL5ZbZF7MRVQme3tap8+8hbUqGjls8uIghGIc=;
        b=ZoWETEUES6wjS8jVomju6fl0GAeANXX2olpVX1oDY2oc+OSghYclaQxllOuI7LDpavRBSc
        0lUdSKLCczSRxMv2Fw80FW+xyN2YcdC/jAIaSEVkb/MSSyy6PIpmOY6oE6kJB+GzeS4Gjd
        5hLjXaUsBOMkdLWeSpDF6y8sb/HfUIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633342560;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aalXRYL5ZbZF7MRVQme3tap8+8hbUqGjls8uIghGIc=;
        b=YpbKlZIg+gAx7Ui82JEgLLiZqf5SX1qLKOUpuYZtBRi8Lc7scg+DAsVdjbqyVsZYASkShc
        W1SfphsagvxCcVBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5EB5513CDE;
        Mon,  4 Oct 2021 10:16:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /6c8FGDUWmH2VwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 04 Oct 2021 10:16:00 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id e310c847;
        Mon, 4 Oct 2021 10:15:59 +0000 (UTC)
Date:   Mon, 4 Oct 2021 11:15:59 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org,
        fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YVrUX+qOJCDKp/Ng@suse.de>
References: <YVdBVdOjPLCayG1k@suse.de>
 <882f4c20-2e21-219b-0ca3-7e215e2d7cfa@kernel.dk>
 <YVeE2ZVkpGbTKZpG@mit.edu>
 <86ee93vijj.fsf@orpheus.olymp>
 <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <YVrSnW2RKP5hjxx6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVrSnW2RKP5hjxx6@suse.de>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 04, 2021 at 11:08:29AM +0100, Luis Henriques wrote:
> On Sat, Oct 02, 2021 at 08:59:57AM -0600, Jens Axboe wrote:
> > On 10/2/21 4:16 AM, Luis Henriques wrote:
> > > "Theodore Ts'o" <tytso@mit.edu> writes:
> > > 
> > >> On Fri, Oct 01, 2021 at 02:46:09PM -0600, Jens Axboe wrote:
> > >>>
> > >>> Hmm, do older versions fail? I see Ted suggested that 3.27 doesn't, can
> > >>> you give that a go? If that does work, would be great if you could try
> > >>> and bisect it.
> > >>
> > >> I just tried fio 3.28, and it worked for me.  So I don't think it's
> > >> fio.
> > > 
> > > Awesome, thank you both for checking it out.  So, it's definitely
> > > something in my test environment.
> > > 
> > >> Luis, could it be related to a  kernel config option?
> > > 
> > > Yeah, it could be.  I've tested this on a rolling release (openSUSE TW),
> > > so it's definitely quite different from Debian 10.  It may take me a bit
> > > to figure out what's going on, but I'll start with this kernel config and
> > > report back any finding.
> > > 
> > > Again, thank you both for confirming it's working on your side.
> > 
> > Do you have a core file from fio? Would be interesting to get a
> > backtrace from it.
> 
> Ok, not a lot of progress from my end yet, but here's some info gathered
> with gdb from the core file:
> 
> #0  0x000056505966b361 in io_completed (td=0x7f2b0c5437a0, io_u_ptr=0x7ffec2403e48, icd=0x7ffec2403e60) at /usr/src/debug/fio-3.28-1.1.x86_64/io_u.c:2012
> #1  0x000056505966b922 in ios_completed (icd=0x7ffec2403e60, td=0x7f2b0c5437a0) at /usr/src/debug/fio-3.28-1.1.x86_64/io_u.c:2086
> #2  io_u_queued_complete (td=0x7f2b0c5437a0, min_evts=<optimized out>) at /usr/src/debug/fio-3.28-1.1.x86_64/io_u.c:2145
> #3  0x0000565059680e88 in do_io (td=0x7f2b0c5437a0, bytes_done=0x7ffec2404070) at /usr/src/debug/fio-3.28-1.1.x86_64/backend.c:1176
> #4  0x000056505968a8ee in thread_main (data=data@entry=0x56505ae43510) at /usr/src/debug/fio-3.28-1.1.x86_64/backend.c:1870
> #5  0x000056505968ca48 in run_threads (sk_out=0x0) at /usr/src/debug/fio-3.28-1.1.x86_64/backend.c:2460
> #6  0x000056505968cb55 in fio_backend (sk_out=0x0) at /usr/src/debug/fio-3.28-1.1.x86_64/backend.c:2597
> #7  fio_backend (sk_out=0x0) at /usr/src/debug/fio-3.28-1.1.x86_64/backend.c:2558
> #8  0x000056505962fd97 in main (argc=4, argv=0x7ffec240c448, envp=<optimized out>) at /usr/src/debug/fio-3.28-1.1.x86_64/fio.c:60
> 
> And here's the io_completed() code where the crash occurs:
> 
>    2007                 if (io_u->resid) {
>    2008                         io_u->xfer_buflen = io_u->resid;
>    2009                         io_u->xfer_buf += bytes;
>    2010                         io_u->offset += bytes;
>    2011                         td->ts.short_io_u[io_u->ddir]++;
>    2012                         if (io_u->offset < io_u->file->real_file_size) {
>    2013                                 requeue_io_u(td, io_u_ptr);
>    2014                                 return;
>    2015                         }
>    2016                 }

I forgot to include the kernel log.  The page cache error seems relevant,
and, as I said before, I'm seeing it both on ext4 and xfs:

[   38.014790] fio[762]: segfault at 30 ip 000056505966b361 sp 00007ffec2403df0 error 4 in fio[56505962e000+84000]
[   38.016320] Code: c1 48 85 c0 74 2e 48 89 45 68 48 8b 45 40 48 63 55 2c 4c 01 4d 60 4c 01 c8 48 89 45 40 49 83 84 d4 70 5d 02 00 01 48 8b 55 20 <48> 3b 42 30 0f 82 75 026
[   38.016839] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[   38.019520] fio[760]: segfault at 30 ip 000056505966b361 sp 00007ffec2403df0 error 4 in fio[56505962e000+84000]
[   38.020543] File: /mnt/scratch/file1 PID: 754 Comm: fio
[   38.022056] Code: c1 48 85 c0 74 2e 48 89 45 68 48 8b 45 40 48 63 55 2c 4c 01 4d 60 4c 01 c8 48 89 45 40 49 83 84 d4 70 5d 02 00 01 48 8b 55 20 <48> 3b 42 30 0f 82 75 026
[   38.052142] fio[761]: segfault at 30 ip 000056505966b361 sp 00007ffec2403df0 error 4 in fio[56505962e000+84000]
[   38.053545] Code: c1 48 85 c0 74 2e 48 89 45 68 48 8b 45 40 48 63 55 2c 4c 01 4d 60 4c 01 c8 48 89 45 40 49 83 84 d4 70 5d 02 00 01 48 8b 55 20 <48> 3b 42 30 0f 82 75 026
[   38.058111] fio[759]: segfault at 30 ip 000056505966b361 sp 00007ffec2403df0 error 4 in fio[56505962e000+84000]
[   38.059511] Code: c1 48 85 c0 74 2e 48 89 45 68 48 8b 45 40 48 63 55 2c 4c 01 4d 60 4c 01 c8 48 89 45 40 49 83 84 d4 70 5d 02 00 01 48 8b 55 20 <48> 3b 42 30 0f 82 75 026
[   38.065638] fio[758]: segfault at 30 ip 000056505966b361 sp 00007ffec2403df0 error 4 in fio[56505962e000+84000]
[   38.067055] Code: c1 48 85 c0 74 2e 48 89 45 68 48 8b 45 40 48 63 55 2c 4c 01 4d 60 4c 01 c8 48 89 45 40 49 83 84 d4 70 5d 02 00 01 48 8b 55 20 <48> 3b 42 30 0f 82 75 026

> > In terms of why it's failing, a guess would be that your device is using 4k
> > sectors and the test is trying to do 1k aligned dio. That would fail, but
> > it should not cause fio to crash...
> > 
> > -- 
> > Jens Axboe
> > 

Cheers,
--
Luís
