Return-Path: <axboe@kernel.dk>
Date: Mon, 1 May 2017 14:44:23 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/11] configure: Disable CONFIG_POSIX_FALLOCATE on
 NetBSD even if posix_fallocate(3) compiles
Message-ID: <20170501204421.GA13925@kernel.dk>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
To: kusumi.tomohiro@gmail.com
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On Mon, May 01 2017, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> fio on NetBSD may have CONFIG_POSIX_FALLOCATE configuration enabled
> since posix_fallocate(3) compiles (at least on recent versions),
> but this is actually not supported on UFS as mentioned in below wiki
> and fio result.
> 
> https://wiki.netbsd.org/projects/project/ffs-fallocate/
> > This functionality is not currently implemented for FFS;
> 
> compile_prog() during ./configure fails to catch this as it doesn't
> run the test code after compilation (and it needs to use a valid fd
> in order to do runtime test).
> 
> This commit simply disables CONFIG_POSIX_FALLOCATE on NetBSD regardless
> of compilation result on ./configure. It doesn't check the fs type,
> but it should be enough provided that UFS is the fs used by majority
> of users and there's also no real alternative for disk fs.

I'd much rather we just avoid it if we get EOPNOTSUPP at runtime. That
way we don't have to change anything later on, when/if NetBSD does get
support for fallocate.

-- 
Jens Axboe


