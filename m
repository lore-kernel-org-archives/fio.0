Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348Ab2JXGhT (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Oct 2012 02:37:19 -0400
Message-ID: <50878C9C.80900@kernel.dk>
Date: Wed, 24 Oct 2012 08:37:16 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] rdma ioengine improvement
References: <1350955778-27682-1-git-send-email-yufei.ren@stonybrook.edu> <1350955778-27682-2-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350955778-27682-2-git-send-email-yufei.ren@stonybrook.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org, Yufei Ren <renyufei83@gmail.com>

On 2012-10-23 03:29, Yufei Ren wrote:
> From: Yufei Ren <renyufei83@gmail.com>
> 
> 1) Use fio shipped reentrant and thread-safe rand to replace buggy rand().
> 2) Add a pause time period before client start committing IOs.
> 	In SEND/RECV test, it's a good practice to setup the iodepth of
> 	of the RECV side deeper than that of the SEND side to
> 	avoid RNR (receiver not ready) error. The
> 	SEND side may send so many unsolicited message before
> 	RECV side commits sufficient recv buffers into recv queue.
> 	This may lead to RNR error. Here, SEND side pauses for a while
> 	during which RECV side commits sufficient recv buffers.
> 3) Fix server thread hanging bug.
> 	For RDMA WRITE/READ test, No IO bytes are accumulated in server side
> 	during test. Server thread indicates its task completion by changing
> 	its state into `done' as an alternitive. Add `td->done' checking in
> 	do_io().
> 4) Some comments revision.
> 	export EXTFLAGS and EXTLIBS with '+=".
> 	explanation on exchanging steps of RDMA ioengine control messages.

I applied the below on top. We can't reuse td->__random_state, as
that'll impact the generation of random numbers used for IO unit
offsets.

diff --git a/engines/rdma.c b/engines/rdma.c
index 2633432..87b061a 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -119,6 +119,8 @@ struct rdmaio_data {
 	int io_u_flight_nr;
 	struct io_u **io_us_completed;
 	int io_u_completed_nr;
+
+	struct frand_state rand_state;
 };
 
 static int client_recv(struct thread_data *td, struct ibv_wc *wc)
@@ -617,7 +619,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 			if (td->o.use_os_rand)
 				index = os_random_long(&td->random_state) % rd->rmt_nr;
 			else
-				index = __rand(&td->__random_state) % rd->rmt_nr;
+				index = __rand(&rd->rand_state) % rd->rmt_nr;
 			r_io_u_d->sq_wr.opcode = IBV_WR_RDMA_WRITE;
 			r_io_u_d->sq_wr.wr.rdma.rkey = rd->rmt_us[index].rkey;
 			r_io_u_d->sq_wr.wr.rdma.remote_addr = \
@@ -630,7 +632,7 @@ static int fio_rdmaio_send(struct thread_data *td, struct io_u **io_us,
 			if (td->o.use_os_rand)
 				index = os_random_long(&td->random_state) % rd->rmt_nr;
 			else
-				index = __rand(&td->__random_state) % rd->rmt_nr;
+				index = __rand(&rd->rand_state) % rd->rmt_nr;
 			r_io_u_d->sq_wr.opcode = IBV_WR_RDMA_READ;
 			r_io_u_d->sq_wr.wr.rdma.rkey = rd->rmt_us[index].rkey;
 			r_io_u_d->sq_wr.wr.rdma.remote_addr = \
@@ -1210,6 +1212,7 @@ static int fio_rdmaio_setup(struct thread_data *td)
 		rd = malloc(sizeof(*rd));;
 
 		memset(rd, 0, sizeof(*rd));
+		init_rand_seed(&rd->rand_state, GOLDEN_RATIO_PRIME);
 		td->io_ops->data = rd;
 	}
 

-- 
Jens Axboe

