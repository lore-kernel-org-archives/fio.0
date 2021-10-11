Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4213C4332F
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 09:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02A261040
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 09:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhJKJLf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 05:11:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56324 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbhJKJLc (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 05:11:32 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 837B620041;
        Mon, 11 Oct 2021 09:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633943371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESRudC8uAqlDAG/p5sL7NuQ7SwM1N8WVj3zuoPUV6KM=;
        b=Dg4AjlSK7KGlBTR43GdJGc5H3U3sSjioHig2SUi/lzje2LYjSypHBcfJlblVzr/BpBq+0I
        ign7ePZX93/rEgEZqe8qaLmhcRbPkQyWn7ofD7Xj1hRzl2wQPbUPZk8xl3ac4uSbOyJFtr
        jcxHt/R0GDWfpEjJ4eFhHyKIaqIERYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633943371;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESRudC8uAqlDAG/p5sL7NuQ7SwM1N8WVj3zuoPUV6KM=;
        b=xB6fXDgTidC0h6JKI3tLv1rf4cEpS00C/4JUBk+dHHaUfLF0RLDIxj6+NJSU6t0mvWjLAT
        rw/RG1QGQu7c0nCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52C0D13C03;
        Mon, 11 Oct 2021 09:09:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YUXhEEv/Y2G1EQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 09:09:31 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id bba1bf4b;
        Mon, 11 Oct 2021 09:09:30 +0000 (UTC)
Date:   Mon, 11 Oct 2021 10:09:30 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YWP/SmhG8TviBE2w@suse.de>
References: <YVdBVdOjPLCayG1k@suse.de>
 <20211010083125.dne6pcjjboixdllo@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211010083125.dne6pcjjboixdllo@fedora>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sun, Oct 10, 2021 at 04:31:25PM +0800, Zorro Lang wrote:
> On Fri, Oct 01, 2021 at 06:11:49PM +0100, Luis Henriques wrote:
> > Hi!
> > 
> > I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> > Here's what I'm getting:
> > 
> > # cat results/generic/095.out.bad 
> > QA output created by 095
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
> > fio: pid=4090, got signal=11
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
> > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
> > fio: pid=4086, got signal=11
> 
> I *guess* it might be caused by a striped storage(fs) of you?

I'm not sure I understand what you mean by that.  As I mentioned somewhere
else in this thread, I'm using zram devices for testing.  If I change the
test to use file-backed storage device instead, it passes without any
issues.

Cheers,
--
Luís

> 
> Thanks,
> Zorro
> 
> > Silence is golden
> > 
> > This was for ext4 but the output for xfs is similar.  Since fio is getting
> > killed I suspect this may be an issue with this tool.  Thus I'm sending
> > this to both fio and fstests mailing-lists.
> > 
> > I'm using a 5.15-rc3 kernel and fio-3.28.  Is anyone else seeing something
> > similar?
> > 
> > Cheers,
> > --
> > Luís
> > 
> 
