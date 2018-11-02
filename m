Return-Path: <axboe@kernel.dk>
Date: Fri, 2 Nov 2018 11:20:21 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] fix windows cpu count
Message-ID: <20181102172019.GA1660@kernel.dk>
References: <MWHPR04MB03200B2DD2F07C83B09550C48FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR04MB03200B2DD2F07C83B09550C48FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Nov 02 2018, Jeff Furlong wrote:
> This patch resolves c479640d6208236744f0562b1e79535eec290e2b where the
> CPU count returns max possible supported CPUs, and instead returns
> current active CPUs.

This is still broken, long lines broken up, = turned to =3D, etc. I've
fixed it up manually and applied it, please double check:

http://git.kernel.dk/cgit/fio/commit/?id=290c64f219cd22cf67a94b6c5ba74a300ddc2ed3

Note for future patches - if a patch fixes some other patch, the way to
indicate that is how I did it:

Fixes: c479640d6208 ("Merge branch 'proc_group' of https://github.com/sitsofe/fio")

But even this one isn't fully correct, since it's a merge commit, it
should have been the individual patch in that merge.

-- 
Jens Axboe


