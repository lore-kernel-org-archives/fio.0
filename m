Return-Path: <axboe@kernel.dk>
Date: Mon, 2 Jan 2017 18:20:09 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 01/12] Avoid using units in option defaults
Message-ID: <20170103012009.GB20992@kernel.dk>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222205051.4677-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161222205051.4677-1-elliott@hpe.com>
To: Robert Elliott <elliott@hpe.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Dec 22 2016, Robert Elliott wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> Change option defaults and some generated option strings to specify
> the number of bytes without units, so they are immune to the
> interpretation of the units (e.g. is 1M interpreted as
> 1048576 or 1000000).

Applied the whole series, thanks.

-- 
Jens Axboe


