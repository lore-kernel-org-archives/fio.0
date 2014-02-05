Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 12:30:06 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
Message-ID: <20140205193006.GH27534@kernel.dk>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
 <CANEJEGuTmYm2k1M3BUmoxCVD99wCTyLjyRrT9HS=MMFBStrA5A@mail.gmail.com>
 <CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
 <20140205182718.GG27534@kernel.dk>
 <CANEJEGsdxoLrJ7o22tVtCw1s8XwHeDJ7znwSYsFR6BvM7pQrPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGsdxoLrJ7o22tVtCw1s8XwHeDJ7znwSYsFR6BvM7pQrPw@mail.gmail.com>
To: Grant Grundler <grundler@chromium.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Grant Grundler wrote:
> On Wed, Feb 5, 2014 at 10:27 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > On Tue, Feb 04 2014, Puthikorn Voravootivat wrote:
> >> I tried to run the same test with fio 2.1.3 and saw the same error.
> >> This error always occurs when rw=read or randread and verify_backlog=1
> >>
> >> Here is an example job file and error message.
> >>
> >> Job file:
> >> [md5-sync-1-0-1-1-1]
> >> filename=test213/fio/md5-sync-1-0-1-1-1
> >> loops=1
> >> direct=0
> >> iodepth=1
> >> ioengine=sync
> >> verify=md5
> >> size=1m
> >> bs=4k
> >> rw=read
> >> verifysort=1
> >> verify_backlog=1
> >>
> >> Error message:
> >> verify: bad magic header 869, wanted acca at file
> >> test213/fio/md5-sync-1-0-1-1-1 offset 585728, length 2290190
> >
> > This is indeed breakage between 2.1.2 and 2.1.3. I ran a bisect on it,
> > it reveals:
> >
> > 20876c53b5d32f2da9049af5e7fb102133946981 is the first bad commit
> > commit 20876c53b5d32f2da9049af5e7fb102133946981
> > Author: Juan Casse <jcasse@chromium.org>
> > Date:   Mon Sep 16 09:22:10 2013 -0700
> >
> >     Add condition to stop issuing io in do_io().
> 
> I think Puthik has a fix related to this but I haven't reviewed his
> next patch yet.  We've been talking about this behavior though.
> 
> I'll take another look at this patch to see what it's changing.

The below should take care of it. Juan's fix didn't account for verify
exceeding size=.

diff --git a/backend.c b/backend.c
index bf9d066e012a..3ac72e771cb9 100644
--- a/backend.c
+++ b/backend.c
@@ -642,7 +642,7 @@ static uint64_t do_io(struct thread_data *td)
 	uint64_t bytes_done[DDIR_RWDIR_CNT] = { 0, 0, 0 };
 	unsigned int i;
 	int ret = 0;
-	uint64_t bytes_issued = 0;
+	uint64_t total_bytes, bytes_issued = 0;
 
 	if (in_ramp_time(td))
 		td_set_runstate(td, TD_RAMP);
@@ -651,6 +651,10 @@ static uint64_t do_io(struct thread_data *td)
 
 	lat_target_init(td);
 
+	total_bytes = td->o.size;
+	if (td->o.verify != VERIFY_NONE && td_write(td))
+		total_bytes += td->o.size;
+
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
 		(!flist_empty(&td->trim_list)) || !io_bytes_exceeded(td) ||
 		td->o.time_based) {
@@ -678,7 +682,7 @@ static uint64_t do_io(struct thread_data *td)
 		if (flow_threshold_exceeded(td))
 			continue;
 
-		if (bytes_issued >= (uint64_t) td->o.size)
+		if (bytes_issued >= total_bytes)
 			break;
 
 		io_u = get_io_u(td);

-- 
Jens Axboe


