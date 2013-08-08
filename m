Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966550Ab3HHU6t (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Aug 2013 16:58:49 -0400
Message-ID: <52040657.208@kernel.dk>
Date: Thu, 08 Aug 2013 14:57:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Server mode problems with 2.1.1
References: <CAGRFgs1hbS8pT01+w50-iF3sj3b1gCCrf-zSpP0CGhnQ-utgrA@mail.gmail.com>
In-Reply-To: <CAGRFgs1hbS8pT01+w50-iF3sj3b1gCCrf-zSpP0CGhnQ-utgrA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: George Smith <glsmith555@gmail.com>
Cc: fio@vger.kernel.org, bruce@cran.org.uk

On 08/06/2013 03:52 PM, George Smith wrote:
> Hello,
> 
> I have been using FIO (2.0.15) server mode successfully on Linux
> (CentOS 6) and Windows (2012) for perhaps the last 6 months.
> 
> Today I built the new (as of a few days ago) FIO 2.1.1 on Linux, and
> everything seems fine there including server mode (Linux -> Linux).
> 
> On Windows (package downloaded from bluestop), however, server mode
> does not seem to work anymore.  To be clear, I'm running
> 
> fio --client <ip> job
> 
> from Linux, to an
> 
> fio --server
> 
> instance running on Win2012.  The client connect hangs, and the server
> on the Windows box spews the following:
> 
> fork is not implemented
> waitpid is not implemented
> fio: waitpid: Function not implemented
> waitpid is not implemented
> <repeat of the previous errors until the client or server is killed>
> 
> I haven't really debugged this too much, was just wondering if I'm
> missing something major (being relatively new to FIO and this list).
> I'm assuming server mode is still supposed to work in these newer
> releases much the same way that the 2.0.15 I'm using does?

I don't think you are missing anything, I wonder what broke the server
mode on Windows. Bruce, any ideas?

-- 
Jens Axboe

