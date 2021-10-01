Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C14C433EF
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 20:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F8861ACF
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 20:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhJAUJ2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 16:09:28 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49333 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1354661AbhJAUJ2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 16:09:28 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 191K7bA1009713
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 1 Oct 2021 16:07:37 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4635815C34AA; Fri,  1 Oct 2021 16:07:37 -0400 (EDT)
Date:   Fri, 1 Oct 2021 16:07:37 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YVdqiQznwuKVcPYV@mit.edu>
References: <YVdBVdOjPLCayG1k@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVdBVdOjPLCayG1k@suse.de>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Oct 01, 2021 at 06:11:49PM +0100, Luis Henriques wrote:
> Hi!
> 
> I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> Here's what I'm getting:
> 
> This was for ext4 but the output for xfs is similar.  Since fio is getting
> killed I suspect this may be an issue with this tool.  Thus I'm sending
> this to both fio and fstests mailing-lists.
> 
> I'm using a 5.15-rc3 kernel and fio-3.28.  Is anyone else seeing something
> similar?

Hmm, it's not failing for me.

ext4/4k: 1 tests, 3 seconds
  generic/095  Pass     2s
Totals: 1 tests, 0 skipped, 0 failures, 0 errors, 2s

root@kvm-xfstests:~# uname -a
Linux kvm-xfstests 5.15.0-rc3-xfstests #355 SMP Fri Oct 1 14:44:55 EDT 2021 x86_64 GNU/Linux
root@kvm-xfstests:~# ver
blktests        62ec9d6 (Tue, 1 Jun 2021 10:08:38 -0700)
e2fsprogs       v1.46.4-5-g4cda2545-orphan_file (Sun, 22 Aug 2021 10:07:15 -0400)
fio             fio-3.27 (Wed, 26 May 2021 10:10:32 -0600)
fsverity        v1.4 (Mon, 14 Jun 2021 16:14:52 -0700)
ima-evm-utils   v1.3.2 (Wed, 28 Oct 2020 13:18:08 -0400)
nvme-cli        v1.14-61-gf729e93 (Fri, 25 Jun 2021 10:21:17 -0600)
quota           v4.05-40-g25f16b1 (Tue, 16 Mar 2021 17:57:19 +0100)
util-linux      v2.37 (Tue, 1 Jun 2021 09:52:10 +0200)
xfsprogs        v5.12.0 (Fri, 21 May 2021 15:53:24 -0400)
xfstests        linux-v3.8-3301-ga8b2de63 (Wed, 1 Sep 2021 12:07:48 -0400)
xfstests-bld    8c07d08 (Fri, 27 Aug 2021 22:11:13 -0400)

I'm using fio 3.27, though.

					- Ted
