Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5350DC433FE
	for <fio@archiver.kernel.org>; Wed,  6 Oct 2021 13:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E9B7610CC
	for <fio@archiver.kernel.org>; Wed,  6 Oct 2021 13:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhJFNlr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Oct 2021 09:41:47 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54540 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhJFNlp (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Oct 2021 09:41:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 54783223EF;
        Wed,  6 Oct 2021 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633527592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUvdkLi2mfwFtZD+nGEn9TuSuGzEBLmzXvDw1DutwLU=;
        b=1fRpODniokaIUNUqoRqJUhVKGq/Eh3lBPnNHFOd0zVMSAVlaTw44dmxTmNPcYsO5bBM3tb
        H41HbWdwS2hh5kVzJ1ZxhP2PcPRkfshKP3Z0o7QnF8OMxekPAbWa4AX3w+I1mfZNIAKuD6
        LNHKzGll8DS+X9srz7X6fkt+loecwyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633527592;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUvdkLi2mfwFtZD+nGEn9TuSuGzEBLmzXvDw1DutwLU=;
        b=eBAlP2uukvI230+wasq09FM3v1cvemGMzSVFtzeI8oNDADhQ9piBGGD5DND9nHBLBoCgTA
        /53Ru5ocmF2QowDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D36F913B37;
        Wed,  6 Oct 2021 13:39:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ra/JMCenXWGDZQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 06 Oct 2021 13:39:51 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 00c85fac;
        Wed, 6 Oct 2021 13:39:51 +0000 (UTC)
Date:   Wed, 6 Oct 2021 14:39:50 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Jens Axboe <axboe@kernel.dk>, fstests@vger.kernel.org,
        fio@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YV2nJmYbFbD3CBXq@suse.de>
References: <YVdBVdOjPLCayG1k@suse.de>
 <882f4c20-2e21-219b-0ca3-7e215e2d7cfa@kernel.dk>
 <YVeE2ZVkpGbTKZpG@mit.edu>
 <86ee93vijj.fsf@orpheus.olymp>
 <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <YVrSnW2RKP5hjxx6@suse.de>
 <YVrUX+qOJCDKp/Ng@suse.de>
 <YVrwvqOiI6CMpq2X@suse.de>
 <YVspUJUSk1gB23JK@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVspUJUSk1gB23JK@mit.edu>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

(sorry for the delay in my replies)

On Mon, Oct 04, 2021 at 12:18:24PM -0400, Theodore Ts'o wrote:
> On Mon, Oct 04, 2021 at 01:17:02PM +0100, Luis Henriques wrote:
> > 
> > Ok, I may have narrowed it a bit more.  The disks being used in my testing
> > were zram-based (I know, I should have mentioned it before :-/ ).  If I use
> > file-based disks the test passes and I see no crashes in fio.
> 
> What was the last kernel version where it didn't crash for you?   5.14?

No, this is not a regression.  I tried to go as far as 5.0 and I still get
the exact same behaviour.  Also, I've tried fio 3.24 and it still
crashes.

So, this definitely looks like a zram issue.  I've added the maintainers
to the CC list in case they have any ideas.

> And maybe we need to have a test which explicitly uses zram, since I
> suspect many/most of the fs developers who are running fstests aren't
> using zram....
> 
> 						- Ted

Cheers,
--
Luís
