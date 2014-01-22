Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44254 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbaAVWVM (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Jan 2014 17:21:12 -0500
Date: Wed, 22 Jan 2014 14:21:08 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fio crashes in setup_file
Message-ID: <20140122222108.GX20347@kernel.dk>
References: <F9567754259D974D88F5F5337C9D21962022C70F@xmb-aln-x11.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F9567754259D974D88F5F5337C9D21962022C70F@xmb-aln-x11.cisco.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Roopeshakumar Narayansa Shalgar (rshalgar)" <rshalgar@cisco.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Jan 20 2014, Roopeshakumar Narayansa Shalgar (rshalgar) wrote:
> Hi,
> 
> The moment I define a new variable under thread_options I start seeing
> a crash in 'setup_files' files Function.  Backtrace points to the
> following lline:
> 
> if (td->io_ops->setup).  Gdb shows the value of null for io_ops. 
> 
> 
> So essentially what's happenings is io_ops is not getting set
> correctly when I add a new variable under 'thread_options' structures.
> 
> 
> This can be easily reproduced by simply adding a variable under
> thread_options structiure.  No other changes are required. Can someone
> help? 

Might be a build issue, try to do a make clean after modifying the
header.

-- 
Jens Axboe

