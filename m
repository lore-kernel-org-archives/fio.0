Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6523FC433EF
	for <fio@archiver.kernel.org>; Mon,  4 Oct 2021 16:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E4D461206
	for <fio@archiver.kernel.org>; Mon,  4 Oct 2021 16:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhJDQUY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 4 Oct 2021 12:20:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39891 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236614AbhJDQUW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Oct 2021 12:20:22 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 194GIPsL025709
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 4 Oct 2021 12:18:25 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 05A8515C34DF; Mon,  4 Oct 2021 12:18:24 -0400 (EDT)
Date:   Mon, 4 Oct 2021 12:18:24 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, fstests@vger.kernel.org,
        fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YVspUJUSk1gB23JK@mit.edu>
References: <YVdBVdOjPLCayG1k@suse.de>
 <882f4c20-2e21-219b-0ca3-7e215e2d7cfa@kernel.dk>
 <YVeE2ZVkpGbTKZpG@mit.edu>
 <86ee93vijj.fsf@orpheus.olymp>
 <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <YVrSnW2RKP5hjxx6@suse.de>
 <YVrUX+qOJCDKp/Ng@suse.de>
 <YVrwvqOiI6CMpq2X@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVrwvqOiI6CMpq2X@suse.de>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 04, 2021 at 01:17:02PM +0100, Luis Henriques wrote:
> 
> Ok, I may have narrowed it a bit more.  The disks being used in my testing
> were zram-based (I know, I should have mentioned it before :-/ ).  If I use
> file-based disks the test passes and I see no crashes in fio.

What was the last kernel version where it didn't crash for you?   5.14?

And maybe we need to have a test which explicitly uses zram, since I
suspect many/most of the fs developers who are running fstests aren't
using zram....

						- Ted
