Return-Path: <rebecca@bluestop.org>
Subject: Re: [PATCH 5/6] Silence Cygwin warning "'vsprintf_s' redeclared
 without dllimport..."
References: <20170219182223.120559-1-tkusumi@tuxera.com>
 <20170219182223.120559-5-tkusumi@tuxera.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <a291dd06-c42e-45d4-e39a-a6da42d3250f@bluestop.org>
Date: Sun, 19 Feb 2017 12:07:51 -0700
MIME-Version: 1.0
In-Reply-To: <20170219182223.120559-5-tkusumi@tuxera.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <tkusumi@tuxera.com>, axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2/19/17 11:22 AM, Tomohiro Kusumi wrote:
> Silence a compiler warning which used to didn't show up with some
> old version of Cygwin. ad9c0fbc in 2012 added this, but it seems
> this prototype should have been declared by an appropriate header
> that's already been included here, so drop this prototype.
> It also sounds what this message means according to Google.

Thanks, I've been meaning to make the same change.

-- 
Rebecca


