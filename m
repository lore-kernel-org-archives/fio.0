Return-Path: <axboe@kernel.dk>
Date: Tue, 4 Jul 2017 16:09:00 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/7] Sync fio(1) man page with HOWTO
Message-ID: <20170704220858.GB15281@kernel.dk>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Tue, Jul 04 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> The man page hasn't been in sync with many of the updates made for
> HOWTO. These commits update the man page based on what HOWTO has,
> where each commit corresponds to a single section (instead of updating
> with commit-to-commit basis). The man page being in sync with HOWTO
> also makes it easier to make changes, whenever HOWTO is updated in the
> future.
> 
> The goal is to be in sync with HOWTO without being too verbose for
> a man page. Note that they don't include contents that do not exist
> in HOWTO (i.e. I didn't newly create anything). Also note these are
> only beginning part of the man page.
> 
> These commits include
> 1. Import updates made only for HOWTO (diffs), unless the changes are
>    too long/verbose to be mentioned in the man page.
> 2. Replace the entire section or paragraph with the corresponding one
>    in HOWTO (partly as a result of 1), if these two are essencially
>    saying the same thing with small modification, so that we don't see
>    two different contents in two documents that are almost the same.
> 3. Make some small changes when above two are imported, such as using
>    directives, removal of double white spaces, removal of expressions
>    that don't fit in well with a man page (e.g. This section describes...).
> 4. Backport some small changes from the man page to HOWTO, which seem
>    to have been made when the man page was first introduced. These are
>    mostly minor fixups.

Thanks, applied.

-- 
Jens Axboe


