Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53401 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0BJI36 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Feb 2010 03:29:58 -0500
Date: Wed, 10 Feb 2010 09:29:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Patch to fix FreeBSD support
Message-ID: <20100210082956.GB1025@kernel.dk>
References: <98a233181002092255vcdd88f8x19345f098300e97a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98a233181002092255vcdd88f8x19345f098300e97a@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Josh Aune <luken@omner.org>
Cc: fio@vger.kernel.org

On Tue, Feb 09 2010, Josh Aune wrote:
> Hi,
> 
> Attached is a patch against fio-1.36 that fixes a few build issues on
> FreeBSD.  Tested with FreeBSD 8 and Linux Fedora 6.

Thanks, but I've moved things along a bit since, can you please check
current -git for me instead? If you don't use git, you can just
download:

http://brick.kernel.dk/snaps/fio-git-latest.tar.gz

and use that instead.

-- 
Jens Axboe

