Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:33197
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1IHLcx (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Sep 2011 07:32:53 -0400
Message-ID: <4E68A7E4.2020005@kernel.dk>
Date: Thu, 08 Sep 2011 13:32:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: problem while executing fio on multiple disks
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B02CF0A@MYMBX.MY.STEC-INC.AD> <4E68A7C9.1020702@kernel.dk>
In-Reply-To: <4E68A7C9.1020702@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shrirang Phansalkar <sphansalkar@stec-inc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Prasad Joshi <pjoshi@stec-inc.com>

On 2011-09-08 13:32, Jens Axboe wrote:
> Hmm, I'm assuming the performance is about the same (whether run with
> this file, or separately)?
> 
> Looks like the utilization is done prior to the job being started, hence
> you get ~100%, ~50%, and ~33%. So looks like just an accounting bug,
> I'll take a look at it.

Does this work? Completely untested...

diff --git a/fio.c b/fio.c
index 4514840..b492889 100644
--- a/fio.c
+++ b/fio.c
@@ -1502,10 +1502,8 @@ static void run_threads(void)
 	for_each_td(td, i) {
 		print_status_init(td->thread_number - 1);
 
-		if (!td->o.create_serialize) {
-			init_disk_util(td);
+		if (!td->o.create_serialize)
 			continue;
-		}
 
 		/*
 		 * do file setup here so it happens sequentially,
@@ -1533,8 +1531,6 @@ static void run_threads(void)
 					td_io_close_file(td, f);
 			}
 		}
-
-		init_disk_util(td);
 	}
 
 	set_genesis_time();
@@ -1573,6 +1569,8 @@ static void run_threads(void)
 				break;
 			}
 
+			init_disk_util(td);
+
 			/*
 			 * Set state to created. Thread will transition
 			 * to TD_INITIALIZED when it's done setting up.

-- 
Jens Axboe

