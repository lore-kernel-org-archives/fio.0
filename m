Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769A6C433F5
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 13:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 541CB60F21
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 13:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbhJKNnJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:43:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51952 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhJKNnF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 09:43:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BB4551FEAC;
        Mon, 11 Oct 2021 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633959664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEOB8j52LtqBKKqiPvjUx+FjKc71ISqPc+fyWOWnFwQ=;
        b=1GpUOK6OlLIdGh3erGfOBjPB5xLvlbm4QIUgeYPe/nB6zafIBbNkaG+s8qQBxTHyX4+Noy
        MfXpMf/e6G3pqGeqQq87l/C2Oj7Q7YQ0JxlZwLrGdDIzni2pAkFBqJkSI3k59syj3Seqlf
        b36lUP/nw1V5tH/BexRbd2RrWLFfyPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633959664;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEOB8j52LtqBKKqiPvjUx+FjKc71ISqPc+fyWOWnFwQ=;
        b=Djw4ygy9tVr1FJ1Th9OSXjISbSdw/uiTBa1SE4k5e6YLWzsBrKvFjGrClkLkcE7SXGPF+v
        gm/SopGLJ6Ye+8CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C0C513C5E;
        Mon, 11 Oct 2021 13:41:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sS91G/A+ZGH2HQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 13:41:04 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 75e693d5;
        Mon, 11 Oct 2021 13:41:03 +0000 (UTC)
Date:   Mon, 11 Oct 2021 14:41:03 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YWQ+7xz9Nw8E8PEq@suse.de>
References: <YVdBVdOjPLCayG1k@suse.de>
 <20211010083125.dne6pcjjboixdllo@fedora>
 <YWP/SmhG8TviBE2w@suse.de>
 <YWQEgBQLdD+zsHOZ@T590>
 <YWQO6RdR7oUSNpxN@suse.de>
 <YWQcdTCMIFFdDnMh@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWQcdTCMIFFdDnMh@T590>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 11, 2021 at 07:13:57PM +0800, Ming Lei wrote:
> On Mon, Oct 11, 2021 at 11:16:09AM +0100, Luís Henriques wrote:
> > On Mon, Oct 11, 2021 at 05:31:44PM +0800, Ming Lei wrote:
> > > On Mon, Oct 11, 2021 at 10:09:30AM +0100, Luís Henriques wrote:
> > > > On Sun, Oct 10, 2021 at 04:31:25PM +0800, Zorro Lang wrote:
> > > > > On Fri, Oct 01, 2021 at 06:11:49PM +0100, Luis Henriques wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> > > > > > Here's what I'm getting:
> > > > > > 
> > > > > > # cat results/generic/095.out.bad 
> > > > > > QA output created by 095
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
> > > > > > fio: pid=4090, got signal=11
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
> > > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
> > > > > > fio: pid=4086, got signal=11
> > > 
> > > The issue should be from generic/095 test itself, which run dio with bs=1k,
> > > but logical block size is 4k. I guess the test may work after you change
> > > bs to 4k in generic/095.
> > 
> > Ah, I see what you mean.  Ok, I've used the patch bellow and the test now
> > passes.  The patch changes the block size only for the DIO jobs, there are
> > other jobs where bs=1k is still used.  Do you think other jobs should be
> > changed as well?
> 
> Only DIO job need aligned bs parameter. 

Awesome, thanks for confirming.

Cheers,
--
Luís
