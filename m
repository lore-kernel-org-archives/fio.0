Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3IIVSv (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 9 Sep 2013 17:18:51 -0400
Message-ID: <522E3B2D.5060400@kernel.dk>
Date: Mon, 09 Sep 2013 15:18:37 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: io_u requeue and resubmit
References: <COL131-W737F4B7642E5118C84B254B53F0@phx.gbl>
In-Reply-To: <COL131-W737F4B7642E5118C84B254B53F0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh P <suresh_p_@hotmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/09/2013 12:32 PM, Suresh P wrote:
> I have a question on requeue_io_u. Code source lines reference here are from version fio-2.1.2.
> 
> Does a requeued io_u work get submitted again through __get_io_u() ? If so, the io_u item is taken out of requeue list & then the io_u->file is set to NULL. We don't make a distinction about item being already setup Vs a new io_u in __get_io_u(). In get_io_u(), when an io_u may come out of requeue list, we depend on io_u->file to be non NULL to detect the work as old pending one.
> 
> Am I missing something here or is this a bug?
> 
> 1274         io_u = __get_io_u(td);
> 1275         if (!io_u) {
> 1276                 dprint(FD_IO, "__get_io_u failed\n");
> 1277                 return NULL;
> 1278         }
> 1279 
> 1280         if (check_get_verify(td, io_u))
> 1281                 goto out;
> 1282         if (check_get_trim(td, io_u))
> 1283                 goto out;
> 1284 
> 1285         /*
> 1286          * from a requeue, io_u already setup
> 1287          */
> 1288         if (io_u->file)
> 1289                 goto out;
> 1290 
> "io_u.c" line 1286 of 1667 --77%-- col 3-10
> 
> 
> 1130 struct io_u *__get_io_u(struct thread_data *td)
> 1131 {
> 1132         struct io_u *io_u;
> 1133 
> 1134         td_io_u_lock(td);
> 1135 
> 1136 again:
> 1137         if (!io_u_rempty(&td->io_u_requeues))
> 1138                 io_u = io_u_rpop(&td->io_u_requeues);
> 1139         else if (!io_u_qempty(&td->io_u_freelist))
> 1140                 io_u = io_u_qpop(&td->io_u_freelist);
> 1141 
> 1142         if (io_u) {
> 1143                 io_u->buflen = 0;
> 1144                 io_u->resid = 0;
> 1145                 io_u->file = NULL;
> 1146                 io_u->end_io = NULL;
> 1147         }
> "io_u.c" line 1130 of 1667 --67%-- col 1

Good catch! It was actually broken a few revisions back with the ring
lists. Fixed:

http://git.kernel.dk/?p=fio.git;a=commit;h=f713350f74dbeb333ff1ad2790cb60381ceaf463

-- 
Jens Axboe

