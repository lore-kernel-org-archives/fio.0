Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6461AC433FE
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 13:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D43360EB4
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 13:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhJKNoQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:44:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43324 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbhJKNnd (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 09:43:33 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 13A6121FE1;
        Mon, 11 Oct 2021 13:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633959692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bCghosm4jvJJfceYaOEG6VO2UqDweN83E7EU3nFLjWI=;
        b=nlUCSMG2Hu6hsWyRnu9dWPCB18MOjHIC62W8K/awEepPZREf9v7LCkVmht0SlWFFEb8PPM
        bjSAa5YhyJqlmTJrs/rYC1IltB5B/FfoepfAwgMlEflM34Uk1ynnuf89y/sThkK1k4FjAb
        on5VKfeTRhf+CqySEyYc0aJCC9xdxMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633959692;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bCghosm4jvJJfceYaOEG6VO2UqDweN83E7EU3nFLjWI=;
        b=8G5VK8Zupji2IXA2torxsaZHAVJBjt6G1riQiZwf97PEyo1Sk4LO/bRC4KIQbmBkYOzlOV
        DOieVrUIerp5KGCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF8EE13C5E;
        Mon, 11 Oct 2021 13:41:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZJoHKAs/ZGE4HgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 13:41:31 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 2ead431f;
        Mon, 11 Oct 2021 13:41:30 +0000 (UTC)
Date:   Mon, 11 Oct 2021 14:41:30 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ming Lei <ming.lei@redhat.com>, fstests@vger.kernel.org,
        fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YWQ/CpvIjxxclYbz@suse.de>
References: <YVdBVdOjPLCayG1k@suse.de>
 <20211010083125.dne6pcjjboixdllo@fedora>
 <YWP/SmhG8TviBE2w@suse.de>
 <YWQEgBQLdD+zsHOZ@T590>
 <YWQO6RdR7oUSNpxN@suse.de>
 <YWQxxtH20NYfrVQx@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWQxxtH20NYfrVQx@mit.edu>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 11, 2021 at 08:44:54AM -0400, Theodore Ts'o wrote:
> On Mon, Oct 11, 2021 at 11:16:09AM +0100, Luís Henriques wrote:
> > 
> > Ah, I see what you mean.  Ok, I've used the patch bellow and the test now
> > passes.  The patch changes the block size only for the DIO jobs, there are
> > other jobs where bs=1k is still used.  Do you think other jobs should be
> > changed as well?
> 
> When you try to submit this to fstests, what I'd suggest is to use
> _min_dio_alignment (defined in common/rc) to set the block size for
> DIO in the fio jobs.

Ok, will do.  Thanks.

Cheers,
--
Luís
