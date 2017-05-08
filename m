Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <8e8a7151-9329-cdee-2100-3f94c5dd1b1f@kernel.dk>
References: <CAB8+yyVB8vaG6Vco21qcJie0+OkDNwOkqOxS-MyvQLYrqRzuWg@mail.gmail.com>
 <8e8a7151-9329-cdee-2100-3f94c5dd1b1f@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 8 May 2017 21:05:41 +0100
Message-ID: <CALjAwxgN=+PPByGL_ZQhq9RjTgzYE8h83NEapYtDDSSUAqDuuw@mail.gmail.com>
Subject: Re: Fio Checksum tracking and enhanced trim workloads
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: paul houlihan <phoulihan9@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> -------- Forwarded Message --------
> Subject:        Fio Checksum tracking and enhanced trim workloads
> Date:   Sun, 7 May 2017 23:54:16 -0400
> From:   paul houlihan <phoulihan9@gmail.com>
> To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
>
> I have a submission for fio that enhances the data corruption detection a=
nd diagnosis capabilities taking fio from pretty good corruption detection =
to absolute guarantees. I would like these changes on the tracking branch??=
?? to be reviewed and considered for inclusion to fio. A quick review would=
 be helpful as I am losing access to test systems shortly.
>
>
> These changes were used by a Virtual Machine caching company to assure da=
ta integrity. Most testing was on Linux 64 bits and windows 32/64 bits. The=
 windows build still had an issue with compile time asserts in libfio.c tha=
t I worked around by commenting out the asserts as this looked like a perfo=
rmance restriction. This should be researched more. The initial development=
 was on version fio 2.2.10 sources and I just ported the changes to fio lat=
est sources and tested on linux but haven=E2=80=99t yet test on windows. No=
 testing on all other fio supported OSes was done, although the changes are=
 almost exclusively to OS independent code.
>
>
> The absolute guarantees are brought about by tracking checksums to preven=
t a stale but intact prior version of a block being returned and by verifyi=
ng all reads. I was surprised to learn about the number of times fio perfor=
med concurrent I/O to the same blocks which yields indeterminate results th=
at prevent data integrity verification. Thus a number of options are not su=
pported when tracking is enabled.

Sounds interesting! Are the patches available on Github or otherwise publis=
hed?

I have a couple of patches related to overlapping I/Os (see
https://github.com/axboe/fio/pull/343 and
https://github.com/sitsofe/fio/commit/6b4cfeb95fca2d75a291c54ca20162470c837=
a38
) because I can't afford for such I/O to be sent to the storage.
Perhaps it would be possible to amend your work to detect the overlaps
in a more efficient manner?

How does this work play with varying blocksizes (bsrange etc)?

> These limitations can be addressed by setting the verify_track option whi=
ch
>
> allocates a memory array to track the header and data checksums to assure
>
> data integrity is absolute. The array starts out empty at the beginning o=
f
>
> each fio job and is filled in as reads or writes occur, once defined the
>
> checksums from succeeding I/Os must all match. This option extends checks=
um
>
> verification to all reads in all workloads, not just the read-only worklo=
ads.

Are you sure? I thought readwrite verifying workloads caused the reads
to be verifying if the block had been written in the same workload?

> fio_header.py - a python script that displays the contents of the block h=
eader
>
>               in a corrupt data file.

Many would find this useful. Perhaps it could be ported to C like
t/verify-state.c ?

> Here are the related parameter descriptions from HOWTO:
>
>
> option verify_track=3Dbool
>
>
> Fio normally verifies data within a verify_intervalwith checksums and fil=
e
>
> offsets embedded in the data. However a prior version of a block could be
>
> returned and verified successfully. When verify_track is enabled the chec=
ksum
>
> for every verify_interval in the file is stored in a table and all read d=
ata
>
> must match the checksums in the table. The tracking table is sized as
>
> (size / verify_interval) * 4 bytes. For very large size=3D option setting=
s,
>
> such a large memory allocation may impact testing. Reads assume that the =
entire
>
> file has been previously written with a verification format using the sam=
e
>
> verify_interval. When verify_track is enabled, all reads are verified, wh=
ether
>
> writes are present in the workload or not. Sharing files by threads withi=
n a job
>
> is supported but not between jobs running concurrently so use the stonewa=
ll
>
> option when more than one non-global job is present. Verify of trimmed bl=
ocks
>
> is described for the verify_track_trim_zero option. When disabled, fio fa=
lls
>
> back on verification described under the verify option. The restrictions =
when
>
> enabling the verify_track option are:
>
> - randommap is required
>
> - softrandommap is not supported
>
> - lfsr random generator not supported when using multiple block sizes
>
> - stonewall option required when more than one job present
>
> - file size must be an even multiple of the block size when iodepth > 1
>
> - verify_backlog not supported when iodepth > 1
>
> - verify_async is not supported
>
> - file sharing between concurrent jobs not supported
>
> - numjobs must be 1
>
> - io_submit_mode must be set to "inline"

Yeah I've noticed a number of issues trying to verify with
io_submit_mode=3Doffload ...

> option verify_track_log=3Dbool
>
>
> If set when verify_track is set then on a clean shutdown, fio writes the =
checksum
>
> for each data block that has been read or written to a log named
>
> (datafilename).tracking.log. If set when fio reopens this data file and a=
 tracking
>
> log exists then the checksums are read into the tracking table and used t=
o validate
>
> every subsequent read. This allows rigorous validation of data integrity =
as data
>
> files are passed between fio jobs or over the termination of fio and rest=
art on
>
> the same system or on another system or after an OS reboot. Reverting a v=
irtual
>
> machine to a snapshot can be tested by saving the tracking log after a su=
ccessful
>
> fio run and later restoring the saved log after reverting the virtual mac=
hine.
>
> The log is deleted after being read in, so on abnormal termination no sta=
le
>
> checksums can be used. This option, the data file size and verify_interva=
l
>
> parameters should not change between jobs in the same run or on restart o=
f fio.
>
> Defaults to off. verify_track_dir defines the tracking log's directory.

How does this interact with verify_state_*
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-stat=
e-load
) ?

--=20
Sitsofe | http://sucs.org/~sits/

