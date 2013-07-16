Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48199 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab3GPU6Q (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Jul 2013 16:58:16 -0400
Date: Tue, 16 Jul 2013 14:58:10 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Question about exec_string()
Message-ID: <20130716205810.GM22392@kernel.dk>
References: <51E4F3F6.3030808@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E4F3F6.3030808@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: fio@vger.kernel.org

On Tue, Jul 16 2013, Erwan Velu wrote:
> Hi,
> 
> I'm continuing my experiments with fio and adding features to genfio.
> I'm currently adding to genfio the exec_{pre|post}run support.
> 
> I'm benching some ceph and so need to reset OSD's caches with echoing in
> drop_cache.
> To achieve that, I'm using kash (from kanif) and having the following
> syntaxt :
> 
> kash -n m1sw1 -n m1sw2 -n m1sw3 -n m2sw1 -n m2sw3 -- echo 3 >
> /proc/sys/vm/drop_caches
> 
> To be able to ssh all this nodes, I need my env to be kept as it relies on
> my ssh-agent.
> That's where I do my troubles.
> 
> exec_prerun uses exec_string() with does a "sh -c %s'". That does loose my
> env and prevents me from executing my command.
> 
> I've been testing by removing the "sh -c" and only keep "%s" which works
> perfectly.
> I'm so wondering what was the targeted role of executing sh instead of
> running the command directly.
> If you agree about this change, I can provide the patch.

I suspect that would be fine.

> Note also it would be lovely to have an explicit redirection of the output
> as unless it's pretty hard to understand if the command got run with its
> associated output.

I'll happily take a patch to include the output into the general logging
:-). That's the way it should work.

-- 
Jens Axboe

