Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A1EC433F5
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 15:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1DF760E94
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 15:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhJKPrL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 11:47:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47562 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhJKPrK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 11:47:10 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5BB982017B;
        Mon, 11 Oct 2021 15:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633967109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eH8JxChqH++3tbuVRaTjVgS25LLSorauh1ejMU3eF3A=;
        b=Zw24KT3fCPqyVosbwQPSYjCO3E6f0avqD5vXNXnQ0WPlUiscjEGyh3v+A+QQj64n94EJz2
        hid1xVYZMYkuMRAmQqikzMuPCvOU9zxcwcIIDT/wGScBd5zhSh4Btv+jFfbYHKSt2Bi+/r
        Y83PRHS5/x9E7Xza4G6UmaAnzVPDfrQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633967109;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eH8JxChqH++3tbuVRaTjVgS25LLSorauh1ejMU3eF3A=;
        b=5Jhezb4whhDPnXbW1Ui8wvf30Gm+QcAWz0EXGUfH6i4pA/me66MTQCUOkgwNlmLSDG1dpI
        9HCcOHVyKraUqDBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0F2B913B37;
        Mon, 11 Oct 2021 15:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Go9COwRcZGGvWQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 15:45:08 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 068f5149;
        Mon, 11 Oct 2021 15:45:08 +0000 (UTC)
Date:   Mon, 11 Oct 2021 16:45:07 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org
Subject: Re: [PATCH] fio: make sure io_u->file isn't NULL before using it
Message-ID: <YWRcA/2AIb3pMOkG@suse.de>
References: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <20211011102739.10429-1-lhenriques@suse.de>
 <42aee776-323c-634f-d950-9792de7724d2@kernel.dk>
 <YWQ/s44zyPC/ULBi@suse.de>
 <e5cc8d8e-e1ba-a97f-b761-c697bdf136b4@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XDQXnkBg5OCdiKiz"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5cc8d8e-e1ba-a97f-b761-c697bdf136b4@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


--XDQXnkBg5OCdiKiz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 11, 2021 at 09:15:47AM -0600, Jens Axboe wrote:
> On 10/11/21 7:44 AM, Luís Henriques wrote:
> > On Mon, Oct 11, 2021 at 06:58:52AM -0600, Jens Axboe wrote:
> >> On 10/11/21 4:27 AM, Luís Henriques wrote:
> >>> While running fstests generic/095 against ext4 on a zram device I started
> >>> seeing fio crashing.  Fix it by making sure io_u->file isn't NULL before
> >>> accessing it.
> >>>
> >>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> >>> ---
> >>>  io_u.c | 3 ++-
> >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/io_u.c b/io_u.c
> >>> index 5289b5d1d9c6..b8e715d4118c 100644
> >>> --- a/io_u.c
> >>> +++ b/io_u.c
> >>> @@ -2009,7 +2009,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
> >>>  			io_u->xfer_buf += bytes;
> >>>  			io_u->offset += bytes;
> >>>  			td->ts.short_io_u[io_u->ddir]++;
> >>> -			if (io_u->offset < io_u->file->real_file_size) {
> >>> +			if (io_u->file &&
> >>> +			    (io_u->offset < io_u->file->real_file_size)) {
> >>>  				requeue_io_u(td, io_u_ptr);
> >>>  				return;
> >>>  			}
> >>
> >> This will prevent the crash, but I'm wondering why io_u-> == NULL for this case.
> >> It really should be a valid file.
> >>
> >> Can you let me know exactly how you're reproducing this? Then I'll give it
> >> a whirl too.
> > 
> > Sure, here's my recipe for reproducing this bug:
> > 
> >  # modprobe zram num_devices=2
> >  # echo 1G > /sys/block/zram0/disksize 
> >  # echo 1G > /sys/block/zram1/disksize 
> >  # mkfs.ext4 /dev/zram0
> >  # mkfs.ext4 /dev/zram1
> > 
> >  # ./check generic/095
> 
> I know you fixed the issue in the test by now, but any chance you can try
> this one and see if it correctly reports full residual instead of trying
> to requeue and crash?

Sure!  So, I patched fio with this change and executed the generic/095
test twice: one run without the test fix, another with the test fix.  I
can confirm that fio didn't crash in any of the runs, but I'm not sure how
to check if it's correctly reporting residual.

I'm attaching the test logs (for the failure run) in case that helps.

Cheers,
--
Luís


> 
> diff --git a/io_u.c b/io_u.c
> index 5289b5d1d9c6..586a4befdce0 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -2004,7 +2004,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
>  		 * Make sure we notice short IO from here, and requeue them
>  		 * appropriately!
>  		 */
> -		if (io_u->resid) {
> +		if (bytes && io_u->resid) {
>  			io_u->xfer_buflen = io_u->resid;
>  			io_u->xfer_buf += bytes;
>  			io_u->offset += bytes;
> 
> -- 
> Jens Axboe
> 

--XDQXnkBg5OCdiKiz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="095.full"
Content-Transfer-Encoding: quoted-printable

fio --bs=3D8k --iodepth=3D16 --iodepth_batch=3D8 --randrepeat=3D1 --size=3D=
1m --directory=3D/tmp/mnt/scratch --numjobs=3D5 --name=3Djob1 --ioengine=3D=
sync --bs=3D1k --direct=3D1 --rw=3Drandread --filename=3Dfile1:file2 --name=
=3Djob2 --ioengine=3Dlibaio --rw=3Drandwrite --direct=3D1 --filename=3Dfile=
1:file2 --name=3Djob3 --bs=3D1k --ioengine=3Dposixaio --rw=3Drandwrite --di=
rect=3D1 --filename=3Dfile1:file2 --name=3Djob4 --ioengine=3Dsplice --direc=
t=3D1 --rw=3Drandwrite --filename=3Dfile1:file2 --name=3Djob5 --bs=3D1k --i=
oengine=3Dsync --rw=3Drandread --filename=3Dfile1:file2 --name=3Djob6 --ioe=
ngine=3Dposixaio --rw=3Drandwrite --filename=3Dfile1:file2 --name=3Djob7 --=
ioengine=3Dsplice --rw=3Drandwrite --filename=3Dfile1:file2 --name=3Djob8 -=
-ioengine=3Dmmap --rw=3Drandwrite --bs=3D1k --filename=3Dfile1:file2 --name=
=3Djob9 --ioengine=3Dmmap --rw=3Drandwrite --direct=3D1 --bs=3D4096 --filen=
ame=3Dfile1:file2=20
Discarding device blocks:      0/262144=08=08=08=08=08=08=08=08=08=08=08=08=
=08             =08=08=08=08=08=08=08=08=08=08=08=08=08done                =
           =20
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: e77d8742-2325-4f0c-a67c-9900cb195663
Superblock backups stored on blocks:=20
	32768, 98304, 163840, 229376

Allocating group tables: 0/8=08=08=08   =08=08=08done                      =
     =20
Writing inode tables: 0/8=08=08=08   =08=08=08done                         =
  =20
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: 0/8=08=08=08   =
=08=08=08done

job1: (g=3D0): rw=3Drandread, bs=3D(R) 1024B-1024B, (W) 1024B-1024B, (T) 10=
24B-1024B, ioengine=3Dsync, iodepth=3D16
=2E..
job2: (g=3D0): rw=3Drandwrite, bs=3D(R) 8192B-8192B, (W) 8192B-8192B, (T) 8=
192B-8192B, ioengine=3Dlibaio, iodepth=3D16
=2E..
job3: (g=3D0): rw=3Drandwrite, bs=3D(R) 1024B-1024B, (W) 1024B-1024B, (T) 1=
024B-1024B, ioengine=3Dposixaio, iodepth=3D16
=2E..
job4: (g=3D0): rw=3Drandwrite, bs=3D(R) 8192B-8192B, (W) 8192B-8192B, (T) 8=
192B-8192B, ioengine=3Dsplice, iodepth=3D16
=2E..
job5: (g=3D0): rw=3Drandread, bs=3D(R) 1024B-1024B, (W) 1024B-1024B, (T) 10=
24B-1024B, ioengine=3Dsync, iodepth=3D16
=2E..
job6: (g=3D0): rw=3Drandwrite, bs=3D(R) 8192B-8192B, (W) 8192B-8192B, (T) 8=
192B-8192B, ioengine=3Dposixaio, iodepth=3D16
=2E..
job7: (g=3D0): rw=3Drandwrite, bs=3D(R) 8192B-8192B, (W) 8192B-8192B, (T) 8=
192B-8192B, ioengine=3Dsplice, iodepth=3D16
=2E..
job8: (g=3D0): rw=3Drandwrite, bs=3D(R) 1024B-1024B, (W) 1024B-1024B, (T) 1=
024B-1024B, ioengine=3Dmmap, iodepth=3D16
=2E..
job9: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4=
096B-4096B, ioengine=3Dmmap, iodepth=3D16
=2E..
fio-3.28-57-g63b8-dirty
Starting 45 processes
job1: Laying out IO files (2 files / total 1MiB)
fio: pid=3D2364, got signal=3D6
fio: pid=3D2367, got signal=3D6
fio: pid=3D2368, got signal=3D6

job1: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2354: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D2, majf=3D0, minf=3D29
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job1: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2355: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D3, majf=3D3, minf=3D27
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job1: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2356: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D6, majf=3D6, minf=3D26
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job1: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2357: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D1, majf=3D0, minf=3D29
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job1: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2358: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D8, majf=3D8, minf=3D24
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2359: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1600, BW=3D12.5MiB/s (13.1MB/s)(1024KiB/80msec); 0 zone res=
ets
    slat (usec): min=3D25, max=3D37322, avg=3D2684.09, stdev=3D7381.40
    clat (usec): min=3D4, max=3D12289, avg=3D3860.08, stdev=3D3161.06
     lat (usec): min=3D77, max=3D47504, avg=3D6544.27, stdev=3D9652.17
    clat percentiles (usec):
     |  1.00th=3D[   82],  5.00th=3D[  652], 10.00th=3D[ 1221], 20.00th=3D[=
 1598],
     | 30.00th=3D[ 1713], 40.00th=3D[ 1778], 50.00th=3D[ 2343], 60.00th=3D[=
 3359],
     | 70.00th=3D[ 3949], 80.00th=3D[ 6980], 90.00th=3D[ 8586], 95.00th=3D[=
10814],
     | 99.00th=3D[11994], 99.50th=3D[12256], 99.90th=3D[12256], 99.95th=3D[=
12256],
     | 99.99th=3D[12256]
  lat (usec)   : 10=3D0.78%, 100=3D0.78%, 250=3D0.78%, 500=3D0.78%, 750=3D3=
=2E12%
  lat (usec)   : 1000=3D2.34%
  lat (msec)   : 2=3D38.28%, 4=3D24.22%, 10=3D21.88%, 20=3D7.03%
  cpu          : usr=3D0.00%, sys=3D13.92%, ctx=3D61, majf=3D3, minf=3D19
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D6.2%, 16=3D93.8%, 32=3D0=
=2E0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D98.2%, 8=3D1.8%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.0%, 16=3D0.9%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2360: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D2206, BW=3D17.2MiB/s (18.1MB/s)(1024KiB/58msec); 0 zone res=
ets
    slat (usec): min=3D19, max=3D22227, avg=3D1293.17, stdev=3D4243.34
    clat (nsec): min=3D1744, max=3D13937k, avg=3D2624525.45, stdev=3D354304=
1.64
     lat (usec): min=3D55, max=3D22739, avg=3D3917.79, stdev=3D5242.31
    clat percentiles (usec):
     |  1.00th=3D[   57],  5.00th=3D[  233], 10.00th=3D[  437], 20.00th=3D[=
  545],
     | 30.00th=3D[  570], 40.00th=3D[  594], 50.00th=3D[  627], 60.00th=3D[=
  889],
     | 70.00th=3D[ 2671], 80.00th=3D[ 3556], 90.00th=3D[ 9503], 95.00th=3D[=
11469],
     | 99.00th=3D[12649], 99.50th=3D[13960], 99.90th=3D[13960], 99.95th=3D[=
13960],
     | 99.99th=3D[13960]
  lat (usec)   : 2=3D0.78%, 100=3D0.78%, 250=3D3.91%, 500=3D5.47%, 750=3D46=
=2E88%
  lat (usec)   : 1000=3D3.91%
  lat (msec)   : 2=3D4.69%, 4=3D14.06%, 10=3D12.50%, 20=3D7.03%
  cpu          : usr=3D8.77%, sys=3D0.00%, ctx=3D33, majf=3D1, minf=3D21
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D6.2%, 16=3D93.8%, 32=3D0=
=2E0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D98.2%, 8=3D1.8%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.0%, 16=3D0.9%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2361: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1662, BW=3D13.0MiB/s (13.6MB/s)(1024KiB/77msec); 0 zone res=
ets
    slat (usec): min=3D21, max=3D31476, avg=3D2285.17, stdev=3D6451.78
    clat (nsec): min=3D1461, max=3D8546.3k, avg=3D3394454.86, stdev=3D25843=
76.00
     lat (usec): min=3D30, max=3D38816, avg=3D5679.71, stdev=3D7944.51
    clat percentiles (usec):
     |  1.00th=3D[   33],  5.00th=3D[  243], 10.00th=3D[  938], 20.00th=3D[=
 1336],
     | 30.00th=3D[ 1762], 40.00th=3D[ 2114], 50.00th=3D[ 2278], 60.00th=3D[=
 2573],
     | 70.00th=3D[ 5080], 80.00th=3D[ 5932], 90.00th=3D[ 7963], 95.00th=3D[=
 8291],
     | 99.00th=3D[ 8586], 99.50th=3D[ 8586], 99.90th=3D[ 8586], 99.95th=3D[=
 8586],
     | 99.99th=3D[ 8586]
  lat (usec)   : 2=3D0.78%, 50=3D0.78%, 100=3D1.56%, 250=3D2.34%, 500=3D1.5=
6%
  lat (usec)   : 1000=3D3.91%
  lat (msec)   : 2=3D24.22%, 4=3D34.38%, 10=3D30.47%
  cpu          : usr=3D0.00%, sys=3D6.58%, ctx=3D77, majf=3D1, minf=3D21
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D6.2%, 16=3D93.8%, 32=3D0=
=2E0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D98.2%, 8=3D1.8%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.0%, 16=3D0.9%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2362: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1684, BW=3D13.2MiB/s (13.8MB/s)(1024KiB/76msec); 0 zone res=
ets
    slat (usec): min=3D18, max=3D34986, avg=3D2547.30, stdev=3D6865.46
    clat (nsec): min=3D1454, max=3D12139k, avg=3D3714736.58, stdev=3D328228=
9.17
     lat (usec): min=3D26, max=3D45556, avg=3D6262.11, stdev=3D9137.41
    clat percentiles (usec):
     |  1.00th=3D[   28],  5.00th=3D[  190], 10.00th=3D[  343], 20.00th=3D[=
  465],
     | 30.00th=3D[ 1942], 40.00th=3D[ 2245], 50.00th=3D[ 2409], 60.00th=3D[=
 2802],
     | 70.00th=3D[ 3916], 80.00th=3D[ 6783], 90.00th=3D[ 8455], 95.00th=3D[=
11207],
     | 99.00th=3D[11994], 99.50th=3D[12125], 99.90th=3D[12125], 99.95th=3D[=
12125],
     | 99.99th=3D[12125]
  lat (usec)   : 2=3D0.78%, 50=3D0.78%, 100=3D0.78%, 250=3D4.69%, 500=3D13.=
28%
  lat (msec)   : 2=3D13.28%, 4=3D36.72%, 10=3D22.66%, 20=3D7.03%
  cpu          : usr=3D0.00%, sys=3D5.33%, ctx=3D90, majf=3D3, minf=3D19
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D6.2%, 16=3D93.8%, 32=3D0=
=2E0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D98.2%, 8=3D1.8%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.0%, 16=3D0.9%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job2: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2363: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1662, BW=3D13.0MiB/s (13.6MB/s)(1024KiB/77msec); 0 zone res=
ets
    slat (usec): min=3D20, max=3D36554, avg=3D2615.40, stdev=3D7062.59
    clat (nsec): min=3D1561, max=3D13205k, avg=3D3852028.32, stdev=3D320551=
5.13
     lat (usec): min=3D36, max=3D47273, avg=3D6467.50, stdev=3D9399.31
    clat percentiles (usec):
     |  1.00th=3D[   38],  5.00th=3D[  343], 10.00th=3D[ 1020], 20.00th=3D[=
 1500],
     | 30.00th=3D[ 1663], 40.00th=3D[ 1975], 50.00th=3D[ 2769], 60.00th=3D[=
 3359],
     | 70.00th=3D[ 4424], 80.00th=3D[ 6259], 90.00th=3D[ 8160], 95.00th=3D[=
11207],
     | 99.00th=3D[13173], 99.50th=3D[13173], 99.90th=3D[13173], 99.95th=3D[=
13173],
     | 99.99th=3D[13173]
  lat (usec)   : 2=3D0.78%, 50=3D0.78%, 100=3D0.78%, 250=3D1.56%, 500=3D3.1=
2%
  lat (usec)   : 750=3D0.78%, 1000=3D1.56%
  lat (msec)   : 2=3D31.25%, 4=3D28.91%, 10=3D23.44%, 20=3D7.03%
  cpu          : usr=3D0.00%, sys=3D6.58%, ctx=3D81, majf=3D1, minf=3D21
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D6.2%, 16=3D93.8%, 32=3D0=
=2E0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D98.2%, 8=3D1.8%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.0%, 16=3D0.9%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job3: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2364: Mon Oct 11 16:33:05 2021
  lat (msec)   : 10=3D18.75%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D50.0%, 16=3D50.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D5.3%, 4=3D84.2%, 8=3D5.3%, 16=3D5.3%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,16,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job3: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2365: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D2, majf=3D1, minf=3D27
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D50.0%, 16=3D50.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D5.6%, 4=3D94.4%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,16,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job3: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2366: Mon Oct 11 16:33:05 2021
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D5, majf=3D3, minf=3D27
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D50.0%, 16=3D50.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D5.6%, 4=3D94.4%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,16,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job3: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2367: Mon Oct 11 16:33:05 2021
  lat (usec)   : 1000=3D18.75%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D50.0%, 16=3D50.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D5.3%, 4=3D84.2%, 8=3D5.3%, 16=3D5.3%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,16,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job3: (groupid=3D0, jobs=3D1): err=3D22 (file:io_u.c:1845, func=3Dio_u erro=
r, error=3DInvalid argument): pid=3D2368: Mon Oct 11 16:33:05 2021
  lat (msec)   : 4=3D18.75%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=3D0
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D50.0%, 16=3D50.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D5.3%, 4=3D84.2%, 8=3D5.3%, 16=3D5.3%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,16,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job4: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2369: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1641, BW=3D12.8MiB/s (13.4MB/s)(1024KiB/78msec); 0 zone res=
ets
    clat (usec): min=3D32, max=3D18196, avg=3D511.89, stdev=3D1705.10
     lat (usec): min=3D32, max=3D18196, avg=3D512.09, stdev=3D1705.10
    clat percentiles (usec):
     |  1.00th=3D[   34],  5.00th=3D[   36], 10.00th=3D[   40], 20.00th=3D[=
   61],
     | 30.00th=3D[   73], 40.00th=3D[   88], 50.00th=3D[  149], 60.00th=3D[=
  176],
     | 70.00th=3D[  285], 80.00th=3D[  494], 90.00th=3D[  955], 95.00th=3D[=
 2245],
     | 99.00th=3D[ 3851], 99.50th=3D[18220], 99.90th=3D[18220], 99.95th=3D[=
18220],
     | 99.99th=3D[18220]
  lat (usec)   : 50=3D14.06%, 100=3D28.91%, 250=3D25.00%, 500=3D12.50%, 750=
=3D7.81%
  lat (usec)   : 1000=3D3.12%
  lat (msec)   : 2=3D3.12%, 4=3D4.69%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D12.99%, ctx=3D83, majf=3D5, minf=3D16
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job4: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2370: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D2064, BW=3D16.1MiB/s (16.9MB/s)(1024KiB/62msec); 0 zone res=
ets
    clat (usec): min=3D25, max=3D16986, avg=3D470.55, stdev=3D1703.89
     lat (usec): min=3D25, max=3D16986, avg=3D470.70, stdev=3D1703.90
    clat percentiles (usec):
     |  1.00th=3D[   26],  5.00th=3D[   33], 10.00th=3D[   34], 20.00th=3D[=
   38],
     | 30.00th=3D[   41], 40.00th=3D[   45], 50.00th=3D[   47], 60.00th=3D[=
   55],
     | 70.00th=3D[   76], 80.00th=3D[  363], 90.00th=3D[  947], 95.00th=3D[=
 2147],
     | 99.00th=3D[ 5604], 99.50th=3D[16909], 99.90th=3D[16909], 99.95th=3D[=
16909],
     | 99.99th=3D[16909]
  lat (usec)   : 50=3D56.25%, 100=3D16.41%, 250=3D6.25%, 500=3D8.59%, 750=
=3D0.78%
  lat (usec)   : 1000=3D2.34%
  lat (msec)   : 2=3D3.12%, 4=3D3.91%, 10=3D1.56%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D9.84%, ctx=3D45, majf=3D2, minf=3D17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job4: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2371: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1729, BW=3D13.5MiB/s (14.2MB/s)(1024KiB/74msec); 0 zone res=
ets
    clat (usec): min=3D30, max=3D18586, avg=3D476.04, stdev=3D1774.05
     lat (usec): min=3D31, max=3D18586, avg=3D476.26, stdev=3D1774.05
    clat percentiles (usec):
     |  1.00th=3D[   32],  5.00th=3D[   33], 10.00th=3D[   33], 20.00th=3D[=
   34],
     | 30.00th=3D[   56], 40.00th=3D[   89], 50.00th=3D[   93], 60.00th=3D[=
  163],
     | 70.00th=3D[  206], 80.00th=3D[  343], 90.00th=3D[  840], 95.00th=3D[=
 1614],
     | 99.00th=3D[ 5407], 99.50th=3D[18482], 99.90th=3D[18482], 99.95th=3D[=
18482],
     | 99.99th=3D[18482]
  lat (usec)   : 50=3D25.00%, 100=3D27.34%, 250=3D20.31%, 500=3D14.06%, 750=
=3D3.12%
  lat (usec)   : 1000=3D2.34%
  lat (msec)   : 2=3D3.12%, 4=3D2.34%, 10=3D1.56%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D13.70%, ctx=3D49, majf=3D2, minf=3D17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job4: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2372: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1706, BW=3D13.3MiB/s (14.0MB/s)(1024KiB/75msec); 0 zone res=
ets
    clat (usec): min=3D32, max=3D17596, avg=3D565.07, stdev=3D1719.54
     lat (usec): min=3D32, max=3D17596, avg=3D565.27, stdev=3D1719.57
    clat percentiles (usec):
     |  1.00th=3D[   34],  5.00th=3D[   36], 10.00th=3D[   39], 20.00th=3D[=
   67],
     | 30.00th=3D[   78], 40.00th=3D[  104], 50.00th=3D[  130], 60.00th=3D[=
  180],
     | 70.00th=3D[  289], 80.00th=3D[  379], 90.00th=3D[ 1303], 95.00th=3D[=
 2966],
     | 99.00th=3D[ 4228], 99.50th=3D[17695], 99.90th=3D[17695], 99.95th=3D[=
17695],
     | 99.99th=3D[17695]
  lat (usec)   : 50=3D15.62%, 100=3D23.44%, 250=3D26.56%, 500=3D16.41%, 750=
=3D3.91%
  lat (usec)   : 1000=3D2.34%
  lat (msec)   : 2=3D5.47%, 4=3D3.91%, 10=3D1.56%, 20=3D0.78%
  cpu          : usr=3D6.76%, sys=3D8.11%, ctx=3D102, majf=3D0, minf=3D17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job4: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2373: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1620, BW=3D12.7MiB/s (13.3MB/s)(1024KiB/79msec); 0 zone res=
ets
    clat (usec): min=3D35, max=3D6962, avg=3D520.71, stdev=3D1210.46
     lat (usec): min=3D35, max=3D6962, avg=3D520.98, stdev=3D1210.49
    clat percentiles (usec):
     |  1.00th=3D[   39],  5.00th=3D[   42], 10.00th=3D[   65], 20.00th=3D[=
   86],
     | 30.00th=3D[  100], 40.00th=3D[  118], 50.00th=3D[  151], 60.00th=3D[=
  172],
     | 70.00th=3D[  221], 80.00th=3D[  326], 90.00th=3D[ 1156], 95.00th=3D[=
 3163],
     | 99.00th=3D[ 6849], 99.50th=3D[ 6980], 99.90th=3D[ 6980], 99.95th=3D[=
 6980],
     | 99.99th=3D[ 6980]
  lat (usec)   : 50=3D8.59%, 100=3D20.31%, 250=3D45.31%, 500=3D12.50%, 750=
=3D1.56%
  lat (usec)   : 1000=3D1.56%
  lat (msec)   : 2=3D2.34%, 4=3D4.69%, 10=3D3.12%
  cpu          : usr=3D0.00%, sys=3D19.23%, ctx=3D113, majf=3D6, minf=3D15
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job5: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2374: Mon Oct 11 16:33:05 20=
21
  read: IOPS=3D85.3k, BW=3D83.3MiB/s (87.4MB/s)(1024KiB/12msec)
    clat (nsec): min=3D582, max=3D104452, avg=3D965.48, stdev=3D3594.28
     lat (nsec): min=3D622, max=3D104492, avg=3D1006.11, stdev=3D3595.08
    clat percentiles (nsec):
     |  1.00th=3D[   588],  5.00th=3D[   604], 10.00th=3D[   620], 20.00th=
=3D[   652],
     | 30.00th=3D[   684], 40.00th=3D[   700], 50.00th=3D[   716], 60.00th=
=3D[   732],
     | 70.00th=3D[   748], 80.00th=3D[   772], 90.00th=3D[   812], 95.00th=
=3D[   900],
     | 99.00th=3D[  4048], 99.50th=3D[  5280], 99.90th=3D[ 46336], 99.95th=
=3D[104960],
     | 99.99th=3D[104960]
  lat (nsec)   : 750=3D69.43%, 1000=3D26.46%
  lat (usec)   : 2=3D0.68%, 4=3D2.34%, 10=3D0.78%, 20=3D0.10%, 50=3D0.10%
  lat (usec)   : 250=3D0.10%
  cpu          : usr=3D9.09%, sys=3D0.00%, ctx=3D9, majf=3D6, minf=3D16
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1024,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job5: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2375: Mon Oct 11 16:33:05 20=
21
  read: IOPS=3D73.1k, BW=3D71.4MiB/s (74.9MB/s)(1024KiB/14msec)
    clat (nsec): min=3D562, max=3D17276, avg=3D759.74, stdev=3D815.84
     lat (nsec): min=3D603, max=3D17596, avg=3D799.78, stdev=3D822.30
    clat percentiles (nsec):
     |  1.00th=3D[  588],  5.00th=3D[  596], 10.00th=3D[  604], 20.00th=3D[=
  620],
     | 30.00th=3D[  644], 40.00th=3D[  660], 50.00th=3D[  684], 60.00th=3D[=
  700],
     | 70.00th=3D[  724], 80.00th=3D[  748], 90.00th=3D[  788], 95.00th=3D[=
  820],
     | 99.00th=3D[ 2768], 99.50th=3D[ 4896], 99.90th=3D[16064], 99.95th=3D[=
17280],
     | 99.99th=3D[17280]
  lat (nsec)   : 750=3D81.25%, 1000=3D16.70%
  lat (usec)   : 2=3D0.68%, 4=3D0.68%, 10=3D0.49%, 20=3D0.20%
  cpu          : usr=3D0.00%, sys=3D7.69%, ctx=3D4, majf=3D3, minf=3D18
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1024,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job5: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2376: Mon Oct 11 16:33:05 20=
21
  read: IOPS=3D93.1k, BW=3D90.9MiB/s (95.3MB/s)(1024KiB/11msec)
    clat (nsec): min=3D594, max=3D14728, avg=3D1045.56, stdev=3D1284.62
     lat (nsec): min=3D630, max=3D14769, avg=3D1086.76, stdev=3D1293.48
    clat percentiles (nsec):
     |  1.00th=3D[  604],  5.00th=3D[  620], 10.00th=3D[  636], 20.00th=3D[=
  660],
     | 30.00th=3D[  684], 40.00th=3D[  700], 50.00th=3D[  716], 60.00th=3D[=
  732],
     | 70.00th=3D[  756], 80.00th=3D[  788], 90.00th=3D[ 1064], 95.00th=3D[=
 3568],
     | 99.00th=3D[ 5664], 99.50th=3D[ 8256], 99.90th=3D[14144], 99.95th=3D[=
14784],
     | 99.99th=3D[14784]
  lat (nsec)   : 750=3D67.48%, 1000=3D22.27%
  lat (usec)   : 2=3D1.95%, 4=3D5.76%, 10=3D2.15%, 20=3D0.39%
  cpu          : usr=3D10.00%, sys=3D0.00%, ctx=3D6, majf=3D5, minf=3D16
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1024,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job5: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2377: Mon Oct 11 16:33:05 20=
21
  read: IOPS=3D85.3k, BW=3D83.3MiB/s (87.4MB/s)(1024KiB/12msec)
    clat (nsec): min=3D641, max=3D16976, avg=3D878.51, stdev=3D857.12
     lat (nsec): min=3D681, max=3D17021, avg=3D923.44, stdev=3D864.64
    clat percentiles (nsec):
     |  1.00th=3D[  652],  5.00th=3D[  668], 10.00th=3D[  684], 20.00th=3D[=
  700],
     | 30.00th=3D[  724], 40.00th=3D[  748], 50.00th=3D[  772], 60.00th=3D[=
  788],
     | 70.00th=3D[  804], 80.00th=3D[  828], 90.00th=3D[  868], 95.00th=3D[=
  908],
     | 99.00th=3D[ 4320], 99.50th=3D[ 5024], 99.90th=3D[14784], 99.95th=3D[=
17024],
     | 99.99th=3D[17024]
  lat (nsec)   : 750=3D39.75%, 1000=3D57.13%
  lat (usec)   : 2=3D0.49%, 4=3D1.37%, 10=3D1.07%, 20=3D0.20%
  cpu          : usr=3D9.09%, sys=3D0.00%, ctx=3D9, majf=3D8, minf=3D14
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1024,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job5: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2378: Mon Oct 11 16:33:05 20=
21
  read: IOPS=3D68.3k, BW=3D66.7MiB/s (69.9MB/s)(1024KiB/15msec)
    clat (nsec): min=3D642, max=3D27395, avg=3D978.34, stdev=3D1424.98
     lat (nsec): min=3D679, max=3D27933, avg=3D1023.85, stdev=3D1434.63
    clat percentiles (nsec):
     |  1.00th=3D[  652],  5.00th=3D[  668], 10.00th=3D[  676], 20.00th=3D[=
  700],
     | 30.00th=3D[  732], 40.00th=3D[  756], 50.00th=3D[  772], 60.00th=3D[=
  796],
     | 70.00th=3D[  812], 80.00th=3D[  844], 90.00th=3D[  892], 95.00th=3D[=
 1096],
     | 99.00th=3D[ 6048], 99.50th=3D[ 8640], 99.90th=3D[19328], 99.95th=3D[=
27520],
     | 99.99th=3D[27520]
  lat (nsec)   : 750=3D37.30%, 1000=3D57.23%
  lat (usec)   : 2=3D2.15%, 4=3D1.07%, 10=3D1.86%, 20=3D0.29%, 50=3D0.10%
  cpu          : usr=3D7.14%, sys=3D0.00%, ctx=3D9, majf=3D8, minf=3D14
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D1024,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job6: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2379: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1855, BW=3D14.5MiB/s (15.2MB/s)(1024KiB/69msec); 0 zone res=
ets
    slat (nsec): min=3D141, max=3D75144, avg=3D1565.61, stdev=3D7509.80
    clat (usec): min=3D8, max=3D33482, avg=3D6816.01, stdev=3D8391.68
     lat (usec): min=3D9, max=3D33483, avg=3D6817.58, stdev=3D8392.09
    clat percentiles (usec):
     |  1.00th=3D[   10],  5.00th=3D[   19], 10.00th=3D[   38], 20.00th=3D[=
  147],
     | 30.00th=3D[ 1467], 40.00th=3D[ 2180], 50.00th=3D[ 3556], 60.00th=3D[=
 5014],
     | 70.00th=3D[ 7504], 80.00th=3D[13435], 90.00th=3D[17695], 95.00th=3D[=
28967],
     | 99.00th=3D[33162], 99.50th=3D[33424], 99.90th=3D[33424], 99.95th=3D[=
33424],
     | 99.99th=3D[33424]
  lat (usec)   : 10=3D3.12%, 20=3D2.34%, 50=3D5.47%, 100=3D7.03%, 250=3D3.9=
1%
  lat (usec)   : 500=3D1.56%, 750=3D1.56%, 1000=3D0.78%
  lat (msec)   : 2=3D12.50%, 4=3D14.84%, 10=3D25.00%, 20=3D12.50%, 50=3D9.3=
8%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D74, majf=3D2, minf=3D27
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D62.5%, 16=3D37.5%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D96.1%, 8=3D3.4%, 16=3D0.6%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job6: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2380: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D2560, BW=3D20.0MiB/s (21.0MB/s)(1024KiB/50msec); 0 zone res=
ets
    slat (nsec): min=3D203, max=3D148143, avg=3D2370.61, stdev=3D13430.86
    clat (usec): min=3D6, max=3D25433, avg=3D4766.72, stdev=3D7242.47
     lat (usec): min=3D6, max=3D25434, avg=3D4769.09, stdev=3D7244.42
    clat percentiles (usec):
     |  1.00th=3D[    7],  5.00th=3D[   20], 10.00th=3D[   22], 20.00th=3D[=
   40],
     | 30.00th=3D[  235], 40.00th=3D[ 1045], 50.00th=3D[ 1385], 60.00th=3D[=
 2966],
     | 70.00th=3D[ 4555], 80.00th=3D[ 6718], 90.00th=3D[22414], 95.00th=3D[=
22938],
     | 99.00th=3D[23462], 99.50th=3D[25560], 99.90th=3D[25560], 99.95th=3D[=
25560],
     | 99.99th=3D[25560]
  lat (usec)   : 10=3D2.34%, 20=3D4.69%, 50=3D16.41%, 100=3D2.34%, 250=3D4.=
69%
  lat (usec)   : 500=3D1.56%, 750=3D0.78%, 1000=3D4.69%
  lat (msec)   : 2=3D15.62%, 4=3D10.16%, 10=3D23.44%, 20=3D1.56%, 50=3D11.7=
2%
  cpu          : usr=3D2.04%, sys=3D0.00%, ctx=3D41, majf=3D1, minf=3D28
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D43.8%, 16=3D56.2%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D95.5%, 8=3D3.4%, 16=3D1.1%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job6: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2381: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1910, BW=3D14.9MiB/s (15.7MB/s)(1024KiB/67msec); 0 zone res=
ets
    slat (nsec): min=3D145, max=3D63825, avg=3D1455.53, stdev=3D6646.46
    clat (usec): min=3D7, max=3D26472, avg=3D6863.34, stdev=3D7084.59
     lat (usec): min=3D8, max=3D26473, avg=3D6864.79, stdev=3D7085.53
    clat percentiles (usec):
     |  1.00th=3D[    9],  5.00th=3D[   23], 10.00th=3D[   46], 20.00th=3D[=
  285],
     | 30.00th=3D[ 1287], 40.00th=3D[ 2278], 50.00th=3D[ 4686], 60.00th=3D[=
 6783],
     | 70.00th=3D[11469], 80.00th=3D[13435], 90.00th=3D[17433], 95.00th=3D[=
19792],
     | 99.00th=3D[24511], 99.50th=3D[26346], 99.90th=3D[26346], 99.95th=3D[=
26346],
     | 99.99th=3D[26346]
  lat (usec)   : 10=3D1.56%, 20=3D3.12%, 50=3D7.03%, 100=3D5.47%, 250=3D1.5=
6%
  lat (usec)   : 500=3D3.12%, 750=3D3.91%, 1000=3D3.12%
  lat (msec)   : 2=3D7.81%, 4=3D11.72%, 10=3D19.53%, 20=3D27.34%, 50=3D4.69%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D135, majf=3D5, minf=3D25
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D50.0%, 16=3D50.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D98.4%, 8=3D1.1%, 16=3D0.5%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job6: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2382: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D4266, BW=3D33.3MiB/s (35.0MB/s)(1024KiB/30msec); 0 zone res=
ets
    slat (nsec): min=3D133, max=3D106117, avg=3D2044.11, stdev=3D9968.18
    clat (usec): min=3D7, max=3D11660, avg=3D3046.86, stdev=3D3452.44
     lat (usec): min=3D7, max=3D11662, avg=3D3048.91, stdev=3D3452.70
    clat percentiles (usec):
     |  1.00th=3D[    9],  5.00th=3D[   22], 10.00th=3D[   34], 20.00th=3D[=
   91],
     | 30.00th=3D[  619], 40.00th=3D[  930], 50.00th=3D[ 2057], 60.00th=3D[=
 2737],
     | 70.00th=3D[ 3851], 80.00th=3D[ 5407], 90.00th=3D[10814], 95.00th=3D[=
11600],
     | 99.00th=3D[11600], 99.50th=3D[11600], 99.90th=3D[11600], 99.95th=3D[=
11600],
     | 99.99th=3D[11600]
  lat (usec)   : 10=3D1.56%, 20=3D2.34%, 50=3D10.94%, 100=3D5.47%, 250=3D7.=
03%
  lat (usec)   : 750=3D11.72%, 1000=3D1.56%
  lat (msec)   : 2=3D7.81%, 4=3D26.56%, 10=3D14.06%, 20=3D10.94%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D37, majf=3D3, minf=3D26
  IO depths    : 1=3D0.0%, 2=3D6.2%, 4=3D6.2%, 8=3D75.0%, 16=3D12.5%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D93.5%, 8=3D3.9%, 16=3D2.6%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job6: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2383: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D3200, BW=3D25.0MiB/s (26.2MB/s)(1024KiB/40msec); 0 zone res=
ets
    slat (nsec): min=3D244, max=3D66266, avg=3D2227.13, stdev=3D7105.77
    clat (usec): min=3D7, max=3D24308, avg=3D3503.31, stdev=3D6587.20
     lat (usec): min=3D11, max=3D24309, avg=3D3505.53, stdev=3D6587.27
    clat percentiles (usec):
     |  1.00th=3D[   11],  5.00th=3D[   19], 10.00th=3D[   34], 20.00th=3D[=
  139],
     | 30.00th=3D[  155], 40.00th=3D[  273], 50.00th=3D[  725], 60.00th=3D[=
  889],
     | 70.00th=3D[ 1385], 80.00th=3D[ 5473], 90.00th=3D[18482], 95.00th=3D[=
19006],
     | 99.00th=3D[24249], 99.50th=3D[24249], 99.90th=3D[24249], 99.95th=3D[=
24249],
     | 99.99th=3D[24249]
  lat (usec)   : 10=3D0.78%, 20=3D4.69%, 50=3D7.03%, 100=3D5.47%, 250=3D21.=
88%
  lat (usec)   : 500=3D4.69%, 750=3D10.94%, 1000=3D8.59%
  lat (msec)   : 2=3D13.28%, 10=3D9.38%, 20=3D9.38%, 50=3D3.91%
  cpu          : usr=3D2.56%, sys=3D0.00%, ctx=3D26, majf=3D2, minf=3D25
  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D68.8%, 16=3D31.2%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D93.1%, 8=3D5.0%, 16=3D1.9%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job7: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2384: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D3121, BW=3D24.4MiB/s (25.6MB/s)(1024KiB/41msec); 0 zone res=
ets
    clat (usec): min=3D3, max=3D14454, avg=3D233.47, stdev=3D1499.03
     lat (usec): min=3D3, max=3D14454, avg=3D233.55, stdev=3D1499.06
    clat percentiles (usec):
     |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 20.00th=3D[=
    4],
     | 30.00th=3D[    5], 40.00th=3D[    5], 50.00th=3D[    5], 60.00th=3D[=
    5],
     | 70.00th=3D[    5], 80.00th=3D[    5], 90.00th=3D[    6], 95.00th=3D[=
  122],
     | 99.00th=3D[ 8455], 99.50th=3D[14484], 99.90th=3D[14484], 99.95th=3D[=
14484],
     | 99.99th=3D[14484]
  lat (usec)   : 4=3D22.66%, 10=3D71.09%, 50=3D0.78%, 250=3D0.78%, 750=3D0.=
78%
  lat (msec)   : 2=3D1.56%, 4=3D0.78%, 10=3D0.78%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D13, majf=3D1, minf=3D17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job7: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2385: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D3200, BW=3D25.0MiB/s (26.2MB/s)(1024KiB/40msec); 0 zone res=
ets
    clat (usec): min=3D3, max=3D11767, avg=3D214.75, stdev=3D1229.67
     lat (usec): min=3D3, max=3D11767, avg=3D214.82, stdev=3D1229.69
    clat percentiles (usec):
     |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 20.00th=3D[=
    4],
     | 30.00th=3D[    5], 40.00th=3D[    5], 50.00th=3D[    5], 60.00th=3D[=
    5],
     | 70.00th=3D[    6], 80.00th=3D[    8], 90.00th=3D[   10], 95.00th=3D[=
  130],
     | 99.00th=3D[ 5014], 99.50th=3D[11731], 99.90th=3D[11731], 99.95th=3D[=
11731],
     | 99.99th=3D[11731]
  lat (usec)   : 4=3D21.88%, 10=3D69.53%, 20=3D0.78%, 50=3D1.56%, 100=3D0.7=
8%
  lat (usec)   : 250=3D0.78%, 750=3D0.78%
  lat (msec)   : 2=3D0.78%, 4=3D0.78%, 10=3D1.56%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D12, majf=3D2, minf=3D19
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job7: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2386: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D2976, BW=3D23.3MiB/s (24.4MB/s)(1024KiB/43msec); 0 zone res=
ets
    clat (usec): min=3D3, max=3D12613, avg=3D270.36, stdev=3D1358.23
     lat (usec): min=3D3, max=3D12613, avg=3D270.44, stdev=3D1358.28
    clat percentiles (usec):
     |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 20.00th=3D[=
    5],
     | 30.00th=3D[    5], 40.00th=3D[    5], 50.00th=3D[    5], 60.00th=3D[=
    5],
     | 70.00th=3D[    6], 80.00th=3D[    8], 90.00th=3D[   10], 95.00th=3D[=
 1188],
     | 99.00th=3D[ 6063], 99.50th=3D[12649], 99.90th=3D[12649], 99.95th=3D[=
12649],
     | 99.99th=3D[12649]
  lat (usec)   : 4=3D10.94%, 10=3D79.69%, 20=3D1.56%, 50=3D0.78%, 250=3D0.7=
8%
  lat (usec)   : 750=3D0.78%
  lat (msec)   : 2=3D0.78%, 4=3D2.34%, 10=3D1.56%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D16, majf=3D5, minf=3D16
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job7: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2387: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D1600, BW=3D12.5MiB/s (13.1MB/s)(1024KiB/80msec); 0 zone res=
ets
    clat (usec): min=3D3, max=3D13691, avg=3D554.03, stdev=3D1567.65
     lat (usec): min=3D3, max=3D13691, avg=3D554.20, stdev=3D1567.66
    clat percentiles (usec):
     |  1.00th=3D[    5],  5.00th=3D[    7], 10.00th=3D[    7], 20.00th=3D[=
   10],
     | 30.00th=3D[   77], 40.00th=3D[   99], 50.00th=3D[  135], 60.00th=3D[=
  174],
     | 70.00th=3D[  208], 80.00th=3D[  392], 90.00th=3D[ 1057], 95.00th=3D[=
 2802],
     | 99.00th=3D[ 7111], 99.50th=3D[13698], 99.90th=3D[13698], 99.95th=3D[=
13698],
     | 99.99th=3D[13698]
  lat (usec)   : 4=3D0.78%, 10=3D20.31%, 20=3D2.34%, 50=3D1.56%, 100=3D17.9=
7%
  lat (usec)   : 250=3D30.47%, 500=3D9.38%, 750=3D3.91%, 1000=3D2.34%
  lat (msec)   : 2=3D3.91%, 4=3D3.91%, 10=3D2.34%, 20=3D0.78%
  cpu          : usr=3D1.27%, sys=3D2.53%, ctx=3D125, majf=3D4, minf=3D18
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job7: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2388: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D2976, BW=3D23.3MiB/s (24.4MB/s)(1024KiB/43msec); 0 zone res=
ets
    clat (usec): min=3D3, max=3D11465, avg=3D238.97, stdev=3D1232.98
     lat (usec): min=3D3, max=3D11465, avg=3D239.06, stdev=3D1233.02
    clat percentiles (usec):
     |  1.00th=3D[    4],  5.00th=3D[    4], 10.00th=3D[    4], 20.00th=3D[=
    5],
     | 30.00th=3D[    5], 40.00th=3D[    5], 50.00th=3D[    5], 60.00th=3D[=
    5],
     | 70.00th=3D[    5], 80.00th=3D[    6], 90.00th=3D[   10], 95.00th=3D[=
  619],
     | 99.00th=3D[ 5342], 99.50th=3D[11469], 99.90th=3D[11469], 99.95th=3D[=
11469],
     | 99.99th=3D[11469]
  lat (usec)   : 4=3D10.94%, 10=3D81.25%, 20=3D0.78%, 500=3D0.78%, 750=3D1.=
56%
  lat (msec)   : 2=3D0.78%, 4=3D1.56%, 10=3D1.56%, 20=3D0.78%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D18, majf=3D5, minf=3D17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,128,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job8: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2389: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D29.3k, BW=3D28.6MiB/s (30.0MB/s)(1024KiB/35msec); 0 zone re=
sets
    clat (nsec): min=3D52, max=3D4005.3k, avg=3D21454.89, stdev=3D228411.55
     lat (nsec): min=3D87, max=3D4005.4k, avg=3D21563.28, stdev=3D228409.29
    clat percentiles (nsec):
     |  1.00th=3D[     59],  5.00th=3D[     90], 10.00th=3D[    112],
     | 20.00th=3D[    181], 30.00th=3D[    217], 40.00th=3D[    282],
     | 50.00th=3D[   1304], 60.00th=3D[   1496], 70.00th=3D[   3216],
     | 80.00th=3D[   3536], 90.00th=3D[   5152], 95.00th=3D[  11584],
     | 99.00th=3D[ 272384], 99.50th=3D[1482752], 99.90th=3D[3620864],
     | 99.95th=3D[4014080], 99.99th=3D[4014080]
  lat (nsec)   : 100=3D7.71%, 250=3D29.88%, 500=3D5.47%, 750=3D0.39%, 1000=
=3D0.20%
  lat (usec)   : 2=3D21.19%, 4=3D20.41%, 10=3D7.81%, 20=3D4.88%, 50=3D0.49%
  lat (usec)   : 100=3D0.20%, 250=3D0.29%, 500=3D0.39%, 750=3D0.10%
  lat (msec)   : 2=3D0.20%, 4=3D0.29%, 10=3D0.10%
  cpu          : usr=3D8.82%, sys=3D0.00%, ctx=3D28, majf=3D582, minf=3D19
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1024,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job8: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2390: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D29.3k, BW=3D28.6MiB/s (30.0MB/s)(1024KiB/35msec); 0 zone re=
sets
    clat (nsec): min=3D50, max=3D3672.6k, avg=3D21308.01, stdev=3D213632.75
     lat (nsec): min=3D85, max=3D3672.7k, avg=3D21416.38, stdev=3D213630.86
    clat percentiles (nsec):
     |  1.00th=3D[     56],  5.00th=3D[     75], 10.00th=3D[    104],
     | 20.00th=3D[    177], 30.00th=3D[    211], 40.00th=3D[    378],
     | 50.00th=3D[   1304], 60.00th=3D[   2928], 70.00th=3D[   3248],
     | 80.00th=3D[   3632], 90.00th=3D[   5472], 95.00th=3D[  11840],
     | 99.00th=3D[ 296960], 99.50th=3D[1515520], 99.90th=3D[2932736],
     | 99.95th=3D[3686400], 99.99th=3D[3686400]
  lat (nsec)   : 100=3D9.38%, 250=3D26.95%, 500=3D5.37%, 750=3D0.39%
  lat (usec)   : 2=3D16.70%, 4=3D25.68%, 10=3D8.89%, 20=3D4.69%, 50=3D0.88%
  lat (usec)   : 500=3D0.20%, 750=3D0.20%
  lat (msec)   : 2=3D0.20%, 4=3D0.49%
  cpu          : usr=3D8.82%, sys=3D0.00%, ctx=3D20, majf=3D599, minf=3D19
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1024,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job8: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2391: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D41.0k, BW=3D40.0MiB/s (41.9MB/s)(1024KiB/25msec); 0 zone re=
sets
    clat (nsec): min=3D49, max=3D2654.1k, avg=3D8722.09, stdev=3D117739.66
     lat (nsec): min=3D84, max=3D2654.2k, avg=3D8769.59, stdev=3D117739.76
    clat percentiles (nsec):
     |  1.00th=3D[     51],  5.00th=3D[     58], 10.00th=3D[     74],
     | 20.00th=3D[     96], 30.00th=3D[    114], 40.00th=3D[    147],
     | 50.00th=3D[    205], 60.00th=3D[   1224], 70.00th=3D[   1320],
     | 80.00th=3D[   1432], 90.00th=3D[   1848], 95.00th=3D[   2416],
     | 99.00th=3D[  10048], 99.50th=3D[ 411648], 99.90th=3D[1990656],
     | 99.95th=3D[2637824], 99.99th=3D[2637824]
  lat (nsec)   : 50=3D0.20%, 100=3D22.07%, 250=3D28.81%, 500=3D2.25%, 750=
=3D0.10%
  lat (usec)   : 2=3D38.09%, 4=3D4.88%, 10=3D2.54%, 20=3D0.29%, 50=3D0.10%
  lat (usec)   : 500=3D0.29%, 750=3D0.10%
  lat (msec)   : 2=3D0.20%, 4=3D0.10%
  cpu          : usr=3D4.17%, sys=3D0.00%, ctx=3D13, majf=3D477, minf=3D21
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1024,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job8: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2392: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D33.0k, BW=3D32.3MiB/s (33.8MB/s)(1024KiB/31msec); 0 zone re=
sets
    clat (nsec): min=3D53, max=3D3093.6k, avg=3D17587.87, stdev=3D179151.15
     lat (nsec): min=3D91, max=3D3093.7k, avg=3D17708.65, stdev=3D179151.47
    clat percentiles (nsec):
     |  1.00th=3D[     56],  5.00th=3D[     59], 10.00th=3D[     80],
     | 20.00th=3D[    181], 30.00th=3D[    241], 40.00th=3D[    282],
     | 50.00th=3D[   1240], 60.00th=3D[   3216], 70.00th=3D[   3504],
     | 80.00th=3D[   3792], 90.00th=3D[   5472], 95.00th=3D[  11072],
     | 99.00th=3D[ 189440], 99.50th=3D[ 937984], 99.90th=3D[2736128],
     | 99.95th=3D[3096576], 99.99th=3D[3096576]
  lat (nsec)   : 100=3D12.40%, 250=3D20.12%, 500=3D15.14%, 750=3D0.39%
  lat (usec)   : 2=3D9.67%, 4=3D24.22%, 10=3D10.84%, 20=3D5.47%, 50=3D0.68%
  lat (usec)   : 250=3D0.20%, 500=3D0.10%, 750=3D0.10%, 1000=3D0.20%
  lat (msec)   : 2=3D0.10%, 4=3D0.39%
  cpu          : usr=3D0.00%, sys=3D13.33%, ctx=3D18, majf=3D531, minf=3D21
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1024,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job8: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2393: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D39.4k, BW=3D38.5MiB/s (40.3MB/s)(1024KiB/26msec); 0 zone re=
sets
    clat (nsec): min=3D50, max=3D3405.8k, avg=3D9250.34, stdev=3D122881.30
     lat (nsec): min=3D85, max=3D3405.8k, avg=3D9331.42, stdev=3D122880.20
    clat percentiles (nsec):
     |  1.00th=3D[     55],  5.00th=3D[     59], 10.00th=3D[     70],
     | 20.00th=3D[     85], 30.00th=3D[     99], 40.00th=3D[    117],
     | 50.00th=3D[    215], 60.00th=3D[   1272], 70.00th=3D[   1416],
     | 80.00th=3D[   1576], 90.00th=3D[   4576], 95.00th=3D[   5472],
     | 99.00th=3D[  34560], 99.50th=3D[ 399360], 99.90th=3D[1155072],
     | 99.95th=3D[3391488], 99.99th=3D[3391488]
  lat (nsec)   : 100=3D30.66%, 250=3D20.41%, 500=3D4.69%, 750=3D0.49%
  lat (usec)   : 2=3D27.73%, 4=3D3.81%, 10=3D9.47%, 20=3D1.46%, 50=3D0.49%
  lat (usec)   : 250=3D0.10%, 500=3D0.20%, 750=3D0.10%, 1000=3D0.10%
  lat (msec)   : 2=3D0.20%, 4=3D0.10%
  cpu          : usr=3D8.00%, sys=3D0.00%, ctx=3D18, majf=3D450, minf=3D20
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,1024,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job9: (groupid=3D0, jobs=3D1): err=3D 5 (file:engines/mmap.c:257, func=3Dms=
ync, error=3DInput/output error): pid=3D2394: Mon Oct 11 16:33:05 2021
  write: IOPS=3D7757, BW=3D30.1MiB/s (31.5MB/s)(1016KiB/33msec); 0 zone res=
ets
    clat (usec): min=3D23, max=3D3399, avg=3D49.62, stdev=3D216.57
     lat (usec): min=3D23, max=3D3399, avg=3D49.70, stdev=3D216.57
    clat percentiles (usec):
     |  1.00th=3D[   24],  5.00th=3D[   24], 10.00th=3D[   25], 20.00th=3D[=
   26],
     | 30.00th=3D[   27], 40.00th=3D[   28], 50.00th=3D[   30], 60.00th=3D[=
   31],
     | 70.00th=3D[   32], 80.00th=3D[   35], 90.00th=3D[   37], 95.00th=3D[=
   49],
     | 99.00th=3D[  388], 99.50th=3D[  578], 99.90th=3D[ 3392], 99.95th=3D[=
 3392],
     | 99.99th=3D[ 3392]
  lat (usec)   : 50=3D94.92%, 100=3D1.56%, 250=3D1.17%, 500=3D0.78%, 750=3D=
0.39%
  lat (msec)   : 4=3D0.39%
  cpu          : usr=3D0.00%, sys=3D25.00%, ctx=3D20, majf=3D256, minf=3D26
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,256,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D2, first_error=3D5/<Input/output error>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job9: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2395: Mon Oct 11 16:33:05 20=
21
  write: IOPS=3D14.2k, BW=3D55.6MiB/s (58.3MB/s)(1024KiB/18msec); 0 zone re=
sets
    clat (usec): min=3D24, max=3D2564, avg=3D60.04, stdev=3D225.97
     lat (usec): min=3D24, max=3D2564, avg=3D60.14, stdev=3D225.97
    clat percentiles (usec):
     |  1.00th=3D[   25],  5.00th=3D[   26], 10.00th=3D[   26], 20.00th=3D[=
   28],
     | 30.00th=3D[   30], 40.00th=3D[   32], 50.00th=3D[   32], 60.00th=3D[=
   34],
     | 70.00th=3D[   35], 80.00th=3D[   39], 90.00th=3D[   44], 95.00th=3D[=
   50],
     | 99.00th=3D[  742], 99.50th=3D[ 2409], 99.90th=3D[ 2573], 99.95th=3D[=
 2573],
     | 99.99th=3D[ 2573]
  lat (usec)   : 50=3D94.92%, 100=3D2.34%, 250=3D0.39%, 500=3D0.78%, 750=3D=
0.78%
  lat (msec)   : 4=3D0.78%
  cpu          : usr=3D0.00%, sys=3D47.06%, ctx=3D27, majf=3D261, minf=3D16
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,256,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D0, first_error=3D0/<Success>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job9: (groupid=3D0, jobs=3D1): err=3D 5 (file:engines/mmap.c:257, func=3Dms=
ync, error=3DInput/output error): pid=3D2396: Mon Oct 11 16:33:05 2021
  write: IOPS=3D12.2k, BW=3D47.4MiB/s (49.7MB/s)(1020KiB/21msec); 0 zone re=
sets
    clat (usec): min=3D25, max=3D4368, avg=3D70.05, stdev=3D295.82
     lat (usec): min=3D25, max=3D4368, avg=3D70.18, stdev=3D295.83
    clat percentiles (usec):
     |  1.00th=3D[   26],  5.00th=3D[   27], 10.00th=3D[   28], 20.00th=3D[=
   31],
     | 30.00th=3D[   32], 40.00th=3D[   34], 50.00th=3D[   36], 60.00th=3D[=
   38],
     | 70.00th=3D[   40], 80.00th=3D[   44], 90.00th=3D[   74], 95.00th=3D[=
   88],
     | 99.00th=3D[  857], 99.50th=3D[ 1680], 99.90th=3D[ 4359], 99.95th=3D[=
 4359],
     | 99.99th=3D[ 4359]
  lat (usec)   : 50=3D82.81%, 100=3D14.45%, 250=3D0.78%, 750=3D0.39%, 1000=
=3D0.39%
  lat (msec)   : 2=3D0.39%, 10=3D0.39%
  cpu          : usr=3D15.00%, sys=3D35.00%, ctx=3D18, majf=3D264, minf=3D23
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,256,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D1, first_error=3D5/<Input/output error>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job9: (groupid=3D0, jobs=3D1): err=3D 5 (file:engines/mmap.c:257, func=3Dms=
ync, error=3DInput/output error): pid=3D2397: Mon Oct 11 16:33:05 2021
  write: IOPS=3D7529, BW=3D29.1MiB/s (30.5MB/s)(1012KiB/34msec); 0 zone res=
ets
    clat (usec): min=3D23, max=3D3350, avg=3D66.34, stdev=3D234.18
     lat (usec): min=3D23, max=3D3350, avg=3D66.48, stdev=3D234.18
    clat percentiles (usec):
     |  1.00th=3D[   25],  5.00th=3D[   26], 10.00th=3D[   26], 20.00th=3D[=
   28],
     | 30.00th=3D[   31], 40.00th=3D[   32], 50.00th=3D[   35], 60.00th=3D[=
   38],
     | 70.00th=3D[   42], 80.00th=3D[   47], 90.00th=3D[   53], 95.00th=3D[=
   78],
     | 99.00th=3D[ 1029], 99.50th=3D[ 1172], 99.90th=3D[ 3359], 99.95th=3D[=
 3359],
     | 99.99th=3D[ 3359]
  lat (usec)   : 50=3D86.72%, 100=3D7.81%, 250=3D1.17%, 500=3D1.56%, 750=3D=
0.39%
  lat (msec)   : 2=3D0.78%, 4=3D0.39%
  cpu          : usr=3D0.00%, sys=3D30.30%, ctx=3D19, majf=3D256, minf=3D26
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,256,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D3, first_error=3D5/<Input/output error>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16
job9: (groupid=3D0, jobs=3D1): err=3D 5 (file:engines/mmap.c:257, func=3Dms=
ync, error=3DInput/output error): pid=3D2398: Mon Oct 11 16:33:05 2021
  write: IOPS=3D5953, BW=3D23.0MiB/s (24.1MB/s)(1012KiB/43msec); 0 zone res=
ets
    clat (usec): min=3D25, max=3D4743, avg=3D85.07, stdev=3D312.28
     lat (usec): min=3D25, max=3D4743, avg=3D85.33, stdev=3D312.27
    clat percentiles (usec):
     |  1.00th=3D[   27],  5.00th=3D[   28], 10.00th=3D[   29], 20.00th=3D[=
   35],
     | 30.00th=3D[   37], 40.00th=3D[   44], 50.00th=3D[   49], 60.00th=3D[=
   55],
     | 70.00th=3D[   60], 80.00th=3D[   65], 90.00th=3D[   80], 95.00th=3D[=
  141],
     | 99.00th=3D[  881], 99.50th=3D[ 1090], 99.90th=3D[ 4752], 99.95th=3D[=
 4752],
     | 99.99th=3D[ 4752]
  lat (usec)   : 50=3D50.78%, 100=3D42.19%, 250=3D2.73%, 500=3D1.17%, 750=
=3D0.78%
  lat (usec)   : 1000=3D0.39%
  lat (msec)   : 2=3D0.39%, 10=3D0.39%
  cpu          : usr=3D7.14%, sys=3D21.43%, ctx=3D34, majf=3D257, minf=3D28
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,256,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     errors    : total=3D3, first_error=3D5/<Input/output error>
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D16

Run status group 0 (all jobs):
   READ: bw=3D333MiB/s (350MB/s), 66.7MiB/s-90.9MiB/s (69.9MB/s-95.3MB/s), =
io=3D5120KiB (5243kB), run=3D11-15msec
  WRITE: bw=3D375MiB/s (393MB/s), 12.5MiB/s-55.6MiB/s (13.1MB/s-58.3MB/s), =
io=3D30.0MiB (31.4MB), run=3D18-80msec

Disk stats (read/write):
  zram1: ios=3D549/3114, merge=3D0/0, ticks=3D0/40, in_queue=3D40, util=3D2=
9.07%
fio: file hash not empty on exit

--XDQXnkBg5OCdiKiz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="095.out.bad"

QA output created by 095
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=275456, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=416768, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=233472, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=247808, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
fio: io_u_queue.h:37: io_u_qpush: Assertion '0' failed.
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
fio: io_u_queue.h:37: io_u_qpush: Assertion '0' failed.
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=43008, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=114688, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=241664, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=115712, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=370688, buflen=1024
fio: io_u_queue.h:37: io_u_qpush: Assertion '0' failed.
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
fio: pid=2364, got signal=6
fio: pid=2367, got signal=6
fio: pid=2368, got signal=6
fio: file hash not empty on exit
Silence is golden

--XDQXnkBg5OCdiKiz--
