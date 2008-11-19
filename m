Return-Path: <fio-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:51824 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYKSLaR (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2008 06:30:17 -0500
Date: Wed, 19 Nov 2008 12:28:29 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Passing argument to both write_bw_log & write_lat_log leads to segfault
Message-ID: <20081119112829.GA26308@kernel.dk>
References: <4923F729.1030200@seanodes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4923F729.1030200@seanodes.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@seanodes.com>
Cc: fio@vger.kernel.org

On Wed, Nov 19 2008, Erwan Velu wrote:
> Using fio 1.23:
> [root@max13 tmp]# fio myconfigfile
> Segmentation fault (core dumped)
> 
> 
> Where myconfigfile is the following:
> [global]
> bsrange=64k-128k,64k-128k
> direct=1
> ioengine=libaio
> iodepth=2
> zonesize=256m
> zoneskip=2g
> 
> [/dev/exa/g1/v1]
> rw=read
> write_bw_log read-bw
> write_lat_log read-lat
> 
> [/dev/exa/g1/v1]
> stonewall
> rw=write
> write_bw_log write-bw
> write_lat_log write-lat
> 
> Note: removing one or the other parameter to write_*_log reports an error 
> like "Bad option write_lat_log read-lat" but letting both of them segfault.
> 
> I did this syntaxe as the man page says :
>       write_bw_log
>              If given, write bandwidth logs of the jobs in this file.
> 
> I thought that "this file" meant a parameter.

Wow, you are handy at finding old bugs that nobody has hit :-). The
below should fix it.

Generally, fio always wants a '=' to assign a value to a parameter. But
of course the parser should not crash...

diff --git a/parse.c b/parse.c
index 456e3ba..5f7d033 100644
--- a/parse.c
+++ b/parse.c
@@ -487,7 +487,7 @@ static int opt_cmp(const void *p1, const void *p2)
 {
 	struct fio_option *o1, *o2;
 	char *s1, *s2, *foo;
-	int ret;
+	int prio1, prio2;
 
 	s1 = strdup(*((char **) p1));
 	s2 = strdup(*((char **) p2));
@@ -495,14 +495,15 @@ static int opt_cmp(const void *p1, const void *p2)
 	o1 = get_option(s1, fio_options, &foo);
 	o2 = get_option(s2, fio_options, &foo);
 
-	if ((!o1 && o2) || (o1 && !o2))
-		ret = 0;
-	else
-		ret = o2->prio - o1->prio;
+	prio1 = prio2 = 0;
+	if (o1)
+		prio1 = o1->prio;
+	if (o2)
+		prio2 = o2->prio;
 
 	free(s1);
 	free(s2);
-	return ret;
+	return prio2 - prio1;
 }
 
 void sort_options(char **opts, struct fio_option *options, int num_opts)

-- 
Jens Axboe

