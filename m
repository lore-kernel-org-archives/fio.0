Return-Path: <axboe@kernel.dk>
Message-ID: <5418ED70.7030109@kernel.dk>
Date: Tue, 16 Sep 2014 20:09:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: io_u_log_error ddir name mismatch
References: <94D0CD8314A33A4D9D801C0FE68B402958C8469C@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C8469C@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-09-16 16:24, Elliott, Robert (Server Storage) wrote:
> The names in io_u_log_error:
>         const char *msg[] = { "read", "write", "sync", "datasync",
>                                 "sync_file_range", "wait", "trim" };
>
> which are printed with
> 	log_err (msg[io_u->ddir]);
>
> don't match the enum values for io_u->ddir:
>
> enum fio_ddir {
>          DDIR_READ = 0,
>          DDIR_WRITE = 1,
>          DDIR_TRIM = 2,
>          DDIR_RWDIR_CNT = 3,
>          DDIR_SYNC = 3,
>          DDIR_DATASYNC,
>          DDIR_SYNC_FILE_RANGE,
>          DDIR_WAIT,
>          DDIR_INVAL = -1,
> };
>
> struct io_u {
>          enum fio_ddir ddir;
> ...
>
> Maybe TRIM was moved earlier at some point?

TRIM was turned into a first class citizen at one point, I suspect that 
is when it broke. It's broken in both io_u.c and iolog.c. I fixed it by 
killing them both, and adding a function for this right in io_ddir.h 
where the data directions are defined.

Thanks Robert!

-- 
Jens Axboe


