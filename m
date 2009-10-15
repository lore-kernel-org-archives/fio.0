Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37415 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbZJOFPs (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Oct 2009 01:15:48 -0400
Date: Thu, 15 Oct 2009 07:15:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix bug in bssplit parsing
Message-ID: <20091015051511.GY9228@kernel.dk>
References: <7ce25bc50910141515y3f43f6c1xdb903594377a51c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ce25bc50910141515y3f43f6c1xdb903594377a51c0@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kenneth Waters <kwaters@google.com>
Cc: fio@vger.kernel.org

On Wed, Oct 14 2009, Kenneth Waters wrote:
> Fio,
> 
> I found a bug is bssplit parsing in bssplit_ddir() when trying to use
> FIO on an ARM platform.  It looks like str_to_decimal() takes a "void
> *" as its fourth argument, which it passes to get_multi_bytes(), which
> is passes to fio_get_kb_base(), which casts it to a "struct
> thread_data *".  bssplit_ddir() is passing in "struct thread_data **",
> which I think is causing fio_get_kb_base() to go paw around in the
> stack; I believe the different stack layouts between ARM and x86 is
> causing me to see this problem.  The first change that introduces this
> bug seems to be d6978a3242daad9cb7b0710b724f19225d1ed7e2.

Woops indeed, good catch! I have applied your patch. Thanks a lot.

> I apologize if this patch is in the wrong format.

It was line wrapped, but not a big deal to correct for a one-liner
patch.

-- 
Jens Axboe

