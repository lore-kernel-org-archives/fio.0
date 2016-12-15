Return-Path: <axboe@kernel.dk>
Date: Thu, 15 Dec 2016 13:29:37 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: "fio --server" on Windows -> "fio: waitpid: Function not
 implemented"
Message-ID: <20161215202937.GD29056@kernel.dk>
References: <CAE7O3TdQh8MmuJeb6Q+QD+LOD2ZKaEBfFSBbL1dV0YDuKs-GXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7O3TdQh8MmuJeb6Q+QD+LOD2ZKaEBfFSBbL1dV0YDuKs-GXA@mail.gmail.com>
To: "Olausson, Bjoern" <contactme@olausson.de>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Dec 07 2016, Olausson, Bjoern wrote:
> Hello FIO users,
> 
> I have to run some benchmarks on multiple Windows Server 2012 Build
> 9200 clients.
> 
> When I start fio as server on the windows machines everything looks
> fine until I commence the benchmark, I get the following output:
> 
> 
> PS C:\Program Files\fio> .\fio.exe --server
> fio: server listening on 0.0.0.0,8765
> fork is not implemented
> waitpid is not implemented
> fio: waitpid: Function not implemented
> waitpid is not implemented
> fio: waitpid: Function not implemented

Windows doesn't support fork(), and the fio server implementation was
written to use processes. It could be made threaded instead and switched
to that, in which case it would work. But it would require a fair amount
of work...

-- 
Jens Axboe


