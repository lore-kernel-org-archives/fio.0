Return-Path: <mcgrof@gmail.com>
Return-Path: <mcgrof@gmail.com>
Date: Mon, 10 Sep 2018 10:32:48 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: Revert of 1d1b65dc17c39f43dbe9d66062ca61fc3e90ddfc
Message-ID: <20180910173248.GA3456@garbanzo.do-not-panic.com>
References: <e0584921-2c98-b9af-e31e-780f929631b9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0584921-2c98-b9af-e31e-780f929631b9@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Sep 07, 2018 at 01:21:27PM -0600, Jens Axboe wrote:
> Hi Luis,
> 
> I reverted this commit today, it breaks the normal use case
> which is:
> 
> $ ./fio --server
> $ ./fio --minimal --client=bla job.fio
> 
> since no output is generated at all. I don't have much time
> to look at it right now, would be great if you could.

Will do.

  Luis

