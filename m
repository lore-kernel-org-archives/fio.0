Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4C5C433FE
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 12:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A6460F3A
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 12:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhJKMrH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:47:07 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45138 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234921AbhJKMrG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 08:47:06 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 19BCj1nH002647
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 08:45:01 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B7FB015C00CA; Mon, 11 Oct 2021 08:44:54 -0400 (EDT)
Date:   Mon, 11 Oct 2021 08:44:54 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Ming Lei <ming.lei@redhat.com>, fstests@vger.kernel.org,
        fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YWQxxtH20NYfrVQx@mit.edu>
References: <YVdBVdOjPLCayG1k@suse.de>
 <20211010083125.dne6pcjjboixdllo@fedora>
 <YWP/SmhG8TviBE2w@suse.de>
 <YWQEgBQLdD+zsHOZ@T590>
 <YWQO6RdR7oUSNpxN@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWQO6RdR7oUSNpxN@suse.de>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 11, 2021 at 11:16:09AM +0100, Luís Henriques wrote:
> 
> Ah, I see what you mean.  Ok, I've used the patch bellow and the test now
> passes.  The patch changes the block size only for the DIO jobs, there are
> other jobs where bs=1k is still used.  Do you think other jobs should be
> changed as well?

When you try to submit this to fstests, what I'd suggest is to use
_min_dio_alignment (defined in common/rc) to set the block size for
DIO in the fio jobs.

Cheers,

					- Ted
