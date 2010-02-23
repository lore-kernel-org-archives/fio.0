Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0BWJgL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Feb 2010 04:36:11 -0500
Date: Tue, 23 Feb 2010 10:36:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Verification failures with mixed read/write case
Message-ID: <20100223093610.GQ1025@kernel.dk>
References: <1266456009.19149.72.camel@cfslap.wizy.org> <20100223092849.GP1025@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223092849.GP1025@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Cc: fio@vger.kernel.org

On Tue, Feb 23 2010, Jens Axboe wrote:
> On Thu, Feb 18 2010, Ricardo M. Correia wrote:
> > (Please CC me in the reply, I'm not subscribed)
> > 
> > Hi,
> > 
> > I've been observing verification failures with the following
> > configuration file:
> > 
> > -----------
> > [global]
> > ioengine=libaio
> > iodepth=30
> > rw=randrw
> > bs=512-128k
> > direct=1
> > rwmixcycle=40
> > verify=sha256
> > verify_async=8
> > 
> > [/dev/sda2]
> > --------------------
> > 
> > This happens on both RHEL5.4 and Ubuntu 9.10.
> > 
> > I was observing that with fio-1.36, but I just tried cloning fio from
> > the git repo and I'm experiencing the same problem.
> > 
> > Any ideas of what might be wrong?
> > 
> > I found this email of a few months ago:
> > http://www.spinics.net/lists/fio/msg00205.html
> > 
> > And I just verified that this patch is in my just-cloned git tree.
> 
> Mixed read-write workloads generally don't work well with verify. The
> reason being that if you do verify && read, then fio will assume that
> you want to verify previously written data. That should not happen for a
> generated read as part of a mixed workload, I'll check what happens
> here.

OK, so this seems to be just a bug in sha256, it's working as expected
here. Can you try the below patch?

diff --git a/verify.c b/verify.c
index 59f1ddf..c894b60 100644
--- a/verify.c
+++ b/verify.c
@@ -212,7 +212,7 @@ static int verify_io_u_sha256(struct verify_header *hdr, struct io_u *io_u,
 {
 	void *p = io_u_verify_off(hdr, io_u, header_num);
 	struct vhdr_sha256 *vh = hdr_priv(hdr);
-	uint8_t sha256[128];
+	uint8_t sha256[64];
 	struct sha256_ctx sha256_ctx = {
 		.buf = sha256,
 	};
diff --git a/verify.h b/verify.h
index c12bc7d..be98c54 100644
--- a/verify.h
+++ b/verify.h
@@ -37,7 +37,7 @@ struct vhdr_sha512 {
 	uint8_t sha512[128];
 };
 struct vhdr_sha256 {
-	uint8_t sha256[128];
+	uint8_t sha256[64];
 };
 struct vhdr_sha1 {
 	uint32_t sha1[5];

-- 
Jens Axboe

