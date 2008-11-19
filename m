Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:58914 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYKSPVx (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2008 10:21:53 -0500
Date: Wed, 19 Nov 2008 16:20:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Passing argument to both write_bw_log & write_lat_log leads to segfault
Message-ID: <20081119152004.GP26308@kernel.dk>
References: <4923F729.1030200@seanodes.com> <20081119112829.GA26308@kernel.dk> <49242C63.2040005@seanodes.com> <20081119151534.GO26308@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119151534.GO26308@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Wed, Nov 19 2008, Jens Axboe wrote:
> On Wed, Nov 19 2008, Erwan Velu wrote:
> > Jens Axboe wrote:
> > 
> > [....]
> > >Wow, you are handy at finding old bugs that nobody has hit :-). The
> > >below should fix it.
> > >  
> > Hehe :p
> > >Generally, fio always wants a '=' to assign a value to a parameter. But
> > >of course the parser should not crash...
> > >  
> > Ok. It that configuration correct ?
> > 
> > [global]
> > bsrange=64k-128k,64k-128k
> > direct=1
> > ioengine=libaio
> > iodepth=64
> > zonesize=256m
> > zoneskip=2g
> > 
> > [/dev/sdb]
> > rw=read
> > write_bw_log=read-bw
> > write_lat_log=read-lat
> > 
> > [/dev/sdb]
> > stonewall
> > rw=write
> > write_bw_log=write-bw
> > write_lat_log=write-lat
> > 
> > If yes, I have a problem because I only have files called : sdb_clat.log 
> > & sdb_slat.log
> 
> They don't accept a parameter. I can rectify that, I guess sometimes
> you'd like that (especially for big jobs). The log should contain
> entries from both, with a direction field.
> 
> Let me double check tonight and make sure it doesn't truncate the log or
> anything like that, I don't think I've ever used the log like this. It
> should just append.

OK, it truncates. This will help. I'll have it accept file names as well
later today.

diff --git a/log.c b/log.c
index 5c468ad..ab457c7 100644
--- a/log.c
+++ b/log.c
@@ -388,7 +388,7 @@ static int init_iolog_write(struct thread_data *td)
 	FILE *f;
 	unsigned int i;
 
-	f = fopen(td->o.write_iolog_file, "w+");
+	f = fopen(td->o.write_iolog_file, "a");
 	if (!f) {
 		perror("fopen write iolog");
 		return 1;
@@ -455,7 +455,7 @@ void __finish_log(struct io_log *log, const char *name)
 	unsigned int i;
 	FILE *f;
 
-	f = fopen(name, "w");
+	f = fopen(name, "a");
 	if (!f) {
 		perror("fopen log");
 		return;

-- 
Jens Axboe

