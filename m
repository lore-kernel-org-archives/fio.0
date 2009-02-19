Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:17993 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZBSHtk (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Feb 2009 02:49:40 -0500
Date: Thu, 19 Feb 2009 08:47:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Disabling verify when norandommap is given
Message-ID: <20090219074712.GD30821@kernel.dk>
References: <66dfd3fe0902181512o5a88da43waaf09834bd6d37ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0902181512o5a88da43waaf09834bd6d37ac@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Feb 18 2009, Radha Ramachandran wrote:
> Hi,
> Is there a reason why there is a hard rule to disable verify when
> norandommap option is also set?

Without a map of the blocks that have been written already, you might
overwrite full or partial blocks before you are done. That would cause
verify to fail. See the 'norandommap' explanation in the HOWTO as well.

-- 
Jens Axboe

