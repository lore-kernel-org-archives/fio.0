Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] .gitignore: ignore tags files and additional output
 binaries
References: <20171204205316.23312-1-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <73035f59-d448-01ed-9210-476a7e898693@kernel.dk>
Date: Thu, 14 Dec 2017 09:09:31 -0700
MIME-Version: 1.0
In-Reply-To: <20171204205316.23312-1-elliott@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/04/2017 01:53 PM, Robert Elliott wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> Ignore tags files used by emacs and ctags/vim.
> 
> Ignore the additional output binaries alongside fio, such as gfio
> and all the programs in t/.

Applied, thanks Robert.

-- 
Jens Axboe


