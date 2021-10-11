Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1211EC433F5
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 10:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E259460F21
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 10:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhJKKSO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 06:18:14 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40330 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbhJKKSL (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 06:18:11 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AA7492004D;
        Mon, 11 Oct 2021 10:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633947370; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Yzr+p5YTzsJTOQz54bRtvxNP0hsquMkVyj/OWvJBOM=;
        b=2N2zHsJQvesH91FdGCULSfK7H0IbfX2E79Ta9jNKsxvRRGoRkxsvA2E2WBHoRgu5mXZOWt
        ZGV6l3hGZdbIENQeSkH9f1G4hSIlEkmdDJ9vnW5ZDDsB6zXbjsAn8Y1zfw/8/0zfXq2MiL
        tJs6GTwO5w7GBS2L1eXyVcJIxFcEBzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633947370;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Yzr+p5YTzsJTOQz54bRtvxNP0hsquMkVyj/OWvJBOM=;
        b=yTggqQDAHVZw4FAfnDAa0/fT7b+czkIn6He9Qj4inD31A/mzY+jznpgN6FvH2sxTBnbLni
        ew43lna99ugFOFAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5AF2113C4C;
        Mon, 11 Oct 2021 10:16:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Lh8tE+oOZGGhMgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 10:16:10 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 08bc9e29;
        Mon, 11 Oct 2021 10:16:09 +0000 (UTC)
Date:   Mon, 11 Oct 2021 11:16:09 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YWQO6RdR7oUSNpxN@suse.de>
References: <YVdBVdOjPLCayG1k@suse.de>
 <20211010083125.dne6pcjjboixdllo@fedora>
 <YWP/SmhG8TviBE2w@suse.de>
 <YWQEgBQLdD+zsHOZ@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWQEgBQLdD+zsHOZ@T590>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 11, 2021 at 05:31:44PM +0800, Ming Lei wrote:
> On Mon, Oct 11, 2021 at 10:09:30AM +0100, Luís Henriques wrote:
> > On Sun, Oct 10, 2021 at 04:31:25PM +0800, Zorro Lang wrote:
> > > On Fri, Oct 01, 2021 at 06:11:49PM +0100, Luis Henriques wrote:
> > > > Hi!
> > > > 
> > > > I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> > > > Here's what I'm getting:
> > > > 
> > > > # cat results/generic/095.out.bad 
> > > > QA output created by 095
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
> > > > fio: pid=4090, got signal=11
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
> > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
> > > > fio: pid=4086, got signal=11
> 
> The issue should be from generic/095 test itself, which run dio with bs=1k,
> but logical block size is 4k. I guess the test may work after you change
> bs to 4k in generic/095.

Ah, I see what you mean.  Ok, I've used the patch bellow and the test now
passes.  The patch changes the block size only for the DIO jobs, there are
other jobs where bs=1k is still used.  Do you think other jobs should be
changed as well?

Cheers,
--
Luís

From 7e304a3dc11b7761700aff853078ef7171dd5d6e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Date: Mon, 11 Oct 2021 11:08:47 +0100
Subject: [PATCH] generic/095: use device blocksize instead of 1k for DIO
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This test fails for ext4 and xfs when using zram.  As pointed out by others
(Zorro and Ming), the test shouldn't use 1k for dio.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 tests/generic/095 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/generic/095 b/tests/generic/095
index c4693917b3e1..47d18e1a6f63 100755
--- a/tests/generic/095
+++ b/tests/generic/095
@@ -23,6 +23,7 @@ iodepth_batch=$((8 * LOAD_FACTOR))
 numjobs=$((5 * LOAD_FACTOR))
 fio_config=$tmp.fio
 fio_out=$tmp.fio.out
+blksz=$(_get_block_size $SCRATCH_MNT)
 cat >$fio_config <<EOF
 [global]
 bs=8k
@@ -34,7 +35,7 @@ directory=$SCRATCH_MNT
 numjobs=$numjobs
 [job1]
 ioengine=sync
-bs=1k
+bs=$blksz
 direct=1
 rw=randread
 filename=file1:file2
@@ -44,7 +45,7 @@ rw=randwrite
 direct=1
 filename=file1:file2
 [job3]
-bs=1k
+bs=$blksz
 ioengine=posixaio
 rw=randwrite
 direct=1
